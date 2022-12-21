import 'package:flutter/material.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      desktopChild: Text('SETTINGS desktop'),
      mobileChild: Text('SETTINGS mobile'),
    );
  }
}