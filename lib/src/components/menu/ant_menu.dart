import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 导航菜单。
///
/// 对齐 AntD v5 `Menu` 组件。MVP 实现水平模式（horizontal）：
/// - `items`：菜单项列表（支持 SubMenu 嵌套）
/// - `selectedKey` / `onSelect`：选择回调
///
/// 推迟到 2.1：`mode`（vertical/inline）、`theme`（dark）、`popup` 子菜单、
/// `triggerSubMenuAction`、`openKeys` 受控、`inlineCollapsed`。
class AntMenu extends StatefulWidget {
  const AntMenu({
    required this.items,
    super.key,
    this.selectedKey,
    this.onSelect,
  });

  /// 菜单项列表。
  final List<AntMenuItem> items;

  /// 当前选中 key。
  final String? selectedKey;

  /// 选择回调。
  final ValueChanged<String>? onSelect;

  @override
  State<AntMenu> createState() => _AntMenuState();
}

class _AntMenuState extends State<AntMenu> {
  /// 展开的 SubMenu key 集合（非受控模式）。
  final Set<String> _expandedKeys = {};

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      color: alias.colorBackgroundContainer,
      child: _AntMenuBar(
        items: widget.items,
        selectedKey: widget.selectedKey,
        expandedKeys: _expandedKeys,
        alias: alias,
        onSelect: (key) {
          widget.onSelect?.call(key);
        },
        onToggleExpand: (key) {
          setState(() {
            if (_expandedKeys.contains(key)) {
              _expandedKeys.remove(key);
            } else {
              _expandedKeys.add(key);
            }
          });
        },
      ),
    );
  }
}

/// 菜单项基类。
sealed class AntMenuItem {
  const AntMenuItem._();
}

/// 普通菜单项。
class AntMenuItemData extends AntMenuItem {
  AntMenuItemData({
    required this.key,
    required this.label,
    this.icon,
    this.disabled = false,
  }) : super._();

  final String key;
  final String label;
  final Widget? icon;
  final bool disabled;
}

/// 子菜单（含嵌套子项）。
class AntSubMenuData extends AntMenuItem {
  AntSubMenuData({
    required this.key,
    required this.label,
    required this.children,
    this.icon,
  }) : super._();

  final String key;
  final String label;
  final Widget? icon;
  final List<AntMenuItem> children;
}

// ---------- internal widgets ----------

class _AntMenuBar extends StatelessWidget {
  const _AntMenuBar({
    required this.items,
    required this.selectedKey,
    required this.expandedKeys,
    required this.alias,
    required this.onSelect,
    required this.onToggleExpand,
  });

  final List<AntMenuItem> items;
  final String? selectedKey;
  final Set<String> expandedKeys;
  final AntAliasToken alias;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleExpand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: alias.colorSplit),
        ),
      ),
      child: Row(
        children: [
          for (final item in items) _buildItem(context, item),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, AntMenuItem item) {
    return switch (item) {
      final AntMenuItemData d => _MenuRowItem(
          label: d.label,
          icon: d.icon,
          isSelected: d.key == selectedKey,
          disabled: d.disabled,
          alias: alias,
          onTap: d.disabled ? null : () => onSelect(d.key),
          hasArrow: false,
        ),
      final AntSubMenuData d => _SubMenuItem(
          data: d,
          selectedKey: selectedKey,
          expandedKeys: expandedKeys,
          alias: alias,
          onSelect: onSelect,
          onToggleExpand: onToggleExpand,
        ),
    };
  }
}

class _MenuRowItem extends StatelessWidget {
  const _MenuRowItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.disabled,
    required this.alias,
    required this.onTap,
    required this.hasArrow,
  });

  final String label;
  final Widget? icon;
  final bool isSelected;
  final bool disabled;
  final AntAliasToken alias;
  final VoidCallback? onTap;
  final bool hasArrow;

  @override
  Widget build(BuildContext context) {
    final color = disabled
        ? alias.colorTextDisabled
        : isSelected
            ? alias.colorPrimary
            : alias.colorText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? alias.colorPrimary : const Color(0x00000000),
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: alias.fontSize,
              ),
            ),
            if (hasArrow) ...[
              const SizedBox(width: 4),
              Text(
                '▾',
                style: TextStyle(color: color, fontSize: 10),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubMenuItem extends StatefulWidget {
  const _SubMenuItem({
    required this.data,
    required this.selectedKey,
    required this.expandedKeys,
    required this.alias,
    required this.onSelect,
    required this.onToggleExpand,
  });

  final AntSubMenuData data;
  final String? selectedKey;
  final Set<String> expandedKeys;
  final AntAliasToken alias;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onToggleExpand;

  @override
  State<_SubMenuItem> createState() => _SubMenuItemState();
}

class _SubMenuItemState extends State<_SubMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.expandedKeys.contains(widget.data.key);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MenuRowItem(
            label: widget.data.label,
            icon: widget.data.icon,
            isSelected: false,
            disabled: false,
            alias: widget.alias,
            onTap: () => widget.onToggleExpand(widget.data.key),
            hasArrow: true,
          ),
          if (isExpanded || _isHovered)
            IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: widget.alias.colorBackgroundElevated,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final child in widget.data.children)
                      switch (child) {
                        final AntMenuItemData d => _MenuRowItem(
                            label: d.label,
                            icon: d.icon,
                            isSelected: d.key == widget.selectedKey,
                            disabled: d.disabled,
                            alias: widget.alias,
                            onTap: d.disabled
                                ? null
                                : () => widget.onSelect(d.key),
                            hasArrow: false,
                          ),
                        final AntSubMenuData d => _SubMenuItem(
                            data: d,
                            selectedKey: widget.selectedKey,
                            expandedKeys: widget.expandedKeys,
                            alias: widget.alias,
                            onSelect: widget.onSelect,
                            onToggleExpand: widget.onToggleExpand,
                          ),
                      },
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
