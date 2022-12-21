import 'package:flutter/material.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

class DataPage extends StatelessWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      desktopChild: Text('DATA desktop'),
      mobileChild: Text('DATA mobile'),
    );
  }
}
