import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 分页器。对齐 AntD v5 `Pagination`。
class AntPagination extends StatelessWidget {
  const AntPagination({
    required this.current,
    required this.total,
    required this.onChange,
    super.key,
    this.pageSize = 10,
    this.showSizeChanger = false,
    this.pageSizeOptions = const [10, 20, 50, 100],
  });

  final int current;
  final int total;
  final ValueChanged<int> onChange;
  final int pageSize;
  final bool showSizeChanger;
  final List<int> pageSizeOptions;

  int get _totalPages => (total / pageSize).ceil();

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final totalPages = _totalPages;

    if (totalPages <= 1) return const SizedBox.shrink();

    final pages = <int>[];
    pages.add(1);
    if (current > 3) pages.add(-1); // ellipsis

    for (var i = (current - 1).clamp(2, totalPages - 1); i <= (current + 1).clamp(2, totalPages - 1); i++) {
      if (!pages.contains(i) && i > 1 && i < totalPages) pages.add(i);
    }

    if (current < totalPages - 2) pages.add(-1); // ellipsis
    if (totalPages > 1) pages.add(totalPages);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PageBtn(
          label: '‹', active: current > 1,
          alias: alias,
          onTap: current > 1 ? () => onChange(current - 1) : null,
        ),
        const SizedBox(width: 4),
        for (final p in pages)
          p == -1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text('…', style: TextStyle(color: alias.colorTextTertiary, fontSize: alias.fontSize)),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: _PageBtn(
                    label: '$p', active: p != current,
                    isCurrent: p == current,
                    alias: alias,
                    onTap: p != current ? () => onChange(p) : null,
                  ),
                ),
        _PageBtn(
          label: '›', active: current < totalPages,
          alias: alias,
          onTap: current < totalPages ? () => onChange(current + 1) : null,
        ),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  const _PageBtn({
    required this.label,
    required this.active,
    required this.alias,
    this.onTap,
    this.isCurrent = false,
  });

  final String label;
  final bool active;
  final AntAliasToken alias;
  final VoidCallback? onTap;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isCurrent ? alias.colorPrimary : null,
          borderRadius: BorderRadius.circular(4),
          border: !isCurrent ? Border.all(color: alias.colorBorder) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isCurrent ? const Color(0xFFFFFFFF) : (active ? alias.colorText : alias.colorTextDisabled),
              fontSize: alias.fontSize - 2,
            ),
          ),
        ),
      ),
    );
  }
}
