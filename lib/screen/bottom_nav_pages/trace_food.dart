import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class tracef extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  tracef(this.documentSnapshot);
  @override
  State<tracef> createState() => _traceState();
}

class _traceState extends State<tracef> {
  @override
  Widget build(BuildContext context) {
    String? email1 = FirebaseAuth.instance.currentUser!.email;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    String? qrrr;

    qrrr = "Email : $email1" +
        "\n" +
        "Item : " +
        widget.documentSnapshot['item'].toString() +
        "\nTotal :" +
        widget.documentSnapshot['total'].toString() +
        "\nStatus :" +
        widget.documentSnapshot['status'].toString();
    print(qrrr);
    return Container(
      child: Stack(
        children: <Widget>[
          Scaffold(
            //backgroundColor: Colors.white30,
            body: Container(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: _height / 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Trace Order",
                            style: TextStyle(
                                fontSize: 25.sp,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 40, top: 10, right: 30, bottom: 5),
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
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 50,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: _height / 80,
                          ),
                          // Text(data['name'],
                          //     style: const TextStyle(
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w500,
                          //       fontSize: 22,
                          //     )),
                          Text(widget.documentSnapshot['email'],
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height / 2.4),
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: _height / 2.3,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 2.0,
                                    offset: Offset(0.0, 2.0))
                              ]),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: _height / 20),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 0,
                              ),
                              infoChild(
                                _width,
                                Icons.fastfood,
                                "Items :  " + widget.documentSnapshot['item'],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              infoChild(
                                _width,
                                Icons.price_change,
                                "Total Price : " +
                                    widget.documentSnapshot['total'],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              infoChild(
                                  _width,
                                  Icons.restaurant,
                                  "Status : " +
                                      widget.documentSnapshot['status']),
                              const SizedBox(
                                height: 12,
                              ),

                              // ElevatedButton(
                              //     onPressed: () => const update(),
                              //     child: Text("Update"))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoChild(double width, IconData icon, data) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          child: Row(
            children: <Widget>[
              SizedBox(
                width: width / 10,
              ),
              Icon(
                icon,
                color: Colors.orange,
                size: 36.0,
              ),
              SizedBox(
                width: width / 20,
              ),
              Text(data,
                  style: TextStyle(
                    fontSize: 15.sp,
                    //  color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );
}
