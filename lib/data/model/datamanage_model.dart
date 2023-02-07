import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';

class DataManageModel extends GetxController {

  final batchList = <int>[27].obs;
  final _selectedBatch = 27.obs;
  final _uploadPath = "".obs;
  // final pathController = TextEditingController();
  int get selectedBatch => _selectedBatch.value;
  set selectedBatch(int batch) => _selectedBatch.value = batch;
  String get uploadPath => _uploadPath.value;
  set uploadPath(String path) => _uploadPath.value = path;

  FilePickerResult? _result;

  void loadBatchList() async {
    HttpResponse<List<int>> res = await DioClient.instance.getBatchList();
    batchList.value = res.success ? res.data??[] : [];
    if (res.success) {
      Get.snackbar(
        '批次信息',
        '成功获取有效批次号数据',
        icon: const Icon(Icons.check_circle_outline_outlined),
        shouldIconPulse: true,
        backgroundColor: Colors.white60.withOpacity(0.2)
      );
    } else {
      Get.snackbar(
          '批次信息',
          '获取批次失败。错误信息：${res.err}',
          icon: const Icon(Icons.error_outline_outlined),
          shouldIconPulse: true,
          backgroundColor: Colors.white60.withOpacity(0.2)
      );
    }
  }

  void pickFile() async {
    _result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (_result != null) {
      // model.uploadPath = result.files.single.path??"读取路径失败";  On web this is forbidden. We can only get file name and its bytes.
      uploadPath = _result!.files.first.name;
    }
  }

  void uploadFile() async {
    if (_result != null) {
      var file = _result!.files.single;
      bool success = await DioClient.instance.uploadBytes(file.bytes, file.name);
      if (success) {
        // 提示成功
      } else {
        // 提示失败
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    loadBatchList();
    // pathController.addListener(() => _uploadPath.value = pathController.text);
  }
}