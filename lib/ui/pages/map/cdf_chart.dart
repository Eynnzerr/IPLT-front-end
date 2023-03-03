import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/model/map_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CDFChart extends StatelessWidget {
  const CDFChart({super.key, required this.mapModel});

  final MapModel mapModel;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var chartData = mapModel.getChartData();
      return charts.LineChart(
        chartData,
        animate: false,
      );
    });
  }
}