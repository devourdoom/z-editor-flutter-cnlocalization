import 'package:c_editor/data/pvz_models/PvzModel.dart';

class ModifyConveyorRemoveData extends PvzModel {
  ModifyConveyorRemoveData({this.type = ''});

  String type;

  bool get isToolEntry => type.startsWith('tool_') && !type.startsWith('RTID(');

  factory ModifyConveyorRemoveData.fromJson(Map<String, dynamic> json) {
    return ModifyConveyorRemoveData(
      type: json['ToolType'] as String? ?? json['Type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    if (isToolEntry) {
      return {'ToolType': type};
    }
    return {'Type': type};
  }
}
