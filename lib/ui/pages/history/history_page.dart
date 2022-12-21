import 'package:flutter/material.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      desktopChild: Text('HISTORY desktop'),
      mobileChild: Text('HISTORY mobile'),
    );
  }
}
