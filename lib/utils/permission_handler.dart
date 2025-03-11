import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionManager {
  static Future<bool> requestStoragePermission(BuildContext context) async {
    if (Platform.isAndroid) {
      if (await _requestAndroidPermission()) {
        return true;
      }
    } else if (Platform.isIOS) {
      if (await _requestIOSPermission()) {
        return true;
      }
    }
    
    // Show explanation dialog if permission denied
    if (context.mounted) {
      await _showPermissionDeniedDialog(context);
    }
    return false;
  }

  static Future<bool> _requestAndroidPermission() async {
    // For Android 13 and above
    if (await Permission.photos.request().isGranted) {
      return true;
    }
    
    // For older Android versions
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> _requestIOSPermission() async {
    return await Permission.photos.request().isGranted;
  }

  static Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This app needs storage permission to save images to your gallery. '
          'Please enable it in your device settings.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}