import 'package:json_annotation/json_annotation.dart';

part 'running.g.dart';

@JsonSerializable()
class Running {
  int id;
  String address;
  int accx;
  int accy;
  int accz;
  int gyroscopex;
  int gyroscopey;
  int gyroscopez;
  int stay;
  int timestamp;
  int bsAddress;
  String sampleTime;
  String sampleBatch;

  factory Running.fromJson(Map<String, dynamic> json) => _$RunningFromJson(json);

  Map<String, dynamic> toJson() => _$RunningToJson(this);

  Running(
    this.id,
    this.address,
    this.accx,
    this.accy,
    this.accz,
    this.gyroscopex,
    this.gyroscopey,
    this.gyroscopez,
    this.stay,
    this.timestamp,
    this.bsAddress,
    this.sampleTime,
    this.sampleBatch
  );

}