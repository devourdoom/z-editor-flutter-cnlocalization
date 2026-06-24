import 'package:c_editor/data/pvz_models/PvzModel.dart';

class VaseDefinition extends PvzModel {
  VaseDefinition({
    this.zombieTypeName,
    this.plantTypeName,
    this.collectableTypeName,
    this.count = 1,
  });

  String? zombieTypeName;
  String? plantTypeName;
  String? collectableTypeName;
  int count;

  factory VaseDefinition.fromJson(Map<String, dynamic> json) {
    return VaseDefinition(
      zombieTypeName: json['ZombieTypeName'] as String?,
      plantTypeName: json['PlantTypeName'] as String?,
      collectableTypeName: json['CollectableTypeName'] as String?,
      count: json['Count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'Count': count};
    if (zombieTypeName != null) data['ZombieTypeName'] = zombieTypeName;
    if (plantTypeName != null) data['PlantTypeName'] = plantTypeName;
    if (collectableTypeName != null) {
      data['CollectableTypeName'] = collectableTypeName;
    }
    return data;
  }
}
