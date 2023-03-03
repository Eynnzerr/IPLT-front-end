import 'package:flutter/material.dart';
import 'package:learnflutter/data/bean/position.dart';

class Point extends StatelessWidget {
  const Point({
    Key? key, 
    this.left,
    this.top,
    required this.isPosition, 
    this.position,
    required this.onClick
  }) : super(key: key);

  final double? left;
  final double? top;
  final bool isPosition;
  final Position? position;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    MaterialColor color = Colors.blue;
    switch (position?.id) {
      case -1:
        color = Colors.red;
        break;
      case -2:
        color = Colors.green;
        break;
      default:
        color = Colors.blue;
        break;
    }
    return Positioned(
        left: isPosition ? 350 + position!.x * 942 / 12.3 : left,
        top: isPosition ? 361 - position!.y * 660 / 8.603 : top,
        child: InkWell(
          onTap: onClick,
          child: CircleAvatar(
              radius: 4,
              backgroundColor: color
          ),
        )
    );
  }
}
