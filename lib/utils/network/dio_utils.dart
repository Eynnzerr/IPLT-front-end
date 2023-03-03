import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:learnflutter/config/log_utils.dart';
import 'package:learnflutter/data/bean/position.dart';
import 'package:learnflutter/data/bean/prediction.dart';
import 'package:learnflutter/data/bean/running.dart';
import 'package:learnflutter/data/sp_keys.dart';
import 'package:learnflutter/utils/network/logging_interceptor.dart';
import 'package:learnflutter/utils/network/token_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Json = Map<String, dynamic>;

enum HttpType { httpTypeGet, httpTypePost }

class Urls {
  static const testPos = '/pos/test';
  static const allPos = '/pos/all';
  static const batchPos = '/pos/batch';
  static const updatePos = '/pos/update';
  static const deletePos = '/pos/delete';
  static const uploadPos = '/pos/upload';
  static const testRun = '/run/test';
  static const allRun = '/run/all';
  static const batchRun = '/run/batch';
  static const updateRun = '/run/update';
  static const deleteRun = '/run/delete';
  static const uploadRun = '/run/upload';
  static const posBatchList = '/pos/batch_num';
  static const runBatchList = '/run/batch_num';
  static const login = '/user/login/pwd';
  static const auth = '/user/register/auth';
  static const info = '/user/register/info';
  static const send = '/user/register/send';
  static const pdr = '/pdr';
  static const uploadTruth = '/pdr/upload';
}

// uniform encapsulation for responses of http requests.
// success signifies whether this request is successful.
// If true, data carries the requested entity; If false, msg carries the reason of error.
class HttpResponse<T> {
  bool success;
  String? err;
  T? data;

  HttpResponse(this.success, {this.err, this.data});
}

class DioClient {
  DioClient._internal() {
    LoggerUtils.d(_tag, 'client is initialized.');
  }

  static DioClient instance = DioClient._internal();
  static const _tag = 'DioClient';
  static const _baseUrl = 'http://eynnzerr.top:8080';
  // static const _baseUrl = 'http://127.0.0.1:8080';

  final Dio _dio = Dio()
    ..interceptors.addAll([LoggingInterceptor(), TokenInterceptor()])
    ..options.baseUrl = _baseUrl;

  // login by username and password
  Future<bool> login(String name, String password) async {
    const url = Urls.login;
    FormData form = FormData.fromMap({
      'name': name,
      'password': password
    });
    Response response = await _post(url: url, data: form);

    // get token from json response and store in sharedPreferences
    Json result = response.data;
    int code = result['code'];
    if (code == 200) {
      String token = result['data'];
      final sp = await SharedPreferences.getInstance();
      sp.setString(PreferenceKeys.token, token);
      return true;
    } else {
      LoggerUtils.d(_tag, 'Login response is received but is wrong.');
      return false;
    }
  }

  Future<HttpResponse<List<Position>>> getTestData() async {
    const url = Urls.testPos;
    Response response = await _get(url: url);

    Json result = response.data;
    int code = result['code'];
    if (code == 200) {
      List? positions = result['data'];
      if (positions == null) {
        return HttpResponse(false, err: 'The response is OK but no data is returned.');
      }

      final data = <Position>[];
      for (var posJson in positions) {
        data.add(Position.fromJson(posJson));
      }
      return HttpResponse(true, data: data);
    } else {
      return HttpResponse(false, err: 'wtf?');
    }
  }

  Future<HttpResponse<List<Position>>> getPosByBatch(int batch) async {
    const url = Urls.batchPos;
    Response response = await _get(url: url, queryParameters: {'batch': batch});

    Json result = response.data;
    int code = result['code'];
    if (code == 200) {
      List? positions = result['data'];
      if (positions == null) {
        return HttpResponse(false, err: 'The response is OK but no data is returned.');
      }

      final data = <Position>[];
      for (var posJson in positions) {
        data.add(Position.fromJson(posJson));
      }
      return HttpResponse(true, data: data);
    } else {
      return HttpResponse(false, err: result['msg'].toString());
    }
  }

  Future<HttpResponse<List<Running>>> getRunByBatch(int batch) async {
    const url = Urls.batchRun;
    Response response = await _get(url: url, queryParameters: {'batch': batch});

    Json result = response.data;
    int code = result['code'];
    if (code == 200) {
      List? runs = result['data'];
      if (runs == null) {
        return HttpResponse(false, err: 'The response is OK but no data is returned.');
      }

      final data = <Running>[];
      for (var runJson in runs) {
        data.add(Running.fromJson(runJson));
      }
      return HttpResponse(true, data: data);
    } else {
      return HttpResponse(false, err: result['msg'].toString());
    }
  }

