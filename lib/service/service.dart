import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

//规定函数类型
typedef BackError = Function(int code, String msg);

class DioUtil {
  late Dio dio;

  //服务器ip
  static const String baseUrl = 'http://10.0.2.2:3000';
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
    // _isNet(error);
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    options.headers["Authorization"] = prefs.getString("token");
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
      // final NetError netError = ExceptionHandle.handleException(e);
      error(e);
    }
  }

  void post(String url,
      {Map<String, dynamic>? data, required success, required error}) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    options.headers["Authorization"] = prefs.getString("token");
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
      error(e);
    }
  }

  // // 判断是否有网
  // void _isNet(BackError error) async {
  //   //没有网络
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     error(ExceptionHandle.net_error, '网络异常，请检查你的网络！');
  //     return;
  //   }
  // }
}
