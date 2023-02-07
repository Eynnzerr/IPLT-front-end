import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/data/model/datamanage_model.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PageScaffold(
      desktopChild: _DesktopSettingsPage(),
      mobileChild: Text('SETTINGS mobile'),
    );
  }
}

class _DesktopSettingsPage extends StatelessWidget {
  const _DesktopSettingsPage({Key? key}) : super(key: key);
  // final DataManageModel dataModel;
  // final GlobalModel globalModel;  // Share pos & run data with map page.

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



