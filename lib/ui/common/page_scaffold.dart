import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/routes.dart';
import 'package:learnflutter/ui/common/scaffold_drawer.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({Key? key, this.desktopChild, this.mobileChild, this.breakPoint=600}) : super(key: key);
  
  final double breakPoint;
  final Widget? desktopChild;
  final Widget? mobileChild;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Already inject CommonModel at start.
    final model = Get.find<GlobalModel>();

    if (screenWidth >= breakPoint) {
      return DesktopPage(model: model, child: desktopChild,);
    }
    else {
      return MobilePage(model: model, child: mobileChild,);
    }
  }
}

class DesktopPage extends StatelessWidget {
  const DesktopPage({Key? key, this.child, required this.model}) : super(key: key);

  final GlobalModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(model.title),
        leading: IconButton(
            onPressed: () => model.updateExtended(),
            icon: const Icon(Icons.menu)
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.snackbar('刷新', '数据已重新刷新。');
              },
              icon: const Icon(Icons.refresh)
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 0,child: Text("白天模式")),
              const PopupMenuItem(value: 1,child: Text("夜间模式")),
              const PopupMenuItem(value: 2,child: Text("跟随系统")),
            ],
            icon: const Icon(Icons.dark_mode),
            onSelected: (int mode) => model.darkMode = mode,
          ),
          PopupMenuButton(
            itemBuilder: (_) => [const PopupMenuItem(value: 'logout',child: Text("下线"))],
            icon: const Icon(Icons.person),
            onSelected: (_) {
              Get.offAllNamed(Routes.signup);
            },
          )
        ],
      ),
      body: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          NavigationRail(
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('系统主页')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.data_thresholding_outlined),
                  label: Text('数据管理')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.my_location),
                  label: Text('室内定位')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.history),
                  label: Text('历史记录')
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('系统设置')
              ),
            ],
            trailing: const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: FlutterLogo(),
                ),
              ),
            ),
            extended: model.railExtended,
            selectedIndex: model.navigationIndex,
            onDestinationSelected: (int index) => model.navigationIndex = index,
            elevation: 3,
          ),
          Expanded(
              child: child??Container()
          )
        ],
      ),
    ));
  }
}

class MobilePage extends StatelessWidget {
  const MobilePage({Key? key, this.child, required this.model}) : super(key: key);

  final GlobalModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text('IPLT 室内行人轨迹定位系统 v1.0.0'),
        actions: [
          IconButton(
              onPressed: () {
                Get.snackbar('刷新', '数据已重新刷新。');
              },
              icon: const Icon(Icons.refresh)
          ),
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 0,child: Text("白天模式")),
              const PopupMenuItem(value: 1,child: Text("夜间模式")),
              const PopupMenuItem(value: 2,child: Text("跟随系统")),
            ],
            icon: const Icon(Icons.dark_mode),
            onSelected: (int mode) => model.darkMode = mode,
          ),
          PopupMenuButton(
            itemBuilder: (_) => [const PopupMenuItem(value: 'logout',child: Text("下线"))],
            icon: const Icon(Icons.person),
            onSelected: (_) {
              Get.offAllNamed(Routes.signup);
            },
          )
        ],
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => model.navigationIndex = 0,
              icon: Icon(
                Icons.home,
                color: model.navigationIndex == 0 ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
              ),
            ),
            const SizedBox(),
            IconButton(
              onPressed: () => model.navigationIndex = 4,
              icon: Icon(
                Icons.settings,
                color: model.navigationIndex == 4 ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.defaultDialog(
            middleText: 'you opened FAB.',
            onConfirm: () { }
          );
        },
        child: Icon(Icons.unfold_more),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: child,
    ));
  }
}
