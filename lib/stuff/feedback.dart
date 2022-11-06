import 'package:bfmh_canteen/widgets/fetchfeedback.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  Widget fetchfeedback(String collectionName) {
    String? email1 = FirebaseAuth.instance.currentUser!.email;
    return Container(
      child: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something is wrong"),
                );
              }
              return ListView.builder(
                  itemCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    DocumentSnapshot _documentSnapshot =
                        snapshot.data!.docs[index];

                    return Card(
                      elevation: 5,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage("assets/profile.png"),
                        ),
                        //fit: BoxFit.cover,

                        title: Text(
                          " ${_documentSnapshot['item_name']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 19.h),
                        ),
                        subtitle: Text(
                          " ${_documentSnapshot['feedback']}"
                          "\n (${_documentSnapshot['email']})",
                          style: TextStyle(color: Colors.black),
                        ),
                        // trailing: GestureDetector(
                        //   child: CircleAvatar(
                        //     child: Icon(Icons.delete,
                        //         color: Color.fromARGB(255, 231, 5, 5)),
                        //   ),
                        //   onTap: () {
                        //     FirebaseFirestore.instance
                        //         .collection(collectionName)
                        //         .doc(FirebaseAuth.instance.currentUser!.email)
                        //         .collection("items")
                        //         .doc(_documentSnapshot.id)
                        //         .delete();
                        //   },
                        // ),
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Feedbacks",
          style: TextStyle(
            //fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
        //automaticallyImplyLeading: false,
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
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
        child: fetchfeedback("feedback"),
        //customButton("Continue", () => sendUserDataToDB()),
      ),
    );
  }
}
