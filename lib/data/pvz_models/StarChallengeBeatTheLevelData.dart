import 'package:c_editor/data/pvz_models/PvzModel.dart';

class StarChallengeBeatTheLevelData extends PvzModel {
  StarChallengeBeatTheLevelData({
    this.description = '',
    this.descriptiveName = '',
  });

  String description;
  String descriptiveName;

  factory StarChallengeBeatTheLevelData.fromJson(Map<String, dynamic> json) {
    return StarChallengeBeatTheLevelData(
      description: json['Description'] as String? ?? '',
      descriptiveName: json['DescriptiveName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'Description': description,
    'DescriptiveName': descriptiveName,
  };
}
