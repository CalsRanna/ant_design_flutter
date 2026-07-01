import 'dart:math' as math;
import 'dart:typed_data';

/// QR Code 编码引擎。零依赖纯 Dart 实现。
/// 支持 Version 1-4、Byte 模式、纠错级别 L/M。
class QrEncoder {
  QrEncoder._();

  /// 编码 [data] 为 QR Code 矩阵（二维 bool 数组，true=黑）。
  static List<List<bool>> encode(String data, {QrEcc ecc = QrEcc.l}) {
    final bytes = Uint8List.fromList(data.codeUnits);
    final version = _selectVersion(bytes.length, ecc);
    final eccCodeWords = _eccCodeWords(version, ecc);
    final totalDataWords = _totalDataWords(version, ecc);

    // 1. 编码数据
    final encoded = _encodeData(bytes, version, ecc);

    // 2. 填充到数据码字长度
    while (encoded.length < totalDataWords) {
      encoded.add(_padBytes[(encoded.length - bytes.length - 3) % 2]);
    }

    // 3. RS 纠错
    final eccWords = _rsEncode(encoded, eccCodeWords);

    // 4. 合并
    final allBits = _interleave(encoded, eccWords, version, ecc);

    // 5. 构建矩阵
    final size = _versionSize(version);
    final matrix = List.generate(size, (_) => List.filled(size, false));

    // 6. 摆放功能图案
    _placeFinderPatterns(matrix);
    _placeTimingPatterns(matrix);
    _placeDarkModule(matrix);
    _placeAlignmentPatterns(matrix, version);

    // 7. 摆放数据
    _placeData(matrix, allBits);

    // 8. 选择最优掩模
    final bestMask = _findBestMask(matrix);
    _applyMask(matrix, bestMask);

    // 9. 摆放格式信息
    _placeFormatInfo(matrix, bestMask, ecc);

    return matrix;
  }

  // === 版本与容量 ===

  static const _versions = [
    // (version, total codewords, ec codewords L, ec codewords M, data codewords L, data codewords M, capacity L byte)
    (1, 26, 7, 10, 19, 16, 17),
    (2, 44, 10, 16, 34, 28, 32),
    (3, 70, 15, 26, 55, 44, 53),
    (4, 100, 20, 36, 80, 64, 78),
  ];

  static int _selectVersion(int dataLen, QrEcc ecc) {
    for (final v in _versions) {
      final cap = ecc == QrEcc.l ? v.$6 : v.$7;
      if (dataLen <= cap) return v.$1;
    }
    throw ArgumentError('Data too long for QR Code');
  }

  static int _eccCodeWords(int version, QrEcc ecc) {
    for (final v in _versions) {
      if (v.$1 == version) return ecc == QrEcc.l ? v.$3 : v.$4;
    }
    return 0;
  }

  static int _totalDataWords(int version, QrEcc ecc) {
    for (final v in _versions) {
      if (v.$1 == version) return ecc == QrEcc.l ? v.$5 : v.$6;
    }
    return 0;
  }

  static int _versionSize(int version) => version * 4 + 17;

  static const _padBytes = [0xEC, 0x11];

  // === Byte 模式编码 ===

  static List<int> _encodeData(Uint8List data, int version, QrEcc ecc) {
    final totalDataWords = _totalDataWords(version, ecc);
    final charCountBits = version < 10 ? 8 : 16;
    final bits = <int>[];

    // Mode indicator: 0100 (byte)
    _addBits(bits, 100, 4);
    // Character count
    _addBits(bits, data.length, charCountBits);
    // Data bytes
    for (final b in data) {
      _addBits(bits, b, 8);
    }

    // Pad to full codewords
    while (bits.length < totalDataWords * 8) {
      bits.add(0);
    }

    // Convert to codewords
    final words = <int>[];
    for (var i = 0; i < totalDataWords; i++) {
      var w = 0;
      for (var j = 0; j < 8; j++) {
        if (i * 8 + j < bits.length) {
          w = (w << 1) | (bits[i * 8 + j] & 1);
        } else {
          w <<= 1;
        }
      }
      words.add(w);
    }
    return words;
  }

  static void _addBits(List<int> bits, int value, int count) {
    for (var i = count - 1; i >= 0; i--) {
      bits.add((value >> i) & 1);
    }
  }

