import 'package:json_annotation/json_annotation.dart';
import 'package:learnflutter/data/bean/cloneable.dart';

part 'running.g.dart';

@JsonSerializable()
class Running implements Cloneable{
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
  int sampleBatch;

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

  @override
  clone() {
    return Running(id, address, accx, accy, accz, gyroscopex, gyroscopey, gyroscopez, stay, timestamp, bsAddress, sampleTime, sampleBatch);
  }

}