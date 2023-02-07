import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  const DataContainer({Key? key, this.child, this.width, this.height}) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.tightFor(width: width??500, height: height??420),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 4.0,
            )
          ],
          borderRadius: BorderRadius.circular(4.0),
          color: Theme.of(context).cardColor
      ),
      padding: const EdgeInsets.all(10.0),
      child: child
    );
  }
}