  // === Reed-Solomon 纠错编码 ===

  // GF(256) 对数/反对数表
  static final List<int> _logTable = (() {
    final log = List.filled(256, 0);
    final antilog = List.filled(256, 0);
    var v = 1;
    for (var i = 0; i < 255; i++) {
      antilog[i] = v;
      log[v] = i;
      v = _gf256Multiply(v, 2);
    }
    log[1] = 0;
    return log;
  })();

  static final List<int> _antilogTable = (() {
    final antilog = List.filled(256, 0);
    var v = 1;
    for (var i = 0; i < 255; i++) {
      antilog[i] = v;
      v = _gf256Multiply(v, 2);
    }
    return antilog;
  })();

  /// GF(256) 乘法（使用原始多项式计算，不依赖表）。
  static int _gf256Multiply(int a, int b) {
    var result = 0;
    var multiplier = b;
    for (var i = 0; i < 8; i++) {
      if (multiplier & 1 == 1) {
        result ^= a << i;
      }
      multiplier >>= 1;
    }
    // Reduce modulo primitive polynomial x^8 + x^4 + x^3 + x^2 + 1 (0x11D)
    for (var i = 14; i >= 8; i--) {
      if ((result >> i) & 1 == 1) {
        result ^= 0x11D << (i - 8);
      }
    }
    return result & 0xFF;
  }

  static int _multiply(int a, int b) {
    if (a == 0 || b == 0) return 0;
    final sum = _logTable[a] + _logTable[b];
    return _antilogTable[sum >= 255 ? sum - 255 : sum];
  }

  // 生成 RS 生成多项式系数
  static List<int> _rsGeneratorPoly(int degree) {
    var poly = [1]; // 多项式系数，从常数项到最高次
    for (var i = 0; i < degree; i++) {
      // 乘以 (x + α^i)
      poly = _multiplyPoly(poly, [_antilogTable[i], 1]);
    }
    return poly;
  }

  static List<int> _multiplyPoly(List<int> a, List<int> b) {
    final result = List.filled(a.length + b.length - 1, 0);
    for (var i = 0; i < a.length; i++) {
      for (var j = 0; j < b.length; j++) {
        result[i + j] ^= _multiply(a[i], b[j]);
      }
    }
    return result;
  }

  static List<int> _rsEncode(List<int> data, int eccCount) {
    if (eccCount == 0) return [];
    final gen = _rsGeneratorPoly(eccCount);
    final msg = List<int>.from(data)..addAll(List.filled(eccCount, 0));

    for (var i = 0; i < data.length; i++) {
      if (msg[i] == 0) continue;
      final factor = _logTable[msg[i]];
      for (var j = 0; j < gen.length; j++) {
        msg[i + j] ^= _multiply(gen[j], factor);
      }
    }

    return msg.sublist(data.length);
  }

  // === 交错 ===

  static List<int> _interleave(List<int> data, List<int> ecc, int version, QrEcc eccLevel) {
    final all = List<int>.from(data);
    all.addAll(ecc);
    return all;
  }

  // === 矩阵摆放 ===

  static void _placeFinderPatterns(List<List<bool>> matrix) {
    final size = matrix.length;
    // 三个角：左上、右上、左下
    for (final (dx, dy) in [(0, 0), (size - 7, 0), (0, size - 7)]) {
      _drawFinderPattern(matrix, dx, dy);
    }
  }

  static void _drawFinderPattern(List<List<bool>> matrix, int x, int y) {
    for (var r = -1; r <= 7; r++) {
      for (var c = -1; c <= 7; c++) {
        if (r < 0 || r >= 7 || c < 0 || c >= 7) {
          // 分隔符
          if (x + c >= 0 && x + c < matrix.length && y + r >= 0 && y + r < matrix.length) {
            matrix[y + r][x + c] = false;
          }
        } else {
          final isBlack = (r == 0 || r == 6 || c == 0 || c == 6 ||
              (r >= 2 && r <= 4 && c >= 2 && c <= 4));
          matrix[y + r][x + c] = isBlack;
        }
      }
    }
  }

  static void _placeTimingPatterns(List<List<bool>> matrix) {
    final size = matrix.length;
    for (var i = 8; i < size - 8; i++) {
      matrix[6][i] = i.isEven;
      matrix[i][6] = i.isEven;
    }
  }

