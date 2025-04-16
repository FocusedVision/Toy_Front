import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message received:");
  print("Title: ${message.notification?.title}");
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<Map<String, dynamic>>.broadcast();
  final streamBackground = StreamController<Map<String, dynamic>>.broadcast();
  final streamTerminated = StreamController<Map<String, dynamic>>.broadcast();

  setNotifications() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print("App opened from terminated state with message:");
      print(initialMessage.data);
      if (initialMessage.data['type'] == '1') {
        // NEW_PRODUCT_LIVE type
        print('000000000000000000000000000000000');
        streamTerminated.sink.add(initialMessage.data);
      }
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("Foreground message received:");
        print("Title: ${message.notification?.title}");
        print("Data: ${message.data}");

        streamCtlr.sink.add(message.data);
      },
    );

    // Handle background to foreground messages
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("App opened from background with message:");
      print(message.data);
      if (message.data['type'] == '1') {
        // NEW_PRODUCT_LIVE type
        streamBackground.sink.add(message.data);
      }
    });
  }

  dispose() {
    streamCtlr.close();
  }
}
