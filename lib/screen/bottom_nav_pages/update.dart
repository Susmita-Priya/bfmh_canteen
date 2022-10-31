import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class update extends StatefulWidget {
  const update({super.key});

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  TextEditingController? _ageController;
  TextEditingController? _dobController;
  TextEditingController? _genderController;

  setDataToTextField(data) {
    return SafeArea(
      child: Column(
        children: [
          Text(
            'Update',
            style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                shadows: [
                  BoxShadow(
                    blurRadius: 15,
                    color: Colors.black,
                    offset: Offset(3, 3),
                  )
                ]),
          ),
          const SizedBox(
            height: 35,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name ',
              labelStyle: TextStyle(
                fontSize: 20.sp,
                color: Appcolours.Orange,
              ),
            ),
            controller: _nameController =
                TextEditingController(text: data['name']),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email ',
              labelStyle: TextStyle(
                fontSize: 20.sp,
                color: Appcolours.Orange,
              ),
            ),
            controller: _emailController =
                TextEditingController(text: data['email']),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone ',
              labelStyle: TextStyle(
                fontSize: 20.sp,
                color: Appcolours.Orange,
              ),
            ),
            controller: _phoneController =
                TextEditingController(text: data['phone']),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Age ',
              labelStyle: TextStyle(
                fontSize: 20.sp,
                color: Appcolours.Orange,
              ),
            ),
            controller: _ageController =
                TextEditingController(text: data['age']),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Date of Birth ',
              labelStyle: TextStyle(
                fontSize: 20.sp,
                color: Appcolours.Orange,
              ),
            ),
            controller: _dobController =
                TextEditingController(text: data['dob']),
          ),
          const SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Gender ',
              labelStyle: TextStyle(
                fontSize: 20.sp,
                color: Appcolours.Orange,
              ),
            ),
            controller: _genderController =
                TextEditingController(text: data['gender']),
          ),
          const SizedBox(
            height: 35,
          ),
          ElevatedButton(onPressed: () => updateData(), child: Text("Update"))
        ],
      ),
    );
  }

  updateData() {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      "name": _nameController!.text,
      "email": _emailController!.text,
      "phone": _phoneController!.text,
      "age": _ageController!.text,
      "dob": _dobController!.text,
      "gender": _genderController!.text,
    }).then((value) => Fluttertoast.showToast(msg: "Update successful!"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users-form-data")
              .doc(FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var data = snapshot.data;
            if (data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return setDataToTextField(data);
          },
        ),
      )),
    );
  }
}
