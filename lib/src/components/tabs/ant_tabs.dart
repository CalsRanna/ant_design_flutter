import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 标签页组件。
///
/// 对齐 AntD v5 `Tabs` 组件。MVP 实现：
/// - `tabs`：标签项列表
/// - `activeKey` / `onChange`：受控切换
/// - disabled 状态的标签
///
/// 未提供 `activeKey` 时组件内部管理选中状态（非受控模式）。
///
/// 推迟到 2.1：`tabPosition`（垂直）、`centered`、`card` 类型、
/// `size`、`tabBarExtra`、`animated`、滚动标签栏。
class AntTabs extends StatefulWidget {
  const AntTabs({
    required this.tabs,
    super.key,
    this.activeKey,
    this.onChange,
  });

  /// 标签项列表。
  final List<AntTabItem> tabs;

  /// 当前激活的 key。null 时组件内自管。
  final String? activeKey;

  /// 切换回调。
  final ValueChanged<String>? onChange;

  @override
  State<AntTabs> createState() => _AntTabsState();
}

class _AntTabsState extends State<AntTabs> {
  /// 非受控模式下的内部选中 key。
  String _internalKey = '';

  /// 是否受控（外部传入 activeKey）。
  bool get _isControlled => widget.activeKey != null;

  /// 实际生效的 key。
  String get _effectiveKey => _isControlled ? widget.activeKey! : _internalKey;

  @override
  void initState() {
    super.initState();
    if (widget.tabs.isNotEmpty) {
      _internalKey = widget.tabs.first.key;
    }
  }

  void _onTap(String key) {
    if (!_isControlled) {
      setState(() => _internalKey = key);
    }
    widget.onChange?.call(key);
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final activeKey = _effectiveKey;

    Widget? activeChild;
    final idx = widget.tabs.indexWhere((t) => t.key == activeKey);
    if (idx >= 0) {
      activeChild = widget.tabs[idx].child;
    } else {
      activeChild = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tab bar
        _TabBar(
          tabs: widget.tabs,
          activeKey: activeKey,
          alias: alias,
          onTap: _onTap,
        ),
        // Active content
        if (activeChild != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: activeChild,
          ),
      ],
    );
  }
}

/// 单个标签项。
class AntTabItem {
  const AntTabItem({
    required this.key,
    required this.label,
    required this.child,
    this.disabled = false,
    this.icon,
  });

  /// 唯一标识。
  final String key;

  /// 标签文字。
  final String label;

  /// 标签页内容。
  final Widget child;

  /// 是否禁用。
  final bool disabled;

  /// 标签图标（可选）。
  final Widget? icon;
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.activeKey,
    required this.alias,
    required this.onTap,
  });

  final List<AntTabItem> tabs;
  final String activeKey;
  final AntAliasToken alias;
  final ValueChanged<String> onTap;

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
          for (final tab in tabs)
            _TabItem(
              tab: tab,
              isActive: tab.key == activeKey,
              alias: alias,
              onTap: tab.disabled ? null : () => onTap(tab.key),
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.alias,
    required this.onTap,
  });

  final AntTabItem tab;
  final bool isActive;
  final AntAliasToken alias;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = tab.disabled
        ? alias.colorTextDisabled
        : isActive
            ? alias.colorPrimary
            : alias.colorTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? alias.colorPrimary : const Color(0x00000000),
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[
              tab.icon!,
              const SizedBox(width: 8),
            ],
            Text(
              tab.label,
              style: TextStyle(
                color: color,
                fontSize: alias.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
