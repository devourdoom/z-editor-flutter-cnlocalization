import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RiftThemeDemoModulePropertiesData extends PvzModel {
  RiftThemeDemoModulePropertiesData({this.demoRiftThemeName = const []});

  List<String> demoRiftThemeName;

  factory RiftThemeDemoModulePropertiesData.fromJson(
    Map<String, dynamic> json,
  ) {
    final raw = json['DemoRiftThemeName'] as List<dynamic>? ?? [];
    return RiftThemeDemoModulePropertiesData(
      demoRiftThemeName: raw.map((e) => e.toString()).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {'DemoRiftThemeName': demoRiftThemeName};
}
