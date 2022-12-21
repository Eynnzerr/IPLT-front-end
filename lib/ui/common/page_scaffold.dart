import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/ui/common/scaffold_drawer.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({Key? key, this.desktopChild, this.mobileChild, this.breakPoint=600}) : super(key: key);
  
  final double breakPoint;
  final Widget? desktopChild;
  final Widget? mobileChild;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Inject singleton model.
    final model = Get.isRegistered<CommonModel>() ? Get.find<CommonModel>() : Get.put(CommonModel());

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

  final CommonModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(model.title.value),
        leading: IconButton(
            onPressed: () => model.updateExtended(),
            icon: const Icon(Icons.menu)
        ),
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(Icons.refresh)
          ),
          IconButton(
              onPressed: null,
              icon: Icon(Icons.light_mode)
          ),
          IconButton(
              onPressed: null,
              icon: Icon(Icons.person)
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
            extended: model.railExtended.value,
            selectedIndex: model.navigationIndex.value,
            onDestinationSelected: (int index) => model.navigationIndex.value = index,
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

  final CommonModel model;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text('IPLT 室内行人轨迹定位系统 v1.0.0'),
        actions: const [
          IconButton(
              onPressed: null,
              icon: Icon(Icons.refresh)
          ),
          IconButton(
              onPressed: null,
              icon: Icon(Icons.light_mode)
          ),
          IconButton(
              onPressed: null,
              icon: Icon(Icons.person)
          )
        ],
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '系统主页'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: '室内定位',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '系统设置',
          ),
        ],
        currentIndex: model.navigationIndex.value,
        onTap: (int index) => model.navigationIndex.value = index,
      ),
      body: child,
    ));
  }
}
