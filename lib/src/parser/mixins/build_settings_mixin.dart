import 'package:json_annotation/json_annotation.dart';

mixin BuildSettingsMixin {
  // Note: ASSETCATALOG_COMPILER_APPICON_NAME is NOT included in default settings.
  // It is dynamically added in IOSBuildConfigurationsTargetsProcessor and
  // MacOSBuildConfigurationsTargetsProcessor when an icon is defined for the flavor.
  // This allows using flutter_launcher_icons or other tools by simply not
  // defining an icon field in the flavor configuration.
  static final Map<String, dynamic> iosDefaultBuildSettings = {
    "LD_RUNPATH_SEARCH_PATHS": "\$(inherited) @executable_path/Frameworks",
    "SWIFT_OBJC_BRIDGING_HEADER": "Runner/Runner-Bridging-Header.h",
    "SWIFT_VERSION": "5.0",
    "FRAMEWORK_SEARCH_PATHS": ['\$(inherited)', '\$(PROJECT_DIR)/Flutter'],
    "LIBRARY_SEARCH_PATHS": ['\$(inherited)', '\$(PROJECT_DIR)/Flutter'],
    "INFOPLIST_FILE": "Runner/Info.plist",
  };

  static final Map<String, dynamic> macosDefaultBuildSettings = {
    "LD_RUNPATH_SEARCH_PATHS": "\$(inherited) @executable_path/Frameworks",
    "SWIFT_VERSION": "5.0",
    "FRAMEWORK_SEARCH_PATHS": ['\$(inherited)', '\$(PROJECT_DIR)/Flutter'],
    "LIBRARY_SEARCH_PATHS": ['\$(inherited)', '\$(PROJECT_DIR)/Flutter'],
    "INFOPLIST_FILE": "Runner/Info.plist",
  };

  @JsonKey(defaultValue: {})
  late Map<String, dynamic> buildSettings;
}
