import 'package:flutter/widgets.dart';

/// 上传（简版）。对齐 AntD v5 `Upload`。
/// MVP 仅提供触发按钮 UI，实际文件操作由用户处理。
class AntUpload extends StatelessWidget {
  const AntUpload({required this.child, super.key, this.onSelect});
  final Widget child; final VoidCallback? onSelect;

  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onSelect, child: child);
}
