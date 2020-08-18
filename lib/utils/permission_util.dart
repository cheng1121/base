import 'dart:io';

import 'package:base/route/page_route.dart';
import 'package:base/widgets/hint_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionUtil = PermissionUtil();

enum AppPermissionStatus {
  ///未请求过
  undetermined,

  ///通过
  granted,

  ///拒绝(ios:提示去设置界面;android:可以再次请求)
  denied,

  ///拒绝且无法更改权限状态（仅ios：当未请求过处理）
  restricted,

  ///拒绝并且不再展示（仅Android：去设置界面）
  permanentlyDenied,
}

enum PermissionOption {
  ///不需要请求
  granted,

  ///请求权限
  request,

  ///去设置界面
  toSetting,
}

///去权限设置界面
Future<bool> toSetting() async {
  return await openAppSettings();
}

class PermissionUtil {
  ///author: cheng
  ///time:2020/7/31
  ///desc: 权限检查，返回要执行的操作
  Future<PermissionOption> checkPermission(Permission permission) async {
    return _statusToOption(await _checkPermission(permission));
  }

  Future<AppPermissionStatus> _checkPermission(Permission permission) async {
    final status = await permission.status;
    return _toAppStatus(status);
  }

  AppPermissionStatus _toAppStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.undetermined:
        return AppPermissionStatus.undetermined;
      case PermissionStatus.granted:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      default:
        return null;
    }
  }

  PermissionOption _statusToOption(AppPermissionStatus status) {
    PermissionOption option = PermissionOption.granted;
    switch (status) {
      case AppPermissionStatus.undetermined:
        option = PermissionOption.request;
        break;
      case AppPermissionStatus.granted:
        option = PermissionOption.granted;
        break;
      case AppPermissionStatus.denied:
        if (Platform.isIOS) {
          option = PermissionOption.toSetting;
        } else {
          option = PermissionOption.request;
        }
        break;
      case AppPermissionStatus.restricted:
        option = PermissionOption.request;
        break;
      case AppPermissionStatus.permanentlyDenied:
        option = PermissionOption.toSetting;
        break;
    }
    return option;
  }

