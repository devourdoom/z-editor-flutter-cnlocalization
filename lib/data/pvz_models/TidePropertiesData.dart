import 'package:c_editor/data/pvz_models/PvzModel.dart';

class TidePropertiesData extends PvzModel {
  TidePropertiesData({this.startingWaveLocation = 5});

  int startingWaveLocation;

  factory TidePropertiesData.fromJson(Map<String, dynamic> json) {
    return TidePropertiesData(
      startingWaveLocation: json['StartingWaveLocation'] as int? ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
    'StartingWaveLocation': startingWaveLocation,
  };
}
