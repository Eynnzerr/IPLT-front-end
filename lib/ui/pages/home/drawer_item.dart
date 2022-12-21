import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({Key? key, required this.iconData, required this.title}) : super(key: key);
  final IconData iconData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData),
          const Spacer(),
          Text(title),
          const Spacer(flex: 3)
        ],
      ),
    );
  }
}
