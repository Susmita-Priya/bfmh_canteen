import 'package:bfmh_canteen/screen/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "You can search items",
                ),
                onChanged: (val) {
                  setState(() {
                    inputText = val;
                    print(inputText);
                  });
                },
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("product-name",
                            isGreaterThanOrEqualTo: inputText)
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

                      return ListView.builder(
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
                                            ProductDetails(_documentSnapshot))),
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title:
                                        Text(_documentSnapshot['product-name']),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _documentSnapshot['product-img']),
                                    ),
                                    // leading: Image.network(
                                    //   _documentSnapshot['product-img'],
                                    //   fit: BoxFit.contain

                                    // ),
                                  ),
                                ));
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
