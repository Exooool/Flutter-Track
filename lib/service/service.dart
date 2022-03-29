import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

//规定函数类型
typedef BackError = Function(int code, String msg);

String jiguang =
    'Basic N2M1MTJkYTY0NjQ0NmNjNjlmOWM1NWE1Ojg4NTI2OWE1NDNlZmVjZTdlMTQ1OGZjZQ==';

class DioUtil {
  late Dio dio;

  //服务器ip
  static const String baseUrl = 'http://10.0.2.2:3000';
  static const String imgBaseUrl = 'http://10.0.2.2:3000';
  BaseOptions options = BaseOptions();

  DioUtil() {
    //注册请求服务器
    options.baseUrl = baseUrl;
    //设置连接超时单位毫秒
    options.connectTimeout = 5000;
    //  响应流上前后两次接受到数据的间隔，单位为毫秒。如果两次间隔超过[receiveTimeout]，
    //  [Dio] 将会抛出一个[DioErrorType.RECEIVE_TIMEOUT]的异常.
    //  注意: 这并不是接收数据的总时限.
    options.receiveTimeout = 3000;
    //设置请求超时单位毫秒
    options.sendTimeout = 5000;
    //如果返回数据是json(content-type)，
    // dio默认会自动将数据转为json，
    // 无需再手动转](https://github.com/flutterchina/dio/issues/30)
    options.responseType = ResponseType.json;

    // 默认请求头
    Map<String, dynamic> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json; charset=UTF-8",
    };
    options.headers = headers;

    dio = Dio(options);
  }

  void get(String url,
      {Map<String, dynamic>? data, required success, required error}) async {
    // isNet().then((value) {
    //   print(value);
    // });

    Response response;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    if (token == null || token == '') {
      return;
    }
    options.headers["Authorization"] = token;
    dio = Dio(options);

    try {
      if (data == null) {
        response = await dio.get(url);
      } else {
        response = await dio.get(url, queryParameters: data);
      }

      if (response.statusCode == 200) {
        success(response.data);
      } else {
        error(response.statusCode, "数据服务出现异常！");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        error('网络异常，连接超时');
      } else {
        error(e);
      }
    }
  }

  void post(String url,
      {dynamic data, required success, required error}) async {
    Response response;

    // 取token数据
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    if (token == null || token == '') {
      return;
    }
    options.headers["Authorization"] = token;

    dio = Dio(options);

    try {
      if (data == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: data);
      }

      if (response.statusCode == 200) {
        success(response.data);
      } else {
        error(response.statusCode, "数据服务出现异常！");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        error('网络异常，连接超时');
      } else {
        error(e);
      }
    }
  }

  logPost(String url,
      {Map<String, dynamic>? data, required success, required error}) async {
    Response response;
    // 设置极光api的认证
    options.headers["Authorization"] = jiguang;
    dio = Dio(options);

    try {
      if (data == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: data);
      }

      if (response.statusCode == 200) {
        success(response.data);
      } else {
        error(response.statusCode, "数据服务出现异常！");
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        error('网络异常，连接超时');
      } else {
        error(e);
      }
    }
  }

  // Future<String> imgPost(String url,
  //     {Map<String, dynamic>? data, required success, required error}) async {
  //   Response response;

  //   // 取token数据
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString("token");
  //   if (token != null) {
  //     options.headers["Authorization"] = token;

  //     dio = Dio(options);

  //     try {
  //       if (data == null) {
  //         response = await dio.post(url);
  //       } else {
  //         response = await dio.post(url, data: data);
  //       }

  //       if (response.statusCode == 200) {
  //         success(response.data);
  //       } else {
  //         error(response.statusCode, "数据服务出现异常！");
  //       }
  //     } on DioError catch (e) {
  //       error(e);
  //     }
  //   }
  // }

  Future<bool> isNet() async {
    try {
      final result = await InternetAddress.lookup('https://www.baidu.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
  // 判断是否有网
  // void isNet(error) async {
  //   //没有网络
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     error('网络异常，请检查你的网络！');
  //     return;
  //   }
  // }
}
