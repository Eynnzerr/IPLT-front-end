// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      json['id'] as int,
      json['address'] as String,
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['z'] as num).toDouble(),
      json['stay'] as int,
      json['timestamp'] as int,
      json['bsAddress'] as int,
      json['sampleTime'] as String,
      json['sampleBatch'] as int,
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'x': instance.x,
      'y': instance.y,
      'z': instance.z,
      'stay': instance.stay,
      'timestamp': instance.timestamp,
      'bsAddress': instance.bsAddress,
      'sampleTime': instance.sampleTime,
      'sampleBatch': instance.sampleBatch,
    };
