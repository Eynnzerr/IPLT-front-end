import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:learnflutter/data/model/home_model.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';
import 'package:learnflutter/ui/pages/home/home_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      desktopChild: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'images/logo.png',
            width: 800,
            fit: BoxFit.fitWidth,
          ),
          const Positioned(
            bottom: 15.0,
            child: Text(
              '欢迎使用IPLT系统，XX',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            )
          )
        ],
      ),
      mobileChild: Center(
        child: Image.asset(
          'images/logo.png',
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({
//     Key? key,
//     required this.breakPoint,
//   }) : super(key: key);
//
//   final double breakPoint;
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final model = Get.put(HomeModel());
//
//     if (screenWidth >= breakPoint) {
//       return DesktopHomePage(model: model);
//     }
//     else {
//       return MobileHomePage(model: model);
//     }
//   }
// }
//
// class DesktopHomePage extends StatelessWidget {
//   const DesktopHomePage({Key? key, required this.model}) : super(key: key);
//
//   final HomeModel model;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//       appBar: AppBar(
//         title: const Text('IPLT 室内行人轨迹定位系统 v1.0.0'),
//         leading: IconButton(
//           onPressed: () => model.updateExtended(),
//           icon: const Icon(Icons.menu)
//         ),
//         actions: const [
//           IconButton(
//               onPressed: null,
//               icon: Icon(Icons.refresh)
//           ),
//           IconButton(
//               onPressed: null,
//               icon: Icon(Icons.light_mode)
//           ),
//           IconButton(
//             onPressed: null,
//             icon: Icon(Icons.person)
//           )
//         ],
//       ),
//       body: Row(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           NavigationRail(
//             destinations: const [
//               NavigationRailDestination(
//                   icon: Icon(Icons.home),
//                   label: Text('系统主页')
//               ),
//               NavigationRailDestination(
//                   icon: Icon(Icons.data_thresholding_outlined),
//                   label: Text('数据管理')
//               ),
//               NavigationRailDestination(
//                   icon: Icon(Icons.my_location),
//                   label: Text('室内定位')
//               ),
//               NavigationRailDestination(
//                   icon: Icon(Icons.history),
//                   label: Text('历史记录')
//               ),
//               NavigationRailDestination(
//                   icon: Icon(Icons.settings),
//                   label: Text('系统设置')
//               ),
//             ],
//             trailing: const Expanded(
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(bottom: 20.0),
//                   child: FlutterLogo(),
//                 ),
//               ),
//             ),
//             extended: model.railExtended.value,
//             selectedIndex: model.selectedIndex.value,
//             onDestinationSelected: (int index) => model.selectedIndex.value = index,
//             elevation: 3,
//           ),
//           Expanded(
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 Image.asset(
//                   'images/logo.png',
//                   width: 800,
//                   fit: BoxFit.fitWidth,
//                 ),
//                 const Positioned(
//                   bottom: 15.0,
//                   child: Text(
//                     '欢迎使用IPLT系统，XX',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold
//                     ),
//                   )
//                 )
//               ],
//             )
//           )
//         ],
//       ),
//     ));
//   }
// }
//
// class MobileHomePage extends StatelessWidget {
//   const MobileHomePage({Key? key, required this.model}) : super(key: key);
//
//   final HomeModel model;
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//       appBar: AppBar(
//         title: const Text('IPLT 室内行人轨迹定位系统 v1.0.0'),
//         actions: const [
//           IconButton(
//               onPressed: null,
//               icon: Icon(Icons.refresh)
//           ),
//           IconButton(
//               onPressed: null,
//               icon: Icon(Icons.light_mode)
//           ),
//           IconButton(
//               onPressed: null,
//               icon: Icon(Icons.person)
//           )
//         ],
//       ),
//       drawer: const HomeDrawer(),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: '系统主页'
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.my_location),
//             label: '室内定位',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: '系统设置',
//           ),
//         ],
//         currentIndex: model.selectedIndex.value,
//         onTap: (int index) => model.selectedIndex.value = index,
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () => model.loadPosData(),
//             child: const Text('Request'),
//           ),
//           Text(model.info.value)
//         ],
//       ),
//     ));
//   }
// }
