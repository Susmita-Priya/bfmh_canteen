import 'package:bfmh_canteen/screen/login_screen.dart';
import 'package:bfmh_canteen/screen/registration_screen.dart';
import 'package:bfmh_canteen/stuff/loginstaff.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class welcomescreen extends StatefulWidget {
  const welcomescreen({super.key});

  @override
  State<welcomescreen> createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/dash2.jpg'), fit: BoxFit.cover),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 170, left: 40),
                  child: Column(
                    children: [
                      Text(
                        'BFMH Canteen',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.orange,
                                offset: Offset(3, 3),
                              )
                            ]),
                      ),
                      Text(
                        ' Jagannath University',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200],
                            shadows: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.orange,
                                offset: Offset(2, 2),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 80, right: 24),
                      child: Text(
                        'Where tasteful creations begin',
                        style: GoogleFonts.lobster(
                          fontSize: 18,
                          color: Colors.grey[200],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    // ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 8, left: 44, right: 44, bottom: 10),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginscreen()));
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        color: Colors.orange,
                        child: Text(
                          'Student',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 8, left: 44, right: 44),
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginscreenstaff()));
                        },
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        color: Colors.orange,
                        child: Text(
                          'Staff',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
