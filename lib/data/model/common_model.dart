import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/data/bean/running.dart';
import 'package:learnflutter/data/sp_keys.dart';
import 'package:learnflutter/routes.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Stores global data.
class GlobalModel extends GetxController {

  final _navigationIndex = 0.obs;
  final _railExtended = false.obs; // whether navigation rail is extended. Only valid for desktop/web.
  final _darkMode = 2.obs;
  final _dataEditing = false.obs;
  final posList = <Position>[].obs;
  final runList = <Running>[].obs;
  var title = 'IPLT 室内行人轨迹定位系统 v1.0.0';
  late final Worker _navigationWorker;
  late final SharedPreferences _sp;

  int get navigationIndex => _navigationIndex.value;
  bool get railExtended => _railExtended.value;
  int get darkMode => _darkMode.value;
  bool get dataEditing => _dataEditing.value;
  SharedPreferences get sp => _sp;
  set navigationIndex(int newValue) => _navigationIndex.value = newValue;
  set darkMode(int mode) {
    // set observable and sharedPreferences at the same time.
    _sp.setInt(PreferenceKeys.darkMode, mode);
    _darkMode.value = mode;
  }

  void updateExtended() => _railExtended.value = !_railExtended.value;

  void updateEditing() => _dataEditing.value = !_dataEditing.value;

  void loadPositions(int batch) async {
    HttpResponse<List<Position>> res = await DioClient.instance.getPosByBatch(batch);
    posList.value = res.success ? res.data??[] : [];
  }

  void loadRunning(int batch) async {
    HttpResponse<List<Running>> res = await DioClient.instance.getRunByBatch(batch);
    runList.value = res.success ? res.data??[] : [];
  }

  void refreshData() async {
    int batch = 27;
    if (posList.isNotEmpty) batch = posList[0].sampleBatch;

    loadPositions(batch);
    loadRunning(batch);
  }

  void deleteData(int id, {bool isPos = true}) async {
    // Delete chosen pos/run data in both memory and backend.
    // No need to refresh data by hand.
    bool success = await DioClient.instance.deleteData(id, isPos: isPos);
    if (success) {
      if (isPos) {
        posList.removeWhere((element) => element.id == id);
      } else {
        runList.removeWhere((element) => element.id == id);
      }
      Fluttertoast.showToast(
        msg: '数据删除成功',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green
      );
    } else {
      Fluttertoast.showToast(
        msg: '数据删除失败',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red
      );
    }
  }

  void updatePos(Position position) async {
    // update chosen pos/run data in both memory and backend.
    // No need to refresh data by hand.
    bool success = await DioClient.instance.updatePos(position);
    if (success) {
      Fluttertoast.showToast(
          msg: 'Position 数据更新成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green
      );
    } else {
      Fluttertoast.showToast(
          msg: 'Position 数据更新失败',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red
      );
    }
  }

  void updateRun(Running running) async {
    // update chosen pos/run data in both memory and backend.
    // No need to refresh data by hand.
    bool success = await DioClient.instance.updateRun(running);
    if (success) {
      Fluttertoast.showToast(
          msg: 'Running 数据更新成功',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green
      );
    } else {
      Fluttertoast.showToast(
          msg: 'Running 数据更新失败',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red
      );
    }
  }

  // Automatically navigation.
  @override
  void onInit() async {
    _sp = await SharedPreferences.getInstance();
    _darkMode.value = _sp.getInt(PreferenceKeys.darkMode)??2;
    _navigationWorker = ever(_navigationIndex, (selectedIndex) {
      switch (selectedIndex) {
        case 0:
          Get.toNamed(Routes.home);
          title = 'IPLT 室内行人轨迹定位系统 v1.0.0';
          break;
        case 1:
          Get.toNamed(Routes.data);
          title = '数据管理';
          break;
        case 2:
          Get.toNamed(Routes.map);
          title = '室内定位';
          break;
        case 3:
          Get.toNamed(Routes.history);
          title = '历史记录';
          break;
        case 4:
          Get.toNamed(Routes.settings);
          title = '系统设置';
          break;
        default:
          Get.toNamed(Routes.home);
          title = 'IPLT 室内行人轨迹定位系统 v1.0.0';
          break;
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    _navigationWorker.dispose();
    super.dispose();
  }
}