  static void _placeDarkModule(List<List<bool>> matrix) {
    matrix[matrix.length - 8][8] = true;
  }

  static void _placeAlignmentPatterns(List<List<bool>> matrix, int version) {
    if (version < 2) return;
    // 简版：仅 version 2+ 的中心校准图案
    final size = matrix.length;
    if (version >= 2) {
      final center = size - 7;
      _drawAlignmentPattern(matrix, center, center);
    }
  }

  static void _drawAlignmentPattern(List<List<bool>> matrix, int x, int y) {
    for (var r = -2; r <= 2; r++) {
      for (var c = -2; c <= 2; c++) {
        if (x + c < 0 || x + c >= matrix.length || y + r < 0 || y + r >= matrix.length) continue;
        final isBlack = r.abs() == 2 || c.abs() == 2 || (r.abs() == 0 && c.abs() == 0);
        matrix[y + r][x + c] = isBlack;
      }
    }
  }

  // === 数据摆放 ===

  static void _placeData(List<List<bool>> matrix, List<int> bits) {
    final size = matrix.length;
    final bitList = <int>[];
    for (final b in bits) {
      for (var i = 7; i >= 0; i--) {
        bitList.add((b >> i) & 1);
      }
    }

    var bitIdx = 0;
    // 从右下角开始 zigzag
    var col = size - 1;
    var row = size - 1;
    var direction = -1; // -1 = up, 1 = down

    while (col > 0) {
      if (col == 6) col--; // 跳过 timing pattern

      for (var i = 0; i < size; i++) {
        final r = direction < 0 ? size - 1 - i : i;

        for (var offset = 0; offset < 2; offset++) {
          final c = col - offset;
          if (c < 0 || c >= size) continue;
          if (!_isReserved(matrix, r, c)) {
            if (bitIdx < bitList.length) {
              matrix[r][c] = bitList[bitIdx++] == 1;
            }
          }
        }
      }

      col -= 2;
      direction = -direction;
    }
  }

  static bool _isReserved(List<List<bool>> matrix, int r, int c) {
    final size = matrix.length;
    // Finder patterns
    if ((r < 8 && c < 8) || (r < 8 && c >= size - 8) || (r >= size - 8 && c < 8)) return true;
    // Timing patterns
    if (r == 6 || c == 6) return true;
    // Dark module
    if (r == size - 8 && c == 8) return true;
    return false;
  }

  // === 掩模 ===

  static int _findBestMask(List<List<bool>> matrix) {
    var bestScore = -1;
    var bestMask = 0;

    for (var mask = 0; mask < 8; mask++) {
      final test = matrix.map((row) => List<bool>.from(row)).toList();
      _applyMask(test, mask);
      final score = _evaluateMask(test);
      if (bestScore < 0 || score < bestScore) {
        bestScore = score;
        bestMask = mask;
      }
    }

    return bestMask;
  }

