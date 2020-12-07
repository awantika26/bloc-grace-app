import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static PermissionGroup permission;
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static bool shouldShowRequestPermissionRationale = true;
  static PermissionStatus permissionStatusStorage,
      permissionStatusLocation,
      permissionStatusAudio,
      permissionStatusCamera;

  static void allowAccess() async {
    permissionStatusStorage = await PermissionHandler().checkPermissionStatus(
        Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos);

    permissionStatusCamera =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permissionStatusStorage == PermissionStatus.denied ||
        permissionStatusCamera == PermissionStatus.denied) {
      requestPermission(permission);
    }
    if (permissionStatusStorage == PermissionStatus.granted &&
        permissionStatusCamera == PermissionStatus.granted) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('Permissions Allowed'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  static requestPermission(PermissionGroup permission) async {
    Map<PermissionGroup, PermissionStatus> result =
        await PermissionHandler().requestPermissions([
      Platform.isAndroid ? PermissionGroup.storage : PermissionGroup.photos,
      PermissionGroup.camera,
    ]);

    print(result[PermissionGroup.storage]);

    print(result[PermissionGroup.camera]);

    if (result[PermissionGroup.storage] == PermissionStatus.granted &&
        result[PermissionGroup.camera] == PermissionStatus.granted) {
      permissionStatusStorage = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);

      permissionStatusCamera = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera);
    }
    if (result[PermissionGroup.storage] == PermissionStatus.denied ||
        result[PermissionGroup.camera] == PermissionStatus.denied) {
      if (shouldShowRequestPermissionRationale == true) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please go to settings to change the permissions'),
          action: SnackBarAction(
            label: 'open settings',
            onPressed: () => PermissionHandler().openAppSettings(),
            disabledTextColor: Colors.yellow,
            textColor: Colors.green,
          ),
          duration: Duration(seconds: 6),
        ));
      }
      permissionStatusStorage = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);

      permissionStatusCamera = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.camera);
    }
  }
}
