import 'package:flutter/material.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/data/bean/running.dart';

class Point extends StatelessWidget {
  const Point({
    Key? key, 
    this.left,
    this.top,
    required this.isPosition, 
    this.position,
  }) : super(key: key);

  final double? left;
  final double? top;
  final bool isPosition;
  final Position? position;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: isPosition ? 350 + position!.x * 942 / 12.3 : left,
        top: isPosition ? 361 - position!.y * 660 / 8.603 : top,
        child: InkWell(
          onTap: () {
            // TODO show information
          },
          child: const CircleAvatar(
              radius: 4,
              backgroundColor: Colors.blue
          ),
        )
    );
  }
}
