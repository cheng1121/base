# base

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
  sqflite: ^1.2.0 #flutter 中的数据库，可以在Android和iOS中同时使用
  #网络请求
  dio: ^3.0.9
  dio_cookie_manager: ^1.0.0
  cookie_jar: ^1.0.1
  connectivity: '>=0.4.9 <2.0.0'

  path_provider: ^1.6.11 #抹平android和ios平台 文件路径的差异化
  shared_preferences: ^0.5.8 #本地轻量化数据存储  类似 Android中的SP
  device_info: ^0.4.2+2 #设备信息
  oktoast: ^2.1.7 # 全局Toast
  provider: ^4.3.1 #状态管理
  permission_handler: ^5.0.1+1  #动态权限申请
  #图片和视频相关
  photo_manager: ^0.5.6 #从本地图库选择多图(基础api类)
  #图片编辑，展示,网络图片缓存等等
  extended_image: ^1.1.0
  #图片编辑，原生库
  image_editor: ^0.7.1
  flutter_ffmpeg: ^0.2.10 #ffmpeg命令
  video_player: '>=0.10.11+2 <2.0.0'


  #上拉加载和下拉刷新
  flutter_easyrefresh: ^2.1.5

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