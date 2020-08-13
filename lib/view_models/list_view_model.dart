import 'package:base/view_models/base_view_model.dart';

abstract class ListViewModel<T> extends BaseViewModel {
  List<T> list = [];

  void initData() async {
    setBusy();
    await refresh(init: true);
  }

  Future<void> refresh({bool init = false}) async {
    List<T> data = await loadData();
    list.clear();
    if (data.isEmpty) {
      setEmpty();
    } else {
      list.addAll(data);
      setIdle();
    }
  }

  Future<List<T>> loadData();
}
