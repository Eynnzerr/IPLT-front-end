import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/common_model.dart';
import 'package:learnflutter/data/model/map_model.dart';
import 'package:learnflutter/ui/common/page_scaffold.dart';
import 'package:learnflutter/ui/pages/map/point.dart';
import 'package:collection/collection.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  final globalModel = Get.find<GlobalModel>();
  final mapModel = Get.put(MapModel());

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      desktopChild: _DesktopMapPage(globalModel: globalModel, mapModel: mapModel,),
      mobileChild: const _MobileMapPage(),
    );
  }
}

class _DesktopMapPage extends StatelessWidget {
  const _DesktopMapPage({Key? key, required this.globalModel, required this.mapModel}) : super(key: key);

  final GlobalModel globalModel;
  final MapModel mapModel;

  Widget _buildChart(BuildContext context) {
    List<charts.Series<ChartData, double>> seriesList = [
      charts.Series<ChartData, double>(
        id: 'CDF',
        domainFn: (ChartData data, _) => data.value,
        measureFn: (ChartData data, _) => data.percent,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        data: mapModel.cdfData,
      ),
    ];

    return charts.LineChart(
      seriesList,
      animate: true,
      animationDuration: const Duration(milliseconds: 500),
      behaviors: [
        charts.ChartTitle('欧氏距离误差(m)',
          behaviorPosition: charts.BehaviorPosition.bottom,
          titleOutsideJustification:
          charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('CDF 百分比',
          behaviorPosition: charts.BehaviorPosition.start,
          titleOutsideJustification:
          charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
                child: Obx(() => Stack(
                  alignment: Alignment.center,
                  children: mapModel.displayPos.mapIndexed((index, pos) => Point(isPosition: true, position: pos, onClick: () => mapModel.selectedPosIndex = index)).toList(),
                ))
            ),
            Row(
              children: [
                const Text('显示基站定位结果'),
                Obx(() => Switch(
                  value: mapModel.showPositions,
                  onChanged: (newValue) => mapModel.updateShowPositions(newValue, globalModel.posList)
                  ))
              ],
            ),
            Row(
              children: [
                const Text('显示PDR预测结果'),
                Obx(() => Switch(
                  value: mapModel.showPredictions,
                  onChanged: (newValue) => mapModel.updateShowPredictions(newValue,)
                ))
              ],
            ),
            Row(
              children: [
                const Text('显示真实采样轨迹'),
                Obx(() => Switch(
                    value: mapModel.showGroundTruth,
                    onChanged: (newValue) => mapModel.updateShowGroundTruth(newValue)
                ))
              ],
            ),
            Obx(() => Text('平均距离误差:${mapModel.meanError} m.'))
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // information of current selected position
            Container(
              alignment: Alignment.topLeft,
              constraints: const BoxConstraints.tightFor(width: 450, height: 400),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(4.0),
                color: Theme.of(context).cardColor
              ),
              padding: const EdgeInsets.all(10.0),
              child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('id: ${globalModel.posList[mapModel.selectedPosIndex].id}'),
                  Text('address: ${globalModel.posList[mapModel.selectedPosIndex].address}'),
                  Text('x: ${globalModel.posList[mapModel.selectedPosIndex].x}'),
                  Text('y: ${globalModel.posList[mapModel.selectedPosIndex].y}'),
                  Text('z: ${globalModel.posList[mapModel.selectedPosIndex].z}'),
                  Text('stay: ${globalModel.posList[mapModel.selectedPosIndex].stay}'),
                  Text('timestamp: ${globalModel.posList[mapModel.selectedPosIndex].timestamp}'),
                  Text('bsAddress: ${globalModel.posList[mapModel.selectedPosIndex].bsAddress}'),
                  Text('sampleTime: ${globalModel.posList[mapModel.selectedPosIndex].sampleTime}'),
                  Text('sampleBatch: ${globalModel.posList[mapModel.selectedPosIndex].sampleBatch}'),
                  ElevatedButton(
                    onPressed: () {
                      // TODO 获取ground truth长度传入 ground truth在globalModel中获取
                      mapModel.fetchPDRResult(globalModel.posList[mapModel.selectedPosIndex].sampleBatch,);
                    },
                    child: const Text('开始预测'),
                  ),
                ],
              ))
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              constraints: const BoxConstraints.tightFor(width: 450, height: 400),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(4.0),
                color: Theme.of(context).cardColor
              ),
              padding: const EdgeInsets.all(10.0),
              child: Obx(
                    () => mapModel.cdfData.isEmpty
                    ? const CircularProgressIndicator()
                    : _buildChart(context),
              ),
            ),
          ],
        )
      ],
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