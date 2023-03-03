import 'package:json_annotation/json_annotation.dart';

part 'prediction.g.dart';

@JsonSerializable()
class Prediction{
  double x;
  double y;
  double timestamp;

  Prediction(
      this.x,
      this.y,
      this.timestamp
  );

  factory Prediction.fromJson(Map<String, dynamic> json) => _$PredictionFromJson(json);

  Map<String, dynamic> toJson() => _$PredictionToJson(this);

  @override
  String toString() {
    return 'x:$x, y:$y, timestamp:$timestamp';
  }
}