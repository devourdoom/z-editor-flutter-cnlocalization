import 'package:c_editor/data/pvz_models/PvzModel.dart';

class RoofPropertiesData extends PvzModel {
  RoofPropertiesData({
    this.flowerPotStartColumn = 0,
    this.flowerPotEndColumn = 2,
  });

  int flowerPotStartColumn;
  int flowerPotEndColumn;

  factory RoofPropertiesData.fromJson(Map<String, dynamic> json) {
    return RoofPropertiesData(
      flowerPotStartColumn: json['FlowerPotStartColumn'] as int? ?? 0,
      flowerPotEndColumn: json['FlowerPotEndColumn'] as int? ?? 2,
    );
  }

  Map<String, dynamic> toJson() => {
    'FlowerPotStartColumn': flowerPotStartColumn,
    'FlowerPotEndColumn': flowerPotEndColumn,
  };
}
