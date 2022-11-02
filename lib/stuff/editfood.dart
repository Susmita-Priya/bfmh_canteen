// import 'package:bfmh_canteen/widgets/fetchProducts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:bfmh_canteen/widgets/fetchProducts.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class editfood extends StatefulWidget {
//   const editfood({super.key});

//   @override
//   State<editfood> createState() => _editfoodState();
// }

// class _editfoodState extends State<editfood> {
//   List _products = [];
//   var _firestoreInstance = FirebaseFirestore.instance;

//   getdata() async {
//     var result = await FirebaseFirestore.instance.collection('products').get();
//     return result;
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.orange,
//         title: const Text(
//           "Food list",
//         ),
//         // automaticallyImplyLeading: false,
//         //centerTitle: true,
//         // iconTheme: const IconThemeData(color: Colors.black),
//         elevation: 0,
//       ),
//       body: FutureBuilder(
//           future: getdata(),
//           //child: fetchData("users-cart-items"),
//           //customButton("Continue", () => sendUserDataToDB()),
//           child: Container(
//         child: Stack(
//           children: <Widget>[
//             StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('products')
//                   .doc()
//                   .snapshots(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text("Something is wrong"),
//                   );
//                 }
//                 return ListView.builder(
//                     itemCount:
//                         snapshot.data == null ? 0 : snapshot.data!.docs.length,
//                     itemBuilder: (_, index) {
//                       DocumentSnapshot _documentSnapshot =
//                           snapshot.data!.docs[index];

//                       return Card(
//                         elevation: 5,
//                         child: ListTile(
//                           leading: Image.network(
//                             _documentSnapshot['product-img'],
//                             fit: BoxFit.cover,
//                           ),
//                           title: Text(
//                             " ${_documentSnapshot['name']}",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                                 fontSize: 19.h),
//                           ),
//                           subtitle: Text(
//                             " ${_documentSnapshot['price']}tK",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.orange),
//                           ),
//                           trailing: GestureDetector(
//                             child: CircleAvatar(
//                               child: Icon(Icons.remove_circle),
//                             ),
//                             onTap: () {
//                               FirebaseFirestore.instance
//                                   .collection('products')
//                                   .doc(_documentSnapshot.id)
//                                   .delete();
//                             },
//                           ),
//                         ),
//                       );
//                     });
//               },
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }
