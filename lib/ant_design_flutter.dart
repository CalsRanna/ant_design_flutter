/// ant_design_flutter 2.0 - Ant Design v5 aligned component library
/// for Flutter web and desktop applications.
///
/// Phase 1 exports: Foundation + Theme + App shell.
library;

export 'src/app/ant_app.dart' show AntApp;
export 'src/app/ant_config_provider.dart' show AntConfigProvider, AntTheme;
export 'src/components/_shared/component_size.dart' show AntComponentSize;
export 'src/components/_shared/component_status.dart' show AntStatus;
export 'src/components/icon/ant_icon.dart' show AntIcon;
export 'src/components/typography/ant_text.dart' show AntText, AntTextType;
export 'src/components/typography/ant_title.dart' show AntTitle, AntTitleLevel;
export 'src/primitives/interaction/ant_interaction_detector.dart'
    show AntInteractionBuilder, AntInteractionDetector;
export 'src/primitives/overlay/ant_overlay_manager.dart' show AntOverlayManager;
export 'src/primitives/overlay/ant_overlay_slot.dart' show AntOverlaySlot;
export 'src/primitives/overlay/overlay_entry_handle.dart'
    show OverlayEntryHandle;
export 'src/primitives/portal/ant_placement.dart' show AntPlacement;
export 'src/primitives/portal/ant_portal.dart' show AntPortal;
export 'src/theme/algorithm/default_algorithm.dart' show DefaultAlgorithm;
export 'src/theme/algorithm/theme_algorithm.dart' show AntThemeAlgorithm;
export 'src/theme/alias_token.dart' show AntAliasToken;
export 'src/theme/map_token.dart' show AntMapToken;
export 'src/theme/seed_token.dart' show AntSeedToken;
export 'src/theme/theme_data.dart' show AntThemeData;
