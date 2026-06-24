import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RaidingPartyEventData extends PvzModel {
  RaidingPartyEventData({
    this.groupSize = 5,
    this.swashbucklerCount = 5,
    this.timeBetweenGroups = 2,
  });

  int groupSize;
  int swashbucklerCount;
  int timeBetweenGroups;

  factory RaidingPartyEventData.fromJson(Map<String, dynamic> json) {
    return RaidingPartyEventData(
      groupSize: json['GroupSize'] as int? ?? 5,
      swashbucklerCount: json['SwashbucklerCount'] as int? ?? 5,
      timeBetweenGroups: json['TimeBetweenGroups'] as int? ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {
    'GroupSize': groupSize,
    'SwashbucklerCount': swashbucklerCount,
    'TimeBetweenGroups': timeBetweenGroups,
  };
}
