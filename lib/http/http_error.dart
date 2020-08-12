import 'package:dio/dio.dart';

///author: cheng
///time:2020/8/11
///desc: dio网络请求错误

class HttpError implements Exception {
  ///http 状态码
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int REQUEST_TIMEOUT = 408;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int BAD_GATEWAY = 502;
  static const int SERVICE_UNAVAILABLE = 503;
  static const int GATEWAY_TIMEOUT = 504;

  ///未知错误
  static const String UNKNOWN = "UNKNOWN";

  ///解析错误
  static const String PARSE_ERROR = "PARSE_ERROR";

  ///网络错误
  static const String NETWORK_ERROR = "NETWORK_ERROR";

  ///协议错误
  static const String HTTP_ERROR = "HTTP_ERROR";

  ///证书错误
  static const String SSL_ERROR = "SSL_ERROR";

  ///连接超时
  static const String CONNECT_TIMEOUT = "CONNECT_TIMEOUT";

  ///响应超时
  static const String RECEIVE_TIMEOUT = "RECEIVE_TIMEOUT";

  ///发送超时
  static const String SEND_TIMEOUT = "SEND_TIMEOUT";

  ///网络请求取消
  static const String CANCEL = "CANCEL";

  final String code;
  final String message;

  HttpError(this.code, this.message);

  HttpError.dioError(DioError dioError)
      : message = getCode(false, dioError.type, dioError.message),
        code = getCode(true, dioError.type, dioError.message);

  static String getCode(bool isCode, DioErrorType errorType, String msg) {
    switch (errorType) {
      case DioErrorType.CONNECT_TIMEOUT:
        if (isCode) {
          return CONNECT_TIMEOUT;
        }
        return "网络连接超时，请检查网络";

      case DioErrorType.SEND_TIMEOUT:
        return isCode ? SEND_TIMEOUT : "网络连接超时，请检查网络";
      case DioErrorType.RECEIVE_TIMEOUT:
        return isCode ? RECEIVE_TIMEOUT : '服务器异常，请稍后重试！';
      case DioErrorType.RESPONSE:
        return isCode ? HTTP_ERROR : '服务器异常，请稍后重试！';
      case DioErrorType.CANCEL:
        return isCode ? CANCEL : '请求已被取消，请重新请求';
      case DioErrorType.DEFAULT:
        return isCode ? UNKNOWN : '网路异常，请稍后重试';
      default:
        return isCode ? UNKNOWN : msg;
    }
  }
}
