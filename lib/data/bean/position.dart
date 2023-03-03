import 'package:json_annotation/json_annotation.dart';
import 'package:learnflutter/data/bean/cloneable.dart';

part 'position.g.dart';

@JsonSerializable()
class Position implements Cloneable{
  int id = 0; // for predictions: id = -1  for groundTruth: id = -2
  String address = "no address";
  double x = 0;
  double y = 0;
  double z = 0;
  int stay = 1;
  int timestamp = 0;
  int bsAddress = 0;
  String sampleTime = "no sample time";
  int sampleBatch = 0;

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

  Position.fromCoordinates(
    this.id,
    this.x,
    this.y
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

  // ground truth
  // children: const [
  //   Point(left: 350, top: 361, isPosition: false),  // 712,723
  //   Point(left: 350-1*942/12.3, top: 361-3.4*660/8.603, isPosition: false),
  //   Point(left: 350-1*942/12.3, top: 361-2.2*660/8.603, isPosition: false),
  //   Point(left: 350-1*942/12.3, top: 361-1*660/8.603, isPosition: false),
  //   Point(left: 350-1*942/12.3, top: 361+0.2*660/8.603, isPosition: false),
  //   Point(left: 350-1*942/12.3, top: 361+1.4*660/8.603, isPosition: false),
  //   Point(left: 350-1*942/12.3, top: 361+2.6*660/8.603, isPosition: false),
  //   Point(left: 350-0.6*942/12.3, top: 361+3.2*660/8.603, isPosition: false),
  //   Point(left: 350+0.2*942/12.3, top: 361+3.2*660/8.603, isPosition: false),
  //   Point(left: 350+1.2*942/12.3, top: 361+3.2*660/8.603, isPosition: false),
  //   Point(left: 350+1.5*942/12.3, top: 361+2.6*660/8.603, isPosition: false),
  //   Point(left: 350+1.5*942/12.3, top: 361+1.4*660/8.603, isPosition: false),
  //   Point(left: 350+1.5*942/12.3, top: 361+0.2*660/8.603, isPosition: false),
  //   Point(left: 350+1.5*942/12.3, top: 361-1*660/8.603, isPosition: false),
  //   Point(left: 350+1.5*942/12.3, top: 361-2.2*660/8.603, isPosition: false),
  //   Point(left: 350+1.5*942/12.3, top: 361-3.4*660/8.603, isPosition: false),
}