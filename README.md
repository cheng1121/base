# base

### v0.0.8+1
sp返回值全部修改为Future
 
### v0.0.8
添加webview_flutter依赖,webRoute类,web_view类

### v0.0.7+2
BaseLocaleDelegate中添加 静态集合supportLanguageCode,设置app支持的语言码

### v0.0.7+1
base_locale_delegate添加 const构造

### v0.0.7
添加国际化基类
1. base_locale.dart
2. base_locale_delegate.dart

### v0.0.6
添加sp_util.dart,SharedPreferences的工具类，单例
更新第三方插件版本

### v0.0.4
添加sqflite数据库操作类DBHelper，部分sql语句封装Sql类。BaseBean

### v0.0.3
appConfig下沉到Base中，以供其他模块调用

### v0.0.2
添加album模块，包括拍摄、图片裁剪、图片多选、选择视频和视频压缩

flutter项目的基类 包含：
1. 网路请求
2. 相册
3. 工具类
4. 支付（微信支付、支付宝支付、苹果内购）
5. 自定义的拍摄功能
6. 图片裁剪功能
7. 极光IM



### 所有的依赖
```
   webview_flutter: ^0.3.22+1
   sqflite: ^1.3.1 #flutter 中的数据库，可以在Android和iOS中同时使用
   #网络请求
   dio: ^3.0.9
   dio_cookie_manager: ^1.0.0
   cookie_jar: ^1.0.1
   connectivity: '>=0.4.9 <2.0.0'
 
   path_provider: ^1.6.11 #抹平android和ios平台 文件路径的差异化
   shared_preferences: ^0.5.8 #本地轻量化数据存储  类似 Android中的SP
   device_info: ^0.4.2+2 #设备信息
   oktoast: ^2.3.2 # 全局Toast
   provider: ^4.3.2+1 #状态管理
   permission_handler: ^5.0.1+1  #动态权限申请
   #图片和视频相关
   photo_manager: ^0.5.8 #从本地图库选择多图(基础api类)
   #图片编辑，展示,网络图片缓存等等
   extended_image: ^1.1.0
   #图片编辑，原生库
   image_editor: ^0.7.1
   flutter_ffmpeg: ^0.2.10 #ffmpeg命令
   video_player: '>=0.10.12 <2.0.0'
 
 
   #上拉加载和下拉刷新
   flutter_easyrefresh: ^2.1.5
   #轮播图
   flutter_swiper: ^1.1.6
   camera:
     git:
       url: https://github.com/chengbook/camera.git
   jmessage_flutter:
     git:
       url: https://github.com/chengbook/jmessage.git
   pay:
     git:
       url: https://github.com/chengbook/pay.git
 


```