import 'dart:io';

import 'package:bfmh_canteen/stuff/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class prac extends StatefulWidget {
  const prac({super.key});

  @override
  State<prac> createState() => _pracState();
}

class _pracState extends State<prac> {
  File? _image;
  final imagePicker = ImagePicker();
  String? url;
  String? _fileName;

  Future uploadimg() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref =
        FirebaseStorage.instance.ref('product-images/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();

    await firebaseFirestore
        .collection('products')
        .doc()
        .set({'product-img': url})
        .then((value) => {
              Fluttertoast.showToast(msg: "Successful"),
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => loginscreen()))
            })
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      body: Column(
        // child: _image==null? const Center(child: Text("no image"),):
        //         Image.file(_image!);
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w, top: 100.w),
            child: IconButton(
              onPressed: () async {
                final pick =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  if (pick != null) {
                    _image = File(pick.path);
                    _fileName = pick.name;
                    uploadimg();
                  } else {
                    final snackBar = SnackBar(
                      content: Text("No image selected"),
                      duration: Duration(milliseconds: 400),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                });
                // final result = await FilePicker.platform.pickFiles(
                //   allowMultiple: true,
                //   type: FileType.custom,
                //   allowedExtensions: ['png', 'jpg', 'jpeg'],
                // );
                // if (result == null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('no file selected'),
                //     ),
                //   );
                //   return null;
                // }
                // final path = result.files.single.path!;
                // final filename = result.files.single.name;

                // storage
                //     .uploadFile(path, filename)
                //     .then((value) => print('done'));
              },
              icon: Icon(Icons.camera),
            ),
          ),
        ],
      ),
    );
  }
}
