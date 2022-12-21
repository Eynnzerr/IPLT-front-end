import 'package:get/get.dart';
import 'package:learnflutter/routes.dart';

// Stores global data.
class CommonModel extends GetxController {

  final username = ''.obs;
  final navigationIndex = 0.obs;
  final title = ''.obs;  // TODO 可能需要改为普通变量
  final railExtended = false.obs; // whether navigation rail is extended. Only valid for desktop/web.
  late final Worker navigationWorker;

  void updateExtended() => railExtended.value = !railExtended.value;

  // Automatically navigation.
  @override
  void onInit() {
    navigationWorker = ever(navigationIndex, (selectedIndex) {
      switch (selectedIndex) {
        case 0:
          Get.toNamed(Routes.home);
          title.value = 'IPLT 室内行人轨迹定位系统 v1.0.0';
          break;
        case 1:
          Get.toNamed(Routes.data);
          title.value = '数据管理';
          break;
        case 2:
          Get.toNamed(Routes.map);
          title.value = '室内定位';
          break;
        case 3:
          Get.toNamed(Routes.history);
          title.value = '历史记录';
          break;
        case 4:
          Get.toNamed(Routes.settings);
          title.value = '系统设置';
          break;
        default:
          Get.toNamed(Routes.home);
          title.value = 'IPLT 室内行人轨迹定位系统 v1.0.0';
          break;
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    navigationWorker.dispose();
    super.dispose();
  }
}