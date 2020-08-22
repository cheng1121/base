import 'package:base/view_models/list_view_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

abstract class RefreshViewModel<T> extends ListViewModel<T> {
  static const int pageNumberFirst = 0;
  static const int pageSize = 20;
  EasyRefreshController _refreshController = EasyRefreshController();
  EasyRefreshController get refreshController => _refreshController;
  int _current = pageNumberFirst;
  int get current => _current;

  Future<List<T>> refresh({bool init = false}) async {
    _current = pageNumberFirst;
    _refreshController.callRefresh();
    final data = await loadData(pageNumber: pageNumberFirst);
    if(data == null || data.isEmpty){
      _refreshController.finishRefresh(success: true,noMore: true);
      setEmpty();
    }else{
      if(data.length < pageSize){
        _refreshController.finishRefresh(success: true,noMore: true);
      }else{
        _refreshController.finishRefresh(success: true,noMore: false);
      }
      setIdle();
    }
    return data;
  }
  Future<List<T>> loadMore() async{
     final data = await loadData(pageNumber: ++ _current);
     if(data == null || data.isEmpty){
       _refreshController.finishLoad(success: true,noMore: true);
     }else{
       if(data.length < pageSize){
          _refreshController.finishLoad(success: true,noMore: true);
       }else{
         _refreshController.finishLoad(success: true,noMore: false);
       }
     }
     setIdle();
     return data;
}



  Future<List<T>> loadData({int pageNumber});

 @override
  void dispose() {
   _refreshController.dispose();
   super.dispose();
  }
}
