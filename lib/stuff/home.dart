import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/screen/product_details_screen.dart';
import 'package:bfmh_canteen/stuff/Mydrawer.dart';
import 'package:bfmh_canteen/stuff/productdetails.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<String> _carouselImages = [];
  var _dotPosition = 0;
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-available": qn.docs[i]["product-available"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    fetchCarouselImages();
    //fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: MyDrawer()),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: Text(
          "BFMH",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
          child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 2.5,
                child: CarouselSlider(
                    items: _carouselImages
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(left: 1, right: 1),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(item),
                                        fit: BoxFit.fitWidth)),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.8,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (val, carouselPageChangedReason) {
                          setState(() {
                            _dotPosition = val;
                          });
                        })),
              ),
              SizedBox(
                height: 10.h,
              ),
              DotsIndicator(
                dotsCount:
                    _carouselImages.length == 0 ? 1 : _carouselImages.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: Appcolours.Orange,
                  color: Appcolours.Orange.withOpacity(0.5),
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(8, 8),
                  size: Size(6, 6),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              //1st row
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Food Items',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 18.0),
                    ),
                    // GestureDetector(
                    //   // onTap: () {
                    //   //   Navigator.of(context).push(MaterialPageRoute(
                    //   //       builder: (context) => Search(
                    //   //             search: productProvider.getHerbsProductList,
                    //   //           )));
                    //   // },
                    //   child: Text(
                    //     'all ',
                    //     style: TextStyle(color: Colors.grey),
                    //   ),
                    // ),
                  ],
                ),
              ),

              AspectRatio(
                aspectRatio: 0.8,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong"),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading"),
                      );
                    }

                    return GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1),
                        itemCount: snapshot.data == null
                            ? 0
                            : snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          DocumentSnapshot _documentSnapshot =
                              snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        productdetails(_documentSnapshot))),
                            child: Card(
                              // elevation: 3,
                              child: Column(
                                children: [
                                  AspectRatio(
                                      aspectRatio: 1.5,
                                      child: Container(
                                          color: Colors.yellow,
                                          child: Image.network(
                                            _documentSnapshot["product-img"],
                                            fit: BoxFit.cover,
                                          ))),
                                  Text(
                                    "${_documentSnapshot["product-name"]}",
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    "${_documentSnapshot["product-price"].toString()} TK",
                                    style: TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      //fontSize: 18.0
                                    ),
                                  ),
                                  Text(
                                    "${_documentSnapshot["product-available"]}",
                                    style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 10.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
