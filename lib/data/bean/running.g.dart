// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'running.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Running _$RunningFromJson(Map<String, dynamic> json) => Running(
      json['id'] as int,
      json['address'] as String,
      json['accx'] as int,
      json['accy'] as int,
      json['accz'] as int,
      json['gyroscopex'] as int,
      json['gyroscopey'] as int,
      json['gyroscopez'] as int,
      json['stay'] as int,
      json['timestamp'] as int,
      json['bsAddress'] as int,
      json['sampleTime'] as String,
      json['sampleBatch'] as int,
    );

Map<String, dynamic> _$RunningToJson(Running instance) => <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'accx': instance.accx,
      'accy': instance.accy,
      'accz': instance.accz,
      'gyroscopex': instance.gyroscopex,
      'gyroscopey': instance.gyroscopey,
      'gyroscopez': instance.gyroscopez,
      'stay': instance.stay,
      'timestamp': instance.timestamp,
      'bsAddress': instance.bsAddress,
      'sampleTime': instance.sampleTime,
      'sampleBatch': instance.sampleBatch,
    };
