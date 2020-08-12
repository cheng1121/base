import 'package:dio/dio.dart';
import 'package:base/extensions/string_extensions.dart';

class DioHttpClient {
  static const int _DEFAULT_CONNECT_TIMEOUT = 60 * 1000;
  static const int _DEFAULT_SEND_TIMEOUT = 60 * 1000;
  static const int _DEFAULT_RECEIVE_TIMEOUT = 60 * 1000;

  ///维护以为dio实例map，当存在多个baseUrl时，直接取缓存
  final Map<String, Dio> _clientMap = <String, Dio>{};

  ///单例实现
  DioHttpClient._internal();

  static final DioHttpClient _instance = DioHttpClient._internal();

  factory DioHttpClient.getInstance() => _instance;

  Dio getClient(String baseUrl,
      {BaseOptions newOptions, List<Interceptor> interceptors}) {
    if (baseUrl.checkNull()) {
      throw Exception('baseUrl not be allowed null');
    }

    Dio client = _clientMap['baseUrl'];
    if (client != null) {
      return client;
    }

    client = _createDioClient(baseUrl, options: newOptions);
    if (interceptors != null) {
      client.interceptors.addAll(interceptors);
    }
    _clientMap[baseUrl] = client;
    return client;
  }

  Dio _createDioClient(String baseUrl, {BaseOptions options}) {
    if (options == null) {
      options = createOption(baseUrl);
    }
    return Dio(options);
  }

  static BaseOptions createOption(String baseUrl,
      {Map<String, dynamic> headers, Map<String, dynamic> queryParameters}) {
    return BaseOptions(
      connectTimeout: _DEFAULT_CONNECT_TIMEOUT,
      sendTimeout: _DEFAULT_SEND_TIMEOUT,
      receiveTimeout: _DEFAULT_RECEIVE_TIMEOUT,
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      validateStatus: (status) {
        return true;
      },
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  void release() {
    _clientMap.clear();
  }
}
