import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? mtoken = " ";

  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    getToken();

    FirebaseMessaging.instance.subscribeToTopic("Animal");
  }

  void getTokenFromFirestore() async {}

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc("ps4966829@gmail.com")
        .set({
      'token': token,
    });
  }

  void sendPushMessage(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAxt0XGZM:APA91bFvpqq62Np51ytKveIiwgp_Z3-2lAvHuS5b8FVmzEOAcYbn2Mq22lq9EWVOXKFsZwhp0LLzy_Q1NJ_b88dyIiBXnGCBtASb0JZeNTTtXrIgj-oevjF1hMx6P_xfeCmz_xNSQ7tk',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });

      saveToken(token!);
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: username,
            ),
            TextFormField(
              controller: title,
            ),
            TextFormField(
              controller: body,
            ),
            GestureDetector(
              onTap: () async {
                String name = username.text.trim();
                String titleText = title.text;
                String bodyText = body.text;

                if (name != "") {
                  DocumentSnapshot snap = await FirebaseFirestore.instance
                      .collection("UserTokens")
                      .doc(name)
                      .get();

                  String token = snap['token'];
                  print(token);

                  sendPushMessage(token, titleText, bodyText);
                }
              },
              child: Container(
                height: 40,
                width: 200,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

//   String? mtoken = " ";
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _itemController = TextEditingController();
//   TextEditingController _totalController = TextEditingController();
//   TextEditingController _statusController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     requestPermission();
//     getToken();
//   }

//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

//   void getToken() async {
//     await FirebaseMessaging.instance.getToken().then((token) {
//       setState(() {
//         mtoken = token;
//         print("My token is $mtoken");
//       });
//       saveToken(token!);
//     });
//   }

//   void saveToken(String token) async {
//     await FirebaseFirestore.instance
//         .collection("usertokens")
//         .doc("ps4966829@gmail.com")
//         .set({
//       'token': token,
//     });
//   }

// // call from button
//   void sendPushMessage(String token, String body, String title) async {
//     try {
//       await http.post(
//         Uri.parse('http://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization':
//               'key=AAAAxt0XGZM:APA91bFvpqq62Np51ytKveIiwgp_Z3-2lAvHuS5b8FVmzEOAcYbn2Mq22lq9EWVOXKFsZwhp0LLzy_Q1NJ_b88dyIiBXnGCBtASb0JZeNTTtXrIgj-oevjF1hMx6P_xfeCmz_xNSQ7tk'
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'status': 'done',
//               'body': body,
//               'title': title,
//             },
//             "notification": <String, dynamic>{
//               "title": title,
//               "android_channel_id": "dbfood"
//             },
//             "to": token,
//           },
//         ),
//       );
//     } catch (e) {
//       if (kDebugMode) {
//         print("error push notification");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         //backgroundColor: Colors.orange,
//         body: SafeArea(
//             child: Padding(
//       padding: EdgeInsets.all(20.w),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GestureDetector(
//               onTap: (() async {
//                 String email = "ps4966829@gmail.com";
//                 String title = "Your Food is being ";
//                 String body = "body";

//                 if (email != "") {
//                   DocumentSnapshot snap = await FirebaseFirestore.instance
//                       .collection("usertokens")
//                       .doc(email)
//                       .get();

//                   String token = snap['token'];
//                   print(token);

//                   sendPushMessage(token, body, title);
//                 }
//               }),
//             ),
//           ],
//         ),
//       ),
//     )));
//   }
}
