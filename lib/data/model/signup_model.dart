import 'package:get/get.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';

class SignupModel extends GetxController {
  final _formProgress = 0.0.obs;
  final _username = "".obs;
  final _password = "".obs;

  double get formProgress => _formProgress.value;
  String get username => _username.value;
  String get password => _password.value;

  void updateProgress() {
    var progress = 0.0;
    if (_username.isNotEmpty) progress += 0.5;
    if (_password.isNotEmpty) progress += 0.5;
    _formProgress.value = progress;
  }

  void updateUsername(String name) => _username.value = name;

  void updatePassword(String passwd) => _password.value = passwd;

  Future<bool> loginByPassword(String username, String password) => DioClient.instance.login(username, password);
}