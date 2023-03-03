import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnflutter/utils/network/dio_utils.dart';

class DataManageModel extends GetxController {

  final batchList = <int>[27].obs;
  final _selectedBatch = 27.obs;
  final _posPath = ''.obs;
  final _runPath = ''.obs;
  final _truthPath = ''.obs;
  int get selectedBatch => _selectedBatch.value;
  set selectedBatch(int batch) => _selectedBatch.value = batch;
  String get posPath => _posPath.value;
  set posPath(String path) => _posPath.value = path;
  String get runPath => _runPath.value;
  set runPath(String path) => _runPath.value = path;
  String get truthPath => _truthPath.value;
  set truthPath(String path) => _truthPath.value = path;

  FilePickerResult? _posResult; // 现在需要写3个这样的逻辑：pos run truth
  FilePickerResult? _runResult; 
  FilePickerResult? _truthResult;

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

  void pickPosFile() async {
    _posResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (_posResult != null) {
      // model.uploadPath = result.files.single.path??"读取路径失败";  On web this is forbidden. We can only get file name and its bytes.
      posPath = _posResult!.files.first.name;
    }
  }

  void uploadPosFile() async {
    if (_posResult != null) {
      var file = _posResult!.files.single;
      bool success = await DioClient.instance.uploadPosBytes(file.bytes, file.name);
      if (success) {
        // 提示成功
      } else {
        // 提示失败
      }
    }
  }

  void pickRunFile() async {
    _runResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (_runResult != null) {
      // model.uploadPath = result.files.single.path??"读取路径失败";  On web this is forbidden. We can only get file name and its bytes.
      runPath = _runResult!.files.first.name;
    }
  }

  void uploadRunFile() async {
    if (_runResult != null) {
      var file = _runResult!.files.single;
      bool success = await DioClient.instance.uploadRunBytes(file.bytes, file.name);
      if (success) {
        // 提示成功
      } else {
        // 提示失败
      }
    }
  }

  void pickTruthFile() async {
    _truthResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (_truthResult != null) {
      // model.uploadPath = result.files.single.path??"读取路径失败";  On web this is forbidden. We can only get file name and its bytes.
      truthPath = _truthResult!.files.first.name;
    }
  }

  void uploadTruthFile() async {
    if (_truthResult != null) {
      var file = _truthResult!.files.single;
      // TODO 先本地解析，画在map中，再在调用pdr接口时代入参数 方法需要返回由gt组成的list

      bool success = await DioClient.instance.uploadPosBytes(file.bytes, file.name);
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