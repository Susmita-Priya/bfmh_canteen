import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/screen/bottom_nav_controller.dart';
import 'package:bfmh_canteen/widgets/custombutton.dart';
import 'package:bfmh_canteen/widgets/myTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class userform extends StatefulWidget {
  //const userform({super.key});

  @override
  State<userform> createState() => _userformState();
}

class _userformState extends State<userform> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (_) => bottomnavcontroller())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Submit the form to continue.",
                  style: TextStyle(fontSize: 22.sp, color: Appcolours.Orange),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: Appcolours.Orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: _nameController,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("Name cannot be empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Name(Min. 3 Character)");
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "enter your name",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: Appcolours.Orange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: Appcolours.Orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneController,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{11,}$');
                        if (value!.isEmpty) {
                          return ("Phone number cannot be empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid number(with 11 digits)");
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "enter your phone number",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        labelText: 'Phone',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: Appcolours.Orange,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: Appcolours.Orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "date of birth",
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: Appcolours.Orange,
                        ),
                        hintText: "Enter your date of birth(optional)",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => _selectDateFromPicker(context),
                          icon: Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: Appcolours.Orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.woman,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextFormField(
                      controller: _genderController,
                      readOnly: true,
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{10,}$');
                        if (value!.isEmpty) {
                          return ("Gender cannot be empty");
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: Appcolours.Orange,
                        ),
                        hintText: "choose your gender",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        prefixIcon: DropdownButton<String>(
                          items: gender.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                              onTap: () {
                                setState(() {
                                  _genderController.text = value;
                                });
                              },
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Container(
                      height: 48.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                          color: Appcolours.Orange,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Center(
                        child: Icon(
                          Icons.lock_clock,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                      decoration: InputDecoration(
                        hintText: "enter your age(optional)",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                        labelText: 'Age',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: Appcolours.Orange,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                customButton("Continue", () => sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
