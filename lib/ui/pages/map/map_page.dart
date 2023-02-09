import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/config/log_utils.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';
import 'package:learnflutter/ui/pages/map/point.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  final globalModel = Get.find<GlobalModel>();

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      desktopChild: _DesktopMapPage(globalModel: globalModel,),
      mobileChild: const _MobileMapPage(),
    );
  }
}

class _DesktopMapPage extends StatelessWidget {
  const _DesktopMapPage({Key? key, required this.globalModel}) : super(key: key);

  final GlobalModel globalModel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.tightFor(width: 942, height: 660),
        decoration: BoxDecoration(
          border: Border.all(
            width: 3.0
          ),
          image: const DecorationImage(
              image: AssetImage('assets/images/map.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: globalModel.posList.map((pos) => Point(isPosition: true, position: pos,)).toList(),
          // children: const [
          //   Point(left: 350, top: 361, isPosition: false),  // 712,723
          //   Point(left: 350-1*942/12.3, top: 361-3.4*660/8.603, isPosition: false),
          //   Point(left: 350-1*942/12.3, top: 361-2.2*660/8.603, isPosition: false),
          //   Point(left: 350-1*942/12.3, top: 361-1*660/8.603, isPosition: false),
          //   Point(left: 350-1*942/12.3, top: 361+0.2*660/8.603, isPosition: false),
          //   Point(left: 350-1*942/12.3, top: 361+1.4*660/8.603, isPosition: false),
          //   Point(left: 350-1*942/12.3, top: 361+2.6*660/8.603, isPosition: false),
          //   Point(left: 350-0.6*942/12.3, top: 361+3.2*660/8.603, isPosition: false),
          //   Point(left: 350+0.2*942/12.3, top: 361+3.2*660/8.603, isPosition: false),
          //   Point(left: 350+1.2*942/12.3, top: 361+3.2*660/8.603, isPosition: false),
          //   Point(left: 350+1.5*942/12.3, top: 361+2.6*660/8.603, isPosition: false),
          //   Point(left: 350+1.5*942/12.3, top: 361+1.4*660/8.603, isPosition: false),
          //   Point(left: 350+1.5*942/12.3, top: 361+0.2*660/8.603, isPosition: false),
          //   Point(left: 350+1.5*942/12.3, top: 361-1*660/8.603, isPosition: false),
          //   Point(left: 350+1.5*942/12.3, top: 361-2.2*660/8.603, isPosition: false),
          //   Point(left: 350+1.5*942/12.3, top: 361-3.4*660/8.603, isPosition: false),
          // ],
        ),
      ),
    );
  }
}

class _MobileMapPage extends StatelessWidget {
  const _MobileMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}