  static void _applyMask(List<List<bool>> matrix, int mask) {
    final size = matrix.length;
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        if (_isReserved(matrix, r, c)) continue;
        if (_maskCondition(mask, r, c)) {
          matrix[r][c] = !matrix[r][c];
        }
      }
    }
  }

  static bool _maskCondition(int mask, int r, int c) {
    return switch (mask) {
      0 => (r + c) % 2 == 0,
      1 => r % 2 == 0,
      2 => c % 3 == 0,
      3 => (r + c) % 3 == 0,
      4 => (r ~/ 2 + c ~/ 3) % 2 == 0,
      5 => (r * c) % 2 + (r * c) % 3 == 0,
      6 => ((r * c) % 2 + (r * c) % 3) % 2 == 0,
      7 => ((r + c) % 2 + (r * c) % 3) % 2 == 0,
      _ => false,
    };
  }

  static int _evaluateMask(List<List<bool>> matrix) {
    final size = matrix.length;
    var score = 0;

    // 惩罚1：连续同色模块
    for (var r = 0; r < size; r++) {
      var run = 1;
      for (var c = 1; c < size; c++) {
        if (matrix[r][c] == matrix[r][c - 1]) {
          run++;
        } else {
          if (run >= 5) score += 3 + (run - 5);
          run = 1;
        }
      }
      if (run >= 5) score += 3 + (run - 5);
    }
    for (var c = 0; c < size; c++) {
      var run = 1;
      for (var r = 1; r < size; r++) {
        if (matrix[r][c] == matrix[r - 1][c]) {
          run++;
        } else {
          if (run >= 5) score += 3 + (run - 5);
          run = 1;
        }
      }
      if (run >= 5) score += 3 + (run - 5);
    }

    // 惩罚2：2x2 同色块
    for (var r = 0; r < size - 1; r++) {
      for (var c = 0; c < size - 1; c++) {
        if (matrix[r][c] && matrix[r + 1][c] && matrix[r][c + 1] && matrix[r + 1][c + 1]) score += 3;
        if (!matrix[r][c] && !matrix[r + 1][c] && !matrix[r][c + 1] && !matrix[r + 1][c + 1]) score += 3;
      }
    }

    // 惩罚3：Finder-like patterns
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size - 10; c++) {
        if (_isFinderLike(matrix, r, c, true)) score += 40;
      }
    }
    for (var c = 0; c < size; c++) {
      for (var r = 0; r < size - 10; r++) {
        if (_isFinderLike(matrix, r, c, false)) score += 40;
      }
    }

    // 惩罚4：黑白比例
    var blackCount = 0;
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        if (matrix[r][c]) blackCount++;
      }
    }
    final percent = (blackCount * 100) ~/ (size * size);
    final diff = (percent - 50).abs();
    score += (diff ~/ 5) * 10;

    return score;
  }

  static bool _isFinderLike(List<List<bool>> matrix, int r, int c, bool horizontal) {
    final pattern = [true, false, true, true, true, false, true];
    for (var i = 0; i < pattern.length; i++) {
      final val = horizontal ? matrix[r][c + i] : matrix[r + i][c];
      if (val != pattern[i]) return false;
    }
    // 检查前后白色
    if (horizontal) {
      if (c > 0 && matrix[r][c - 1]) return false;
      if (c + 7 < matrix.length && matrix[r][c + 7]) return false;
    } else {
      if (r > 0 && matrix[r - 1][c]) return false;
      if (r + 7 < matrix.length && matrix[r + 7][c]) return false;
    }
    return true;
  }

  // === 格式信息 ===

  static void _placeFormatInfo(List<List<bool>> matrix, int mask, QrEcc ecc) {
    final eccBits = ecc == QrEcc.l ? 1 : 0;
    final formatData = _formatBits(eccBits, mask);

    final size = matrix.length;
    // 水平
    for (var i = 0; i <= 5; i++) {
      matrix[8][i] = ((formatData >> i) & 1) == 1;
    }
    matrix[8][7] = ((formatData >> 6) & 1) == 1;
    matrix[8][8] = ((formatData >> 7) & 1) == 1;
    matrix[7][8] = ((formatData >> 8) & 1) == 1;
    for (var i = 9; i <= 14; i++) {
      final bitIdx = i >= 9 ? i - 1 : i;
      matrix[size - 15 + i][8] = ((formatData >> bitIdx) & 1) == 1;
    }

    // 垂直
    for (var i = 0; i <= 5; i++) {
      matrix[i][8] = ((formatData >> i) & 1) == 1;
    }
    for (var i = 7; i <= 8; i++) {
      matrix[i][8] = ((formatData >> i) & 1) == 1;
    }
    matrix[8][size - 8] = true; // dark module
  }

  static int _formatBits(int eccBits, int mask) {
    var data = (eccBits << 3) | mask;
    // BCH 编码: 生成多项式 x^10 + x^8 + x^5 + x^4 + x^2 + x + 1
    var poly = data << 10;
    const genPoly = 0x0537;
    var remainder = poly;
    for (var i = 14; i >= 10; i--) {
      if ((remainder >> i) & 1 == 1) {
        remainder ^= genPoly << (i - 10);
      }
    }
    final encoded = (data << 10) | remainder;
    // XOR with mask 101010000010010
    return encoded ^ 0x5412;
  }

  // === GF(256) 乘法表初始化辅助 ===
  static int _primitivePoly = 0x11D; // x^8 + x^4 + x^3 + x^2 + 1

  static int _gfMult(int a, int b) => _multiply(a, b);
}

/// QR Code 纠错级别。
enum QrEcc { l, m }
