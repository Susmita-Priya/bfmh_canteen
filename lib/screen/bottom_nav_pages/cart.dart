import 'package:bfmh_canteen/screen/bottom_nav_controller.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/QRcode.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/payment.dart';
import 'package:bfmh_canteen/widgets/custombutton.dart';
import 'package:bfmh_canteen/widgets/fetchProducts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  num? total = 0;
  String? item;
  List<String> product = [];
  String? qrr;

  @override
  void initState() {
    Amount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(
              fontSize: 35,
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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        // iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
        //     child: Column(
        //   children: [
        //     Text("hghhghj"),
        //     SizedBox(
        //       height: 165,
        //     ),
        //     Container(
        //       child: fetchData("users-cart-items"),
        //     )
        //   ],
        // )
        child: fetchData("users-cart-items", total),
        // child: Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TextButton(
        //     child: const Text('Make Payment'),
        //     onPressed: () async {
        //       await makePayment();
        //     },
        //   ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              label: " Payment ",
              icon: IconButton(
                  onPressed: () async {
                    await makePayment();
                  },
                  icon: Icon(Icons.payment))),
          BottomNavigationBarItem(
            label: "",
            icon: Text("Total = " + total.toString()),
            // icon: IconButton(
            //     onPressed: () async {
            //       await deletee();
            //     },
            //     icon: Icon(Icons.payment)),
          )
        ],
      ),
    );
  }

  Amount() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get();
    setState(() {
      if (total != null) {
        for (int i = 0; i < qn.docs.length; i++) {
          total = (total! + qn.docs[i]["price"]);
          product.add(qn.docs[i]["name"]);
        } //  print(total);
        item = product.join(",");
      } else {}
    });
    print(item);
    return total.toString();
  }

  deletee() async {
    FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
        total = null;
      });
    });

    // .doc()
    // .delete()
    // .then((value) => {});
  }

  sendUserDataToDB() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    String? email = FirebaseAuth.instance.currentUser!.email;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("order");
    return _collectionRef
        .doc()
        .set({
          "item_name": item,
          "total": total,
          "email": email,
        })
        .then((value) => {
              // Fluttertoast.showToast(msg: "Thanks For Your Feedback"),
              // qrr = "Email : $email" +
              //     "\n" +
              //     "Item : $item" +
              //     "\nTotal : " +
              //     total.toString(),
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (_) => qr(qrr))),
              print(qrr),
              qr(),
            })
        .catchError((error) => print("something is wrong. $error"));
  }

  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('$total', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  //applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  //googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Priya'))
          .then((value) {});

      ///now finally display payment sheeet

      displayPaymentSheet();
      sendUserDataToDB();
      // deletee();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        total = null;
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));

        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));
        deletee();
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      //total = null;
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51M2UksKY4JfapoEkiIyNLT21IZLgRuvo6UJ1A6cvVKGyukBBGdbfJocTbW5zgtrNMH2DFRiqHchNerZ1cLCFRUCg001Dcrvef4',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    //return Amount();
    return calculatedAmout.toString();
  }
}
