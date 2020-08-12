import 'package:base/http/check_network.dart';
import 'package:base/http/dio_client.dart';
import 'package:base/http/http_error.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:base/extensions/string_extensions.dart';

enum HttpMethod {
  get,
  post,
  delete,
  put,
  head,
  patch,
}

///author:cheng
///time: 2020-07-26 13:07:27
///desc: 网络请求抽象类，在app内部创建xxxHttp类并继承BaseHttp
///重写setBaseUrl方法设置基础url
///
///如果需要关闭http请求log，则重写logEnable()方法返回false
///
///如果有cookie，则重写userCookie方法并返回true，此时cookie缓存在RAM中；
///如果需要cookie缓存到本地，则需要
///重写cookieLocalDir方法设置cookie返回的目录
///
abstract class BaseHttp {
  final LogInterceptor _logInterceptor =
      LogInterceptor(requestBody: true, responseBody: true);
  CookieManager _cookieManager;

  String setBaseUrl();

  bool useCookie() {
    return false;
  }

  bool logEnable() {
    return true;
  }

  Map<String, String> commonParams() {
    return <String, String>{};
  }

  String cookieLocalDir() {
    return '';
  }

  CookieManager get cookieManager => _cookieManager;

  Future<Map<String, dynamic>> _http(
    HttpMethod method,
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
    FormData formData,
  }) async {
    final hasNetwork = await CheckNetwork.checkConnect();
    if (!hasNetwork) {
      final error = HttpError(HttpError.NETWORK_ERROR, '网络异常，请稍后重试！');
      if (onError != null) {
        onError(error);
      }
      return Future.error(error);
    }
    reqParams = reqParams ?? {};
    try {
      var commonQueryParameters = <String, String>{};
      var interceptors = <Interceptor>[];
      if (logEnable()) {
        interceptors.add(_logInterceptor);
      }
      if (useCookie()) {
        var cookieJar;
        if (cookieLocalDir().checkNull()) {
          ///如果本地文件夹路径为null则使用内存缓存cookie
          cookieJar = CookieJar();
        } else {
          cookieJar = PersistCookieJar(dir: cookieLocalDir());
        }
        if (_cookieManager == null) {
          _cookieManager = CookieManager(cookieJar);
        }
        interceptors.add(_cookieManager);
      }
      if (commonParams() != null) {
        commonQueryParameters.addAll(commonParams());
      }
      if (headers == null) {
        headers = {'User-Agent': '', 'Access-Control-Allow-Origin': true};
      }
      BaseOptions options = DioHttpClient.createOption(baseUrl,
          headers: headers, queryParameters: commonQueryParameters);
      var dioClient = DioHttpClient.getInstance()
          .getClient(baseUrl, newOptions: options, interceptors: interceptors);

      Response<Map<String, dynamic>> response;
      switch (method) {
        case HttpMethod.get:
          response = await dioClient.get(pathUrl,
              queryParameters: reqParams, cancelToken: cancelToken);
          break;
        case HttpMethod.post:
          response = await dioClient.post(pathUrl,
              queryParameters: reqParams,
              cancelToken: cancelToken,
              data: formData);
          break;
        case HttpMethod.delete:
          response = await dioClient.delete(pathUrl,
              data: formData,
              queryParameters: reqParams,
              cancelToken: cancelToken);
          break;
        case HttpMethod.put:
          response = await dioClient.put(pathUrl,
              data: formData,
              queryParameters: reqParams,
              cancelToken: cancelToken);
          break;
        case HttpMethod.head:
          response = await dioClient.head(pathUrl,
              data: formData,
              queryParameters: reqParams,
              cancelToken: cancelToken);
          break;
        case HttpMethod.patch:
          response = await dioClient.patch(pathUrl,
              data: formData,
              queryParameters: reqParams,
              cancelToken: cancelToken);
          break;
      }

      if (onSuccess != null) {
        onSuccess(response.data);
      }
      return Future.value(response.data);
    } on DioError catch (e, s) {
      print('请求出错=============$e\n$s');
      if (onError != null && e.type != DioErrorType.CANCEL) {
        onError(HttpError.dioError(e));
      }
      return Future.error(HttpError.dioError(e));
    } catch (e, s) {
      print('未知异常=============$e\n$s');
      final error = HttpError(HttpError.UNKNOWN, '网络异常，请稍后重试！');
      if (onError != null) {
        onError(error);
      }
      return Future.error(error);
    }
  }

  Future<Map<String, dynamic>> get(
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
  }) {
    reqParams = reqParams ?? {};
    baseUrl = baseUrl ?? setBaseUrl();
    return _http(
      HttpMethod.get,
      pathUrl,
      baseUrl: baseUrl,
      reqParams: reqParams,
      headers: headers,
      onError: onError,
      onSuccess: onSuccess,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> post(
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
    FormData formData,
  }) {
    reqParams = reqParams ?? <String, dynamic>{};
    baseUrl = baseUrl ?? setBaseUrl();

    return _http(
      HttpMethod.post,
      pathUrl,
      formData: formData,
      reqParams: reqParams,
      headers: headers,
      onSuccess: onSuccess,
      onError: onError,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> delete(
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
    FormData formData,
  }) {
    reqParams = reqParams ?? <String, dynamic>{};
    baseUrl = baseUrl ?? setBaseUrl();

    return _http(
      HttpMethod.delete,
      pathUrl,
      formData: formData,
      reqParams: reqParams,
      headers: headers,
      onSuccess: onSuccess,
      onError: onError,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> head(
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
    FormData formData,
  }) {
    reqParams = reqParams ?? <String, dynamic>{};
    baseUrl = baseUrl ?? setBaseUrl();

    return _http(
      HttpMethod.head,
      pathUrl,
      formData: formData,
      reqParams: reqParams,
      headers: headers,
      onSuccess: onSuccess,
      onError: onError,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> patch(
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
    FormData formData,
  }) {
    reqParams = reqParams ?? <String, dynamic>{};
    baseUrl = baseUrl ?? setBaseUrl();

    return _http(
      HttpMethod.patch,
      pathUrl,
      formData: formData,
      reqParams: reqParams,
      headers: headers,
      onSuccess: onSuccess,
      onError: onError,
      cancelToken: cancelToken,
    );
  }

  Future<Map<String, dynamic>> put(
    String pathUrl, {
    String baseUrl,
    Map<String, dynamic> reqParams,
    Map<String, dynamic> headers,
    ValueSetter<Map<String, dynamic>> onSuccess,
    ValueSetter<HttpError> onError,
    CancelToken cancelToken,
    FormData formData,
  }) {
    reqParams = reqParams ?? <String, dynamic>{};
    baseUrl = baseUrl ?? setBaseUrl();

    return _http(
      HttpMethod.put,
      pathUrl,
      formData: formData,
      reqParams: reqParams,
      headers: headers,
      onSuccess: onSuccess,
      onError: onError,
      cancelToken: cancelToken,
    );
  }
}
