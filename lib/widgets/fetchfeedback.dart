import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget fetchfeedback(String collectionName) {
  String? email1 = FirebaseAuth.instance.currentUser!.email;
  return Container(
    child: Stack(
      children: <Widget>[
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .where("email", isEqualTo: email1)
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
                        " ${_documentSnapshot['feedback']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      trailing: GestureDetector(
                        child: CircleAvatar(
                          child: Icon(Icons.delete,
                              color: Color.fromARGB(255, 231, 5, 5)),
                        ),
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection(collectionName)
                              .doc(_documentSnapshot.id)
                              .delete()
                              .then((value) => {
                                    Fluttertoast.showToast(
                                        msg: "Successfully Deleted"),
                                  });
                        },
                      ),
                    ),
                  );
                });
          },
        ),
      ],
    ),
  );
}
