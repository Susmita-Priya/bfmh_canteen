import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/stuff/updatefood.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class productdetails extends StatefulWidget {
  var _product;
  productdetails(this._product);

  @override
  State<productdetails> createState() => _productdetailsState();
}

class _productdetailsState extends State<productdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Appcolours.Orange,
            child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
          ),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                  width: 450,
                  height: 450,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Image.network(
                          widget._product["product-img"],
                          fit: BoxFit.cover,
                        )),
                      ],
                    ),
                  )),
              // child: widget._product['product-img'],
              //         Padding(
              //               padding: const EdgeInsets.only(left: 1, right: 1),
              //               child: Container(
              //                 decoration: BoxDecoration(
              //                     image: DecorationImage(
              //                         image: NetworkImage(item),
              //                         fit: BoxFit.fitWidth)),
              //               ),
              //             ))
              //     .toList(),
              // options: CarouselOptions(
              //     autoPlay: true,
              //     enlargeCenterPage: true,
              //     viewportFraction: 0.8,
              //     enlargeStrategy: CenterPageEnlargeStrategy.height,
              //     onPageChanged: (val, carouselPageChangedReason) {
              //       setState(() {
              //         _dotPosition = val;
              //       });
              //     })),
            ),
            SizedBox(
              height: 10.h,
            ),
            // DotsIndicator(
            //   dotsCount: widget._product['product-img'].length == 0
            //       ? 1
            //       : widget._product['product-img'].length,
            //   position: _dotPosition.toDouble(),
            //   decorator: DotsDecorator(
            //     activeColor: Color(0xFFFF9800),
            //     color: Color(0xFFFF9800).withOpacity(0.5),
            //     spacing: EdgeInsets.all(2),
            //     activeSize: Size(8, 8),
            //     size: Size(6, 6),
            //   ),
            // ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget._product['product-name'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget._product['product-description'],
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget._product['product-available'],
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 18.0),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget._product['product-price'].toString()} TK",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
            ),
            Divider(),
            SizedBox(
              height: 15.h,
            ),
            // SizedBox(
            //   width: 1.sw,
            //   height: 56.h,
            //   child: ElevatedButton(
            // onPressed: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => updatefood(
            //                 // name: widget._product['product-name'],
            //                 // des: widget._product['product-description'],
            //                 // avail: widget._product['product-available'],
            //                 // price: widget._product['product-price'],

            //               )));
            // },
            //     child: Text(
            //       "Update Details",
            //       style: TextStyle(color: Colors.white, fontSize: 18.sp),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       primary: Appcolours.Orange,
            //       elevation: 3,
            //     ),
            //   ),
            // ),
          ],
        ),
      )),
    );
  }
}
