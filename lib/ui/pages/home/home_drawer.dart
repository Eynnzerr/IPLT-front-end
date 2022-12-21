import 'package:flutter/material.dart';

// TODO Deprecated
class HomeDrawer extends StatelessWidget {
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(
                leading: Icon(Icons.home),
                title: Text('系统主页'),
              ),
              ListTile(
                leading: Icon(Icons.data_thresholding_outlined),
                title: Text('数据管理'),
              ),
              ListTile(
                leading: Icon(Icons.my_location),
                title: Text('室内定位'),
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('历史记录'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('系统设置'),
              ),
            ],
          ),
      ),
    );
  }
}
