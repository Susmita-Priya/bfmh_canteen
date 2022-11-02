import 'dart:io';

import 'package:bfmh_canteen/screen/bottom_nav_pages/MDrawer.dart';
import 'package:bfmh_canteen/screen/login_screen.dart';
import 'package:bfmh_canteen/stuff/Mydrawer.dart';
import 'package:bfmh_canteen/stuff/home.dart';
import 'package:bfmh_canteen/widgets/custombutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class addproduct extends StatefulWidget {
  const addproduct({super.key});

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  File? _image;
  final imagePicker = ImagePicker();
  String? url;
  String? _fileName;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _desController = TextEditingController();
  TextEditingController _availController = TextEditingController();
  TextEditingController _imgController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Future uploadimg() async {
    Reference ref =
        FirebaseStorage.instance.ref('product-images/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();
    print(url);
  }

  Future sendUserDataToDB() async {
    Reference ref =
        FirebaseStorage.instance.ref('product-images/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();
    print(url);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('products')
        .doc()
        .set({
          "product-name": _nameController.text,
          "product-description": _desController.text,
          "product-available": _availController.text,
          "product-price": _priceController.text,
          'product-img': url,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Successfully added"),
              Navigator.push(context, MaterialPageRoute(builder: (_) => home()))
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
                        backgroundImage: const AssetImage('assets/Logo.jpeg'),
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
                  "Add food item",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.h,
                ),
                // Text(
                //   "Your feedback help us for imporving",
                //   style: TextStyle(
                //     fontSize: 14.sp,
                //     //color: Color(0xFFBBBBBB),
                //     color: Colors.black,
                //   ),
                // ),
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
                TextFormField(
                  controller: _desController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.description),
                    iconColor: Colors.orange,
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    hintText: "Enter the item description",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  controller: _availController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.event_available_rounded),
                    iconColor: Colors.orange,
                    labelText: 'Availablity',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    hintText: "Enter the item availablity",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    // border: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(8)),
                    icon: Icon(Icons.price_change),
                    iconColor: Colors.orange,
                    labelText: 'Item Price',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    hintText: "Enter the item price",
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
                // //     _phoneController),
                // Container(
                //   // flex: 3,
                // child:
                Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _image == null
                                  ? const Center(
                                      child: Text("Select the item image"),
                                    )
                                  : Image.file(_image!))
                        ],
                      ),
                    )),
                // ),
                ElevatedButton(
                  onPressed: () async {
                    final pick = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      if (pick != null) {
                        _image = File(pick.path);
                        _fileName = pick.name;
                        if (_image != null) {
                          uploadimg().whenComplete(() => SnackBar(
                                content: Text("Picture is selected"),
                                duration: Duration(milliseconds: 400),
                              ));
                        }
                      } else {
                        final snackBar = SnackBar(
                          content: Text("No image selected"),
                          duration: Duration(milliseconds: 400),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  child: Text(
                    "Add Image",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                // TextField(
                //   controller: _feedbackController,
                //   keyboardType: TextInputType.multiline,
                //   maxLines: null,
                //   minLines: 1,
                //   decoration: InputDecoration(
                //     icon: Icon(Icons.feedback),
                //     iconColor: Colors.orange,
                //     labelText: 'Feedback',
                //     labelStyle: TextStyle(
                //       fontSize: 20.sp,
                //       color: Colors.orange,
                //     ),
                //     hintText: "Give Feedback",
                //     hintStyle: TextStyle(
                //       fontSize: 14.sp,
                //       color: Colors.grey,
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                customButton("Added", () => sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
