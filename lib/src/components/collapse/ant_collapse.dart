import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 折叠面板。对齐 AntD v5 `Collapse`。
class AntCollapse extends StatefulWidget {
  const AntCollapse({
    required this.items,
    super.key,
  });

  final List<AntCollapsePanel> items;

  @override
  State<AntCollapse> createState() => _AntCollapseState();
}

class _AntCollapseState extends State<AntCollapse> {
  final Set<int> _activeKeys = {};

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: alias.colorBorderSecondary),
        borderRadius: BorderRadius.circular(alias.borderRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.items.length; i++)
            _buildPanel(i, widget.items[i], alias),
        ],
      ),
    );
  }

  Widget _buildPanel(int idx, AntCollapsePanel panel, AntAliasToken alias) {
    final isActive = _activeKeys.contains(idx);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (idx > 0)
          Container(height: 1, decoration: BoxDecoration(color: alias.colorSplit)),
        GestureDetector(
          onTap: () => setState(() {
            if (isActive) { _activeKeys.remove(idx); } else { _activeKeys.add(idx); }
          }),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(panel.header, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize)),
                ),
                Text(isActive ? '▲' : '▼', style: TextStyle(color: alias.colorTextTertiary, fontSize: 10)),
              ],
            ),
          ),
        ),
        if (isActive)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: panel.child,
          ),
      ],
    );
  }
}

class AntCollapsePanel {
  const AntCollapsePanel({required this.header, required this.child});
  final String header;
  final Widget child;
}
