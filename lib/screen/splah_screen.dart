import 'dart:async';

import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/screen/login_screen.dart';
import 'package:bfmh_canteen/screen/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplahScreen extends StatefulWidget {
  const SplahScreen({super.key});

  @override
  State<SplahScreen> createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen> {
  @override
  void initState() {
    Timer(
        Duration(seconds: 2),
        () => Navigator.push(
            context, CupertinoPageRoute(builder: (_) => welcomescreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolours.Orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "BFMH Canteen",
                style: GoogleFonts.lobster(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 44.sp),
              ),
              SizedBox(height: 10.h),
              CircleAvatar(
                backgroundImage: AssetImage("assets/Logo.jpeg"),
                radius: MediaQuery.of(context).size.height / 10,
              ),
              //CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
