import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Background message received:");
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Data: ${message.data}");
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<Map<String, dynamic>>.broadcast();
  final streamBackground = StreamController<Map<String, dynamic>>.broadcast();
  final streamTerminated = StreamController<Map<String, dynamic>>.broadcast();

  // setNotifications() {
  //   if (Platform.isIOS) {
  //     _firebaseMessaging.requestPermission();
  //   }
  //   _firebaseMessaging.getInitialMessage().then((message) {
  //     print("^^^^");
  //     print(message);
  //     if (message != null) {
  //       print(message.data);
  //       streamTerminated.sink.add(message.data);
  //     }
  //   });
  //   FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  //   FirebaseMessaging.onMessage.listen(
  //     (message) async {
  //       print("@@@");
  //       print(message.data);

  //       streamCtlr.sink.add(message.data);
  //     },
  //   );

  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print("%%%");
  //     print(message.data);
  //     streamBackground.sink.add(message.data);
  //   });
  //   // With this token you can test it easily on your phone
  //   final token =
  //       _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  // }

  setNotifications() async {
    // Request permissions on both platforms
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Authorization status: ${settings.authorizationStatus}");

    // Get FCM token and print it
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print("App opened from terminated state with message:");
      print(initialMessage.data);
      streamTerminated.sink.add(initialMessage.data);
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("Foreground message received:");
        print("Title: ${message.notification?.title}");
        print("Body: ${message.notification?.body}");
        print("Data: ${message.data}");

        streamCtlr.sink.add(message.data);
      },
    );

    // Handle background to foreground messages
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("App opened from background with message:");
      print(message.data);
      streamBackground.sink.add(message.data);
    });
  }

  dispose() {
    streamCtlr.close();
  }
}
