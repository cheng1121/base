import 'package:flutter/cupertino.dart';

enum ViewState {
  busy,
  idle,
  error,
  empty,
}

/// 普通view读取数据
class BaseViewModel with ChangeNotifier {
  ///防止页面销毁后，异步任务才完成，导致数据报错
  bool _disposed = false;

  ViewState _viewState;
  String errorCode;
  String errorMessage;

  ///根据状态构造
  BaseViewModel({ViewState viewState})
      : _viewState = viewState ?? ViewState.idle;

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewState = viewState;

    /// 通知状态更新
    notifyListeners();
  }

  bool get busy => viewState == ViewState.busy;

  bool get idle => viewState == ViewState.idle;

  bool get empty => viewState == ViewState.empty;

  bool get error => viewState == ViewState.error;

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  void setIdle() {
    viewState = ViewState.idle;
  }

  void setError({String code, String message}) {
    errorCode = code;
    errorMessage = message;
    viewState = ViewState.error;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      //页面被销毁后，异步任务返回的数据不再传递
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _disposed = true;
  }
}
