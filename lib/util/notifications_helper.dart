import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class NotificationsHelper {
  void printIfDebugMode(Object error) {
    if (kDebugMode) print(error.toString());
  }

  void showText(String text, {BuildContext? context}) {
    log('NotificationHelper showText: $text');
    context == null
        ? ElegantNotification.info(
            title: const Text('Info', style: TextStyle(color: Colors.black)),
            description: Text(text, style: const TextStyle(color: Colors.black)),
            toastDuration: const Duration(seconds: 5),
          )
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
              backgroundColor: Colors.black,
            ),
          );
  }

  void showError(String error, {BuildContext? context}) {
    if (kDebugMode) NotificationsHelper().printIfDebugMode(error);
    if (error.contains(']')) error = error.split(']').last;

    context == null
        ? ElegantNotification.error(
            title: const Text('Error', style: TextStyle(color: Colors.redAccent)),
            description: Text(error.trim(), style: const TextStyle(color: Colors.black)),
            toastDuration: const Duration(seconds: 5),
          )
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
  }

  void showSuccess(String success) => ElegantNotification.success(
        title: const Text('Success', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
        description: Text(success.trim(), style: const TextStyle(color: Colors.black)),
        toastDuration: const Duration(seconds: 5),
      );

  void showNotification(String title, String message) {
    ElegantNotification.info(
      title: Text(title, style: const TextStyle(color: Colors.black)),
      description: Text(message, style: const TextStyle(color: Colors.black)),
      toastDuration: const Duration(seconds: 5),

    );
  }
}
