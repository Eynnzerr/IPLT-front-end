// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prediction _$PredictionFromJson(Map<String, dynamic> json) => Prediction(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['timestamp'] as num).toDouble(),
    );

Map<String, dynamic> _$PredictionToJson(Prediction instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'timestamp': instance.timestamp,
    };
