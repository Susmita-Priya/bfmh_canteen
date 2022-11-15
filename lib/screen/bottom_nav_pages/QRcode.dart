import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class qr extends StatefulWidget {
  qr({super.key});

  @override
  State<qr> createState() => _qrState();
}

class _qrState extends State<qr> {
  double totall = 0;
  String? itemm;
  List<String> productt = [];
  String? qrrr;

  getinfo() async {
    String? email1 = FirebaseAuth.instance.currentUser!.email;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("order")
        .where("email", isEqualTo: email1)
        .get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        totall = (totall + qn.docs[i]["total"]);
        productt.add(qn.docs[i]["item_name"]);
      }
      print(totall.toString());
      itemm = productt.join(",");
    });
    qrrr = "Email : $email1" +
        "\n" +
        "Item : $itemm" +
        "\nTotal : " +
        totall.toString();
    print(qrrr);
  }

  @override
  void initState() {
    getinfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "\nQR Code\n",
          style: TextStyle(color: Colors.orange),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50),
        child: Container(
            child: Column(
          children: [
            Center(
              child: QrImage(
                data: qrrr.toString(),
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            Text(
              "Scan your QR code for taking food",
              style: TextStyle(color: Colors.grey),
            )
          ],
        )),
      ),
    ));
  }
}
