import 'package:bfmh_canteen/constant/Appcolours.dart';
import 'package:bfmh_canteen/screen/product_details_screen.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                aspectRatio: 0.85,
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 1),
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetails(_products[index]))),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              AspectRatio(
                                  aspectRatio: 1.5,
                                  child: Container(
                                      color: Colors.yellow,
                                      child: Image.network(
                                        _products[index]["product-img"],
                                        fit: BoxFit.cover,
                                      ))),
                              Text(
                                "${_products[index]["product-name"]}",
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "${_products[index]["product-price"].toString()} TK",
                                style: TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  //fontSize: 18.0
                                ),
                              ),
                              Text(
                                "${_products[index]["product-available"]}",
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontSize: 10.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              // //2nd row
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Lunch',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Colors.orange,
              //             fontSize: 18.0),
              //       ),
              //       // GestureDetector(
              //       //   // onTap: () {
              //       //   //   Navigator.of(context).push(MaterialPageRoute(
              //       //   //       builder: (context) => Search(
              //       //   //             search: productProvider.getHerbsProductList,
              //       //   //           )));
              //       //   // },
              //       //   child: Text(
              //       //     'all ',
              //       //     style: TextStyle(color: Colors.grey),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),

              // AspectRatio(
              //   aspectRatio: 2,
              //   child: GridView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: _products.length,
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 1, childAspectRatio: 1),
              //       itemBuilder: (_, index) {
              //         return GestureDetector(
              //           onTap: () => Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (_) =>
              //                       ProductDetails(_products[index]))),
              //           child: Card(
              //             elevation: 3,
              //             child: Column(
              //               children: [
              //                 AspectRatio(
              //                     aspectRatio: 1.5,
              //                     child: Container(
              //                         color: Colors.yellow,
              //                         child: Image.network(
              //                           _products[index]["product-img"][0],
              //                           fit: BoxFit.cover,
              //                         ))),
              //                 Text(
              //                   "${_products[index]["product-name"]}",
              //                   style: TextStyle(
              //                       //fontWeight: FontWeight.bold,
              //                       color: Colors.black,
              //                       fontSize: 18.0),
              //                 ),
              //                 Text(
              //                   "${_products[index]["product-price"].toString()}TK",
              //                   style: TextStyle(
              //                     //fontWeight: FontWeight.bold,
              //                     color: Colors.orange,
              //                     //fontSize: 18.0
              //                   ),
              //                 ),
              //                 Text(
              //                   "${_products[index]["product-available"]}",
              //                   style: TextStyle(
              //                       //fontWeight: FontWeight.bold,
              //                       color: Colors.green,
              //                       fontSize: 10.0),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       }),
              // ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Dinner',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: Colors.orange,
              //             fontSize: 18.0),
              //       ),
              //       // GestureDetector(
              //       //   // onTap: () {
              //       //   //   Navigator.of(context).push(MaterialPageRoute(
              //       //   //       builder: (context) => Search(
              //       //   //             search: productProvider.getHerbsProductList,
              //       //   //           )));
              //       //   // },
              //       //   child: Text(
              //       //     'all ',
              //       //     style: TextStyle(color: Colors.grey),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),

              // AspectRatio(
              //   aspectRatio: 2,
              //   child: GridView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: _products.length,
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //           crossAxisCount: 1, childAspectRatio: 1),
              //       itemBuilder: (_, index) {
              //         return GestureDetector(
              //           onTap: () => Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (_) =>
              //                       ProductDetails(_products[index]))),
              //           child: Card(
              //             elevation: 3,
              //             child: Column(
              //               children: [
              //                 AspectRatio(
              //                     aspectRatio: 1.5,
              //                     child: Container(
              //                         color: Colors.yellow,
              //                         child: Image.network(
              //                           _products[index]["product-img"][0],
              //                           fit: BoxFit.cover,
              //                         ))),
              //                 Text(
              //                   "${_products[index]["product-name"]}",
              //                   style: TextStyle(
              //                       //fontWeight: FontWeight.bold,
              //                       color: Colors.black,
              //                       fontSize: 18.0),
              //                 ),
              //                 Text(
              //                   "${_products[index]["product-price"].toString()} TK",
              //                   style: TextStyle(
              //                     //fontWeight: FontWeight.bold,
              //                     color: Colors.orange,
              //                     //fontSize: 18.0
              //                   ),
              //                 ),
              //                 Text(
              //                   "${_products[index]["product-available"]}",
              //                   style: TextStyle(
              //                       //fontWeight: FontWeight.bold,
              //                       color: Colors.green,
              //                       fontSize: 10.0),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         );
              //       }),
              // ),
            ],
          ),
        ),
      )),
    );
  }
}
