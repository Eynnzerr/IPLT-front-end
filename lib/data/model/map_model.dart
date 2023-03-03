import 'dart:html';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:learnflutter/config/log_utils.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/data/bean/prediction.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';

class MapModel extends GetxController {
  final _selectedPosIndex = 0.obs;
  final cdfData = <ChartData>[].obs;
  final _meanError = 0.0.obs;
  final displayPos = <Position>[].obs;
  List<Prediction> predictions = [];
  final _showPositions = false.obs;
  final _showPredictions = false.obs;
  final _showGroundTruth = false.obs;
  List<Position> groundTruth = [
    Position.fromCoordinates(-2, -1, 3.4),
    Position.fromCoordinates(-2, -1, 2.2),
    Position.fromCoordinates(-2, -1, 1),
    Position.fromCoordinates(-2, -1, -0.2),
    Position.fromCoordinates(-2, -1, -1.4),
    Position.fromCoordinates(-2, -1, -2.6),
    Position.fromCoordinates(-2, -0.6, -3.2),
    Position.fromCoordinates(-2, 0.2, -3.2),
    Position.fromCoordinates(-2, 1.2, -3.2),
    Position.fromCoordinates(-2, 1.5, -2.6),
    Position.fromCoordinates(-2, 1.5, -1.4),
    Position.fromCoordinates(-2, 1.5, -0.2),
    Position.fromCoordinates(-2, 1.5, 1),
    Position.fromCoordinates(-2, 1.5, 2.2),
    Position.fromCoordinates(-2, 1.5, 3.4),
  ];

  int get selectedPosIndex => _selectedPosIndex.value;
  set selectedPosIndex(int newValue) => _selectedPosIndex.value = newValue;
  double get meanError => _meanError.value;
  bool get showPositions => _showPositions.value;
  bool get showPredictions => _showPredictions.value;
  bool get showGroundTruth => _showGroundTruth.value;
  set showPositions(bool newValue) => _showPositions.value = newValue;
  set showPredictions(bool newValue) => _showPredictions.value = newValue;
  set showGroundTruth(bool newValue) => _showGroundTruth.value = newValue;

  void updateShowPositions(bool newValue, List<Position> positions) {
    showPositions = newValue;
    if (newValue) {
      displayPos.addAll(positions);
    } else {
      displayPos.removeWhere((element) => element.id != 0);
    }
  }

  void updateShowPredictions(bool newValue) {
    showPredictions = newValue;
    if (newValue) {
      displayPos.addAll(predictions.map((e) => Position.fromCoordinates(-1, e.x, e.y)));
    } else {
      displayPos.removeWhere((element) => element.id == -1);
    }
  }

  void updateShowGroundTruth(bool newValue) {
    showGroundTruth = newValue;
    if (newValue) {
      displayPos.addAll(groundTruth);
    } else {
      displayPos.removeWhere((element) => element.id == -2);
    }
  }

  List<charts.Series<double, int>> getChartData() {
    var sortedData = List<double>.from(cdfData)..sort();
    var dataMap = <double, int>{};
    for (var i = 0; i < sortedData.length; i++) {
      dataMap[sortedData[i]] = i + 1;
    }
    return [
      charts.Series<double, int>(
        id: 'CDF',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (_, index) => index! + 1,
        measureFn: (value, _) => dataMap[value],
        data: sortedData,
      )
    ];
  }

  void fetchPDRResult(int batch, {int truthNum = 15}) async {
    HttpResponse<List<Prediction>> res = await DioClient.instance.runPDR(batch, truthNum);
    predictions = res.data??[];
    // LoggerUtils.d('mapModel', predictions.toString());
    if (predictions.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'PDR算法运行成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green
      );
      calculateError(groundTruth);
    } else {
      Fluttertoast.showToast(
        msg: 'PDR算法预测失败',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red
      );
    }
  }

  void calculateError(List<Position> groundTruth) {
    // 根据predictions与groundTruth每个对应元素，计算误差指标，并更新模型数据，驱动UI
    // 误差指标包括：CDF图 平均定位误差 百分位定位误差
    if (predictions.isEmpty || predictions.length != groundTruth.length) return;
    var errors = <double>[];
    var sum = 0.0;
    for (int i = 0; i < predictions.length; i ++) {
      // 计算两点之间的欧氏距离作为误差
      var prediction = predictions[i];
      var truth = groundTruth[i];
      var distance = sqrt((prediction.x - truth.x) * (prediction.x - truth.x) + (prediction.y - truth.y) * (prediction.y - truth.y));
      errors.add(distance);
      sum += distance;
    }
    _meanError.value = sum / errors.length; // 均方误差
    errors.sort();

    var cumulativeData = <ChartData>[];
    for (var i = 0; i < errors.length; i++) {
      var value = errors[i];
      var count = i + 1;
      var percent = count / errors.length;
      cumulativeData.add(ChartData(value, percent));
    }
    cdfData.value = cumulativeData;
  }

}

class ChartData {
  final double value;
  final double percent;

  ChartData(this.value, this.percent);
}