//请求多个权限
  Future<Map<Permission, AppPermissionStatus>> _requestPermissions(
      List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses.map((key, value) {
      return MapEntry(key, _toAppStatus(value));
    });
  }

  ///author:cheng
  ///time: 2020-05-30 13:50:46
  ///desc: 请求权限 [permissions]权限列表
  Future<Map<Permission, PermissionOption>> request(
      List<Permission> permissions) async {
    assert(permissions.isNotEmpty, 'permissions is empty');
    final reqList = <Permission>[];
    final result = <Permission, PermissionOption>{};

    ///检查每个权限的状态
    // final list = permissions.map((element) async {
    //   return await checkPermission(element);
    // }).toList();
    for (Permission per in permissions) {
      final status = await _checkPermission(per);
      switch (_statusToOption(status)) {
        case PermissionOption.granted:
          result[per] = PermissionOption.granted;
          break;
        case PermissionOption.request:
          reqList.add(per);
          break;
        case PermissionOption.toSetting:
          result[per] = PermissionOption.toSetting;
          break;
      }
    }
    if (reqList.isNotEmpty) {
      final map = await _requestPermissions(reqList);
      result.addAll(map.map((key, value) {
        return MapEntry<Permission, PermissionOption>(
            key, _statusToOption(value));
      }));
    }

    return result;
  }

  ///author:cheng
  ///time: 2020-05-30 13:51:48
  ///desc: 请求位置权限(运行时权限)
  Future<bool> requestLocationPermission(BuildContext context) async {
    final map = await request([Permission.locationWhenInUse]);
    final state = map[Permission.locationWhenInUse];
    switch (state) {

      ///请求通过
      case PermissionOption.granted:
        return true;

      ///需要再次请求的权限
      case PermissionOption.request:
        return false;

      ///需要用户去设置界面手动打开的权限
      case PermissionOption.toSetting:
        showLocationPermissionHint(context);
        return false;
    }
    return false;
  }

  ///author:cheng
  ///time: 2020-05-30 14:12:15
  ///desc: 存储权限 (ios是文档文件夹和下载文件夹的读写权限)
  Future<bool> requestStoragePermission(BuildContext context) async {
    final map = await request([Permission.storage]);
    switch (map[Permission.storage]) {
      case PermissionOption.granted:
        return true;
      case PermissionOption.request:
        return false;
      case PermissionOption.toSetting:
        showStoragePermissionHint(context);
        return false;
    }
    return false;
  }

  ///author:cheng
  ///time: 2020-05-30 14:13:29
  ///desc: 访问用户相册 android:存储权限  ios:是相册权限
  Future<bool> requestPhotosPermission(BuildContext context) async {
    if (Platform.isAndroid) {
      return requestStoragePermission(context);
    } else {
      final map = await request([Permission.photos]);
      switch (map[Permission.photos]) {
        case PermissionOption.granted:
          return true;
        case PermissionOption.request:
          return false;
        case PermissionOption.toSetting:
          showPhotosPermissionHint(context);
          return false;
      }
      return false;
    }
  }

  ///author:cheng
  ///time: 2020-05-30 14:23:52
  ///desc: 相机权限
  Future<bool> requestCameraPermission(BuildContext context) async {
    final map = await request([Permission.camera]);
    switch (map[Permission.camera]) {
      case PermissionOption.granted:
        return true;
      case PermissionOption.request:
        return false;
      case PermissionOption.toSetting:
        showCameraPermissionHint(context);
        return false;
    }
    return false;
  }

  ///author:cheng
  ///time: 2020-05-30 14:33:49
  ///desc: 拍摄权限(android:相机、存储、录音；ios：相机、相册、录音)
  Future<Map<Permission, PermissionOption>> requestShootPermission(
      BuildContext context) async {
    final map = await request([
      Permission.camera,
      Permission.microphone,
      Platform.isIOS ? Permission.photos : Permission.storage
    ]);
    return map;
  }

  ///author:cheng
  ///time: 2020-05-30 16:31:53
  ///desc: 录音权限（）
  Future<bool> requestAudioPermission(BuildContext context) async {
    final micMap = await request([Permission.microphone]);
    switch (micMap[Permission.microphone]) {
      case PermissionOption.granted:
        return true;
      case PermissionOption.request:
        return false;
      case PermissionOption.toSetting:
        showAudioPermissionHint(context);
        return false;
    }
    return false;
  }
}

void showStoragePermissionHint(BuildContext context) {
  showHintDialog(context,
      hint: '开启存储权限才能执行此操作',
      onCancel: () {
        AppPage.pop(context);
      },
      confirm: '设置',
      onConfirm: () {
        AppPage.pop(context);
        toSetting();
      });
}

void showAudioPermissionHint(BuildContext context) {
  showHintDialog(context,
      hint: '开启录音权限，才可以发送语音',
      onCancel: () {
        AppPage.pop(context);
      },
      confirm: '设置',
      onConfirm: () {
        AppPage.pop(context);
        toSetting();
      });
}

void showCameraPermissionHint(BuildContext context) {
  showHintDialog(context,
      hint: '拍摄需要相机权限、存储权限和录音权限，未开启录音权限将无法录制视频',
      onCancel: () {
        AppPage.pop(context);
      },
      confirm: '设置',
      onConfirm: () {
        AppPage.pop(context);
        toSetting();
      });
}

void showVideoPermissionHint(BuildContext context) {
  showHintDialog(context,
      hint: '拼图社交拍摄短视频需要照相机权限',
      onCancel: () {
        AppPage.pop(context);
      },
      confirm: '设置',
      onConfirm: () {
        AppPage.pop(context);
        toSetting();
      });
}

void showPhotosPermissionHint(BuildContext context) {
  showHintDialog(context,
      hint: '查看照片需要访问媒体资料库权限',
      onCancel: () {
        AppPage.pop(context);
      },
      confirm: '设置',
      onConfirm: () {
        AppPage.pop(context);
        toSetting();
      });
}

void showLocationPermissionHint(BuildContext context) {
  showHintDialog(context,
      hint: '拼图社交需要定位权限，请开启定位权限',
      onCancel: () {
        AppPage.pop(context);
      },
      confirm: '设置',
      onConfirm: () {
        AppPage.pop(context);
        toSetting();
      });
}
