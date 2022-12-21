import 'package:get/get.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';

class SignupModel extends GetxController {
  final formProgress = 0.0.obs;
  final username = "".obs;
  final password = "".obs;

  void updateProgress() {
    var progress = 0.0;
    if (username.isNotEmpty) progress += 0.5;
    if (password.isNotEmpty) progress += 0.5;
    formProgress.value = progress;
  }

  void updateUsername(String name) => username.value = name;

  void updatePassword(String passwd) => password.value = passwd;

  Future<bool> loginByPassword(String username, String password) => DioClient.instance.login(username, password);
}