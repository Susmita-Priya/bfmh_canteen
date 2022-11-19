import 'dart:convert';
import 'dart:io';
import 'package:bfmh_canteen/stuff/oderlist.dart';
import 'package:bfmh_canteen/stuff/tracesee.dart';
import 'package:http/http.dart' as http;
import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/stuff/editfood.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bfmh_canteen/stuff/home.dart';
import 'package:bfmh_canteen/widgets/custombutton.dart';

class trace1 extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  trace1(
    this.documentSnapshot,
  );
  @override
  State<trace1> createState() => _trace1State();
}

class _trace1State extends State<trace1> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _itemController = TextEditingController();
  TextEditingController _totalController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  List<String> status = [
    "Confirm",
    "Cooking food",
    "Processing food",
    "Packaging Done",
    "Cancelled",
    "HandOver"
  ];
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
        .doc(widget.documentSnapshot["email"])
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

  addData() async {
    String email = widget.documentSnapshot["email"];
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("trace");
    return _collectionRef
        .doc(widget.documentSnapshot.id)
        .update({
          "email": _emailController.text,
          "item": _itemController.text,
          "total": _totalController.text,
          "status": _statusController.text,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Successful"),
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => tracesee()))
            })
        .catchError((error) => print("something is wrong. $error"));
  }
  // deData() async {
  //   String email = widget.documentSnapshot["email"];
  //   CollectionReference _collectionRef =
  //       FirebaseFirestore.instance.collection("order");
  //   return _collectionRef
  //       .doc(widget.documentSnapshot.id)
  //     .delete()
  //       .then((value) => {

  //              Navigator.push(
  //                 context, MaterialPageRoute(builder: (_) => order()))
  //           })
  //       .catchError((error) => print("something is wrong. $error"));

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Add Order Status",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.h,
                ),

                Padding(
                  padding:
                      EdgeInsets.only(left: 90, top: 10, right: 30, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Container(
                      //   decoration: const BoxDecoration(
                      //       gradient: LinearGradient(colors: [
                      //     Color.fromARGB(255, 59, 59, 59),
                      //     Color(0xFFFF9900),
                      //   ], begin: Alignment.topCenter, end: Alignment.center)),
                      // ),
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/profile.png'),
                        //fit: BoxFit.cover,
                        radius: MediaQuery.of(context).size.height / 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                    ],
                  ),
                ),

                // Container(
                //     width: 250,
                //     height: 250,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //     child: Center(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Expanded(
                //               child: Image.network(
                //             widget._productt["product-img"],
                //             fit: BoxFit.cover,
                //           )),
                //         ],
                //       ),
                //     )),
                SizedBox(
                  height: 5.h,
                ),
                // myTextField(
                //     "enter your name", TextInputType.text, _nameController),
                TextFormField(
                  controller: _emailController = TextEditingController(
                      text: widget.documentSnapshot["email"]),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.email),
                    iconColor: Colors.orange,
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter the item name",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  controller: _itemController = TextEditingController(
                      text: widget.documentSnapshot["item"]),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.fastfood),
                    iconColor: Colors.orange,
                    labelText: 'Food items',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter the item description",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  controller: _totalController = TextEditingController(
                      text: widget.documentSnapshot["total"].toString()),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.price_change_outlined),
                    iconColor: Colors.orange,
                    labelText: 'Total Price',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter the item availablity",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _statusController,
                  readOnly: true,
                  decoration: InputDecoration(
                    icon: Icon(Icons.restaurant_menu),
                    iconColor: Colors.orange,
                    hintText: "Select Status",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    labelText: 'Status',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Appcolours.Orange,
                    ),
                    suffixIcon: DropdownButton<String>(
                      items: status.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _statusController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  width: 1.sw,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      String name = _emailController.text.trim();
                      String titleText = _itemController.text;
                      String bodyText = _statusController.text;

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
                    child: Text(
                      "Send Notification",
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Appcolours.Orange,
                      elevation: 3,
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     String name = _emailController.text.trim();
                //     String titleText = _itemController.text;
                //     String bodyText = _statusController.text;

                //     if (name != "") {
                //       DocumentSnapshot snap = await FirebaseFirestore.instance
                //           .collection("UserTokens")
                //           .doc(name)
                //           .get();

                //       String token = snap['token'];
                //       print(token);

                //       sendPushMessage(token, titleText, bodyText);
                //     }
                //   },
                //   child: Container(
                //     height: 50,
                //     width: 50,
                //     color: Colors.orange,
                //   ),
                // ),
                SizedBox(
                  height: 30.h,
                ),
                // elevated button
                customButton("Update", () => addData()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
