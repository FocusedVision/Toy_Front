import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("!!!");
  print(message.data);

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<Map<String, dynamic>>.broadcast();

  final streamBackground = StreamController<Map<String, dynamic>>.broadcast();

  final streamTerminated = StreamController<Map<String, dynamic>>.broadcast();

  setNotifications() {
    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission();
    }
    _firebaseMessaging.getInitialMessage().then((message) {
      print("^^^^");
      print(message);
      if (message != null) {
        print(message.data);
        streamTerminated.sink.add(message.data);
      }
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        print("@@@");
        print(message.data);

        streamCtlr.sink.add(message.data);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("%%%");
      print(message.data);
      streamBackground.sink.add(message.data);
    });
    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    streamCtlr.close();
  }
}
