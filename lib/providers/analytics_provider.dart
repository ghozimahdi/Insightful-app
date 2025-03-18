import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:io';

class AnalyticsProvider {
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  AnalyticsProvider._internal();

  static final AnalyticsProvider _singleton = AnalyticsProvider._internal();

  factory AnalyticsProvider() => _singleton;

  static void logCustomEvent(String title, Map<String, Object> parameters) {
    observer.analytics.logEvent(name: title, parameters: parameters);
  }

  static void setCurrentScreen(String screenName) {
    observer.analytics.logScreenView(screenName: screenName);
  }

  static void logLogin(String method) {
    analytics.logLogin(loginMethod: method);
  }

  static void logShare(String method, String content, String itemId) {
    analytics.logShare(contentType: Platform.operatingSystem, itemId: itemId, method: method);
  }
}
