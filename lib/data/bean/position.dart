import 'package:json_annotation/json_annotation.dart';
import 'package:learnflutter/data/bean/cloneable.dart';

part 'position.g.dart';

@JsonSerializable()
class Position implements Cloneable{
  int id;
  String address;
  double x;
  double y;
  double z;
  int stay;
  int timestamp;
  int bsAddress;
  String sampleTime;
  int sampleBatch;

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);

  Map<String, dynamic> toJson() => _$PositionToJson(this);

  Position(
    this.id,
    this.address,
    this.x,
    this.y,
    this.z,
    this.stay,
    this.timestamp,
    this.bsAddress,
    this.sampleTime,
    this.sampleBatch
  );

  @override
  clone() {
    return Position(id, address, x, y, z, stay, timestamp, bsAddress, sampleTime, sampleBatch);
  }

  @override
  String toString() {
    return 'id:$id, address:$address, '
        'x:$x, y:$y, z:$z, stay:$stay, timestamp:$timestamp'
        'bsAddress:$bsAddress, sampleTime:$sampleTime, sampleBatch:$sampleBatch\n';
  }
}