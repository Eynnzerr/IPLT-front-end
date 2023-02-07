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
  final posList = <Position>[].obs;
  final runList = <Running>[].obs;
  var title = 'IPLT 室内行人轨迹定位系统 v1.0.0';
  late final Worker _navigationWorker;
  late final SharedPreferences _sp;

  int get navigationIndex => _navigationIndex.value;
  bool get railExtended => _railExtended.value;
  int get darkMode => _darkMode.value;
  SharedPreferences get sp => _sp;
  set navigationIndex(int newValue) => _navigationIndex.value = newValue;
  set darkMode(int mode) {
    // set observable and sharedPreferences at the same time.
    _sp.setInt(PreferenceKeys.darkMode, mode);
    _darkMode.value = mode;
  }

  void updateExtended() => _railExtended.value = !_railExtended.value;

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