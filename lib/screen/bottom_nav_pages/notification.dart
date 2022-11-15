import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class notificationn extends StatefulWidget {
  const notificationn({super.key});

  @override
  State<notificationn> createState() => _NotificationState();
}

class _NotificationState extends State<notificationn> {
  @override
  void initState() {
    super.initState();

    //forground state
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
      }
    });

    //App is opened but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data['path']);
      }
    });

    //app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data['path']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
