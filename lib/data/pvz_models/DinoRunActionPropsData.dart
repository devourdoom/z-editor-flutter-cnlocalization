import 'package:c_editor/data/pvz_models/PvzModel.dart';

import 'package:c_editor/data/pvz_models/DinoTreadActionPropsData.dart';

class DinoRunActionPropsData extends PvzModel {
  DinoRunActionPropsData({
    this.dinoRow = 0,
    this.timeInterval = 2,
    this.waveStartMessage = '[WARNING_DINO_RUN]',
  });

  int dinoRow;
  int timeInterval;
  String waveStartMessage;

  factory DinoRunActionPropsData.fromJson(Map<String, dynamic> json) {
    return DinoRunActionPropsData(
      dinoRow: DinoTreadActionPropsData.parseIntSafe(json['DinoRow']) ?? 0,
      timeInterval:
          DinoTreadActionPropsData.parseIntSafe(json['TimeInterval']) ?? 2,
      waveStartMessage:
          json['WaveStartMessage'] as String? ?? '[WARNING_DINO_RUN]',
    );
  }

  Map<String, dynamic> toJson() => {
    'DinoRow': dinoRow,
    'TimeInterval': timeInterval,
    'WaveStartMessage': waveStartMessage,
  };
}
