import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '/auth/firebase_auth/auth_util.dart';

bool _fcmInitialized = false;

Future<void> initPushNotifications() async {
  if (_fcmInitialized) return;
  _fcmInitialized = true;

  try {
    final messaging = FirebaseMessaging.instance;

    // Request permission (required for iOS).
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM: permission=${settings.authorizationStatus}');

    // On iOS, wait for the APNS token before requesting FCM token.
    if (Platform.isIOS) {
      String? apnsToken;
      for (int i = 0; i < 10; i++) {
        apnsToken = await messaging.getAPNSToken();
        debugPrint('FCM: APNS attempt $i: ${apnsToken != null}');
        if (apnsToken != null) break;
        await Future.delayed(const Duration(seconds: 2));
      }
      if (apnsToken == null) {
        debugPrint('FCM: gave up waiting for APNS token');
        _fcmInitialized = false;
        return;
      }
    }

    // Show notifications even when the app is in the foreground (iOS).
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages to ensure they are displayed.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('FCM: foreground message received: ${message.notification?.title}');
    });

    // Get the token and save it.
    final token = await messaging.getToken();
    debugPrint('FCM: got token=${token != null}');
    if (token != null) {
      await _saveTokenToFirestore(token);
      debugPrint('FCM: saved to Firestore');
    }

    // Listen for token refreshes.
    messaging.onTokenRefresh.listen(_saveTokenToFirestore);
  } catch (e) {
    debugPrint('FCM error: $e');
    _fcmInitialized = false;
  }
}

Future<void> _saveTokenToFirestore(String token) async {
  if (currentUserReference == null) {
    debugPrint('FCM: no user ref, skipping save');
    return;
  }
  await currentUserReference!.update({'fcmToken': token});
}