  Future<HttpResponse<List<int>>> getBatchList() async {
    Response response = await _get(url: Urls.posBatchList);

    Json result = response.data;
    int code = result['code'];
    if (code == 200) {
      List<int> posBatch = List<int>.from(result['data']);
      return HttpResponse(true, data: posBatch);
    } else {
      return HttpResponse(false, err: result['msg']);
    }
  }

  Future<bool> deleteData(int id, {bool isPos = true}) async {
    Response response = await _get(url: isPos ? Urls.deletePos : Urls.deleteRun, queryParameters: {'id': id});
    Json result = response.data;
    int code = result['code'];
    return code == 200 ? true : false;
  }

  Future<bool> updatePos(Position position) async {
    var data = {
      'id': position.id,
      'address': position.address,
      'x': position.x,
      'y': position.y,
      'z': position.z,
      'stay': position.stay,
      'timestamp': position.timestamp,
      'bsAddress': position.bsAddress,
      'sampleTime': position.sampleTime,
      'sampleBatch': position.sampleBatch
    };
    Response response =await _post(url: Urls.updatePos, data: data);

    Json result = response.data;
    int code = result['code'];
    return code == 200 ? true : false;
  }

  Future<bool> updateRun(Running running) async {
    var data = {
      'id': running.id,
      'address': running.address,
      'accx': running.accx,
      'accy': running.accy,
      'accz': running.accz,
      'gyroscopex': running.gyroscopex,
      'gyroscopey': running.gyroscopey,
      'gyroscopez': running.gyroscopez,
      'stay': running.stay,
      'timestamp': running.timestamp,
      'bsAddress': running.bsAddress,
      'sampleTime': running.sampleTime,
      'sampleBatch': running.sampleBatch
    };
    Response response = await _post(url: Urls.updateRun, data: data);

    Json result = response.data;
    int code = result['code'];
    return code == 200 ? true : false;
  }

  Future<HttpResponse<List<Prediction>>> runPDR(int batch, int truthNum) async {
    var data = {
      'batch': batch,
      'truth_num': truthNum,
    };
    Response response = await _post(url: Urls.pdr, data: data);

    Json result = response.data;
    int code = result['code'];

    if (code == 200) {
      List? predictions = result['data'];
      if (predictions == null) {
        return HttpResponse(false, err: 'The response is OK but no data is returned.');
      }

      final data = <Prediction>[];
      for (var predictionJson in predictions) {
        data.add(Prediction.fromJson(predictionJson));
      }
      return HttpResponse(true, data: data);
    } else {
      return HttpResponse(false, err: result['msg'].toString());
    }
  }

  Future<bool> uploadPosBytes(Uint8List? bytes, String? fileName) async {
    if (bytes == null) return false;
    var fileBytes = MultipartFile.fromBytes(bytes, filename: fileName??'');

    FormData form = FormData.fromMap({
      'name': fileName??'',
      'multipartFile': fileBytes
    });
    Response response = await _post(url: Urls.uploadPos, data: form);

    Json result = response.data;
    int code = result['code'];
    return code == 200 ? true : false;
  }

  Future<bool> uploadRunBytes(Uint8List? bytes, String? fileName) async {
    if (bytes == null) return false;
    var fileBytes = MultipartFile.fromBytes(bytes, filename: fileName??'');

    FormData form = FormData.fromMap({
      'name': fileName??'',
      'multipartFile': fileBytes
    });
    Response response = await _post(url: Urls.uploadRun, data: form);

    Json result = response.data;
    int code = result['code'];
    return code == 200 ? true : false;
  }

  // Basic request method of Dio
  Future<Response> _get({required String url, Map<String, dynamic>? queryParameters}) async {
    return await _sendHttpRequest(HttpType.httpTypeGet, url, queryParameters: queryParameters);
  }

  Future<Response> _post({required String url, dynamic data}) async {
    return await _sendHttpRequest(HttpType.httpTypePost, url, data: data);
  }

  Future _sendHttpRequest(HttpType type, String url,
      {Json? queryParameters, dynamic data}) async {
    try {
      switch (type) {
        case HttpType.httpTypeGet:
          return await _dio.get(url, queryParameters: queryParameters);
        case HttpType.httpTypePost:
          return await _dio
              .post(url, data: data);
        default:
          throw Exception('Only GET and POST method are allowed!');
      }
    } on DioError catch (e) {
      LoggerUtils.d('dio', '$e');
    }
  }
}