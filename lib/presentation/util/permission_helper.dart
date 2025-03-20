import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'theme.dart';

extension PermissionHelperExt on BuildContext {
  Future<void> requestPermissions({
    required List<Permission> permissions,
    required Future Function() onGrantedCallback,
  }) async {
    final req = await _PermissionHelper.requestPermissions(
      this,
      permissions: permissions,
    );
    if (req) {
      await onGrantedCallback();
    }
  }
}

mixin _PermissionHelper {
  static Future<bool> requestPermissions(
    BuildContext context, {
    required List<Permission> permissions,
  }) async {
    if (Platform.isAndroid && permissions.contains(Permission.storage)) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt >= 33) {
        permissions.remove(Permission.storage);
      }
    }

    final statuses = await permissions.request();

    final allGranted = statuses.entries
        .every((entry) => entry.value.isGranted || entry.value.isLimited);

    final permanentlyDenied =
        statuses.entries.any((entry) => entry.value.isPermanentlyDenied);

    if (permanentlyDenied) {
      await _showPermissionAlert(
        context,
        title: 'Permission Required',
        description:
            'This feature requires additional permissions. Please enable them in settings.',
      );
    }

    return allGranted;
  }

  static Future<void> _showPermissionAlert(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            description,
            style: theme.textTheme.bodyLarge,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Go to Settings'),
              onPressed: () async {
                await openAppSettings();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
