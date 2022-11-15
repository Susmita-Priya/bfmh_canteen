import 'package:bfmh_canteen/screen/splah_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey =
      'pk_test_51M2UksKY4JfapoEkifYtEa4qYN6HRNGm21c3vNSlcTiBRgc8JUjW4vEKzYI2Qgyg9XAduuO3kiDB9SAuJpLL8XA700lD95i9tN';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Canteen',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: SplahScreen(),
        );
      },
    );
  }
}
