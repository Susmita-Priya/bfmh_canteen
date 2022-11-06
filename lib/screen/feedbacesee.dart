import 'package:bfmh_canteen/widgets/fetchfeedback.dart';
import 'package:flutter/material.dart';

class FeedBackSee extends StatefulWidget {
  const FeedBackSee({super.key});

  @override
  State<FeedBackSee> createState() => _FeedBackSeeState();
}

class _FeedBackSeeState extends State<FeedBackSee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Feedbacks",
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
