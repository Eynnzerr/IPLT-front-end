import 'package:flutter/material.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      desktopChild: Text('MAP desktop'),
      mobileChild: Text('MAP mobile'),
    );
  }
}