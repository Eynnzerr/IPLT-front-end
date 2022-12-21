import 'package:get/get.dart';
import 'package:learnflutter/config/log_utils.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';

// TODO Deprecated
class HomeModel extends GetxController {
  static const _tag = 'HomeModel';

  final selectedIndex = 0.obs;  // navigation index
  final positions = <Position>[].obs;
  final info = "".obs;
  final railExtended = false.obs; // whether navigation rail is extended. Only valid for desktop/web.

  void updateExtended() => railExtended.value = !railExtended.value;

  void loadPosData() async {
    LoggerUtils.d(_tag, 'starts fetching data from remote');
    HttpResponse<List<Position>> res = await DioClient.instance.getTestData();
    if (res.success) {
      positions.value = res.data??[];
      info.value = 'success';
    } else {
      positions.value = [];
      info.value = 'failed';
      // TODO 等待一段时间后重新发起请求
    }
  }
}