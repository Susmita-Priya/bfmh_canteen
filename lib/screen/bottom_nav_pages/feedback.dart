import 'package:bfmh_canteen/screen/bottom_nav_pages/MDrawer.dart';
import 'package:bfmh_canteen/screen/login_screen.dart';
import 'package:bfmh_canteen/widgets/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedbackState();
}

class _FeedbackState extends State<FeedBack> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _feedbackController = TextEditingController();

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    String? email = FirebaseAuth.instance.currentUser!.email;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("feedback");
    return _collectionRef
        .doc()
        .set({
          "item_name": _nameController.text,
          "feedback": _feedbackController.text,
          "email": email,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Thanks For Your Feedback"),
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MDrawer()))
            })
        .catchError((error) => print("something is wrong. $error"));
  }

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
                        backgroundImage: const AssetImage('assets/feed.png'),
                        radius: MediaQuery.of(context).size.height / 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit Your Feedback",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  "Your feedback help us for imporving",
                  style: TextStyle(
                    fontSize: 14.sp,
                    //color: Color(0xFFBBBBBB),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                // myTextField(
                //     "enter your name", TextInputType.text, _nameController),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.fastfood),
                    iconColor: Colors.orange,
                    labelText: 'Item Name',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    hintText: "Enter the item name",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // myTextField("enter your phone number", TextInputType.number,
                //     _phoneController),
                TextField(
                  controller: _feedbackController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    icon: Icon(Icons.feedback),
                    iconColor: Colors.orange,
                    labelText: 'Feedback',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    hintText: "Give Feedback",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                customButton("Continue", () => sendUserDataToDB()),
                // ListTile(
                //   // leading: const Icon(
                //   //   CupertinoIcons.archivebox_fill,
                //   //   color: Colors.red,
                //   // ),
                //   title: Container(
                //     color: Colors.black,
                //     child: MaterialButton(
                //       onPressed: () {
                //         sendUserDataToDB();
                //       },
                //       padding: EdgeInsets.all(20),
                //       child: const Text(
                //         "Submit",

                //         //textAlign: TextAlign.center,
                //         style: TextStyle(
                //             //backgroundColor: Colors.redAccent,
                //             fontSize: 22,
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
