import 'package:bfmh_canteen/screen/bottom_nav_pages/update.dart';
import 'package:bfmh_canteen/screen/feedbacesee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  setDataToTextField(data) {
    //_nameController = data['name'];
    // _phoneController = data['age'];
    // _ageController = TextEditingController(text: data['age']);
    // _dobController = TextEditingController(text: data['dob']);
    // _genderController = TextEditingController(text: data['gender']);
    // return Column(
    //   children: [
    //     TextFormField(
    //       controller: _nameController =
    //           TextEditingController(text: data['name']),
    //     ),
    //     TextFormField(
    //       controller: _phoneController =
    //           TextEditingController(text: data['phone']),
    //     ),
    //     TextFormField(
    //       controller: _ageController = TextEditingController(text: data['age']),
    //     ),
    //     ElevatedButton(onPressed: () => updateData(), child: Text("Update"))
    //   ],
    // );
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 59, 59, 59),
              Color(0xFFFF9900),
            ], begin: Alignment.topCenter, end: Alignment.center)),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: _height / 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              data["img"],
                              //fit: BoxFit.cover,
                            ),
                            radius: _height / 9,
                          ),
                          SizedBox(
                            height: _height / 30,
                          ),
                          Text(data['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 22,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height / 2.5),
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _height / 2.6,
                        left: _width / 20,
                        right: _width / 20),
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
                                Icons.email,
                                "Email: " + data['email'],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              infoChild(
                                _width,
                                Icons.phone,
                                "Phone: " + data['phone'],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              infoChild(_width, Icons.calendar_month,
                                  "Date of birth: " + data['dob']),
                              const SizedBox(
                                height: 12,
                              ),
                              infoChild(_width, Icons.lock_clock,
                                  "Age: " + data['age']),
                              const SizedBox(
                                height: 12,
                              ),
                              infoChild(_width, Icons.woman,
                                  "Gender: " + data['gender']),
                              const SizedBox(
                                height: 15,
                              ),
                              // ElevatedButton(
                              //     onPressed: () => const update(),
                              //     child: Text("Update"))
                              Padding(
                                padding: EdgeInsets.only(top: _height / 50),
                                child: Container(
                                  width: _width / 3,
                                  height: _height / 20,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFF9800),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(_height / 40)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black87,
                                            blurRadius: 2.0,
                                            offset: Offset(0.0, 1.0))
                                      ]),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => update(data),
                                          ),
                                        );
                                      },
                                      child: Text('Update',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ),
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
              Text(data)
            ],
          ),
          onTap: () {
            print('Info Object selected');
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      //   child: Padding(
      // padding: const EdgeInsets.all(1),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users-form-data")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return setDataToTextField(data);
        },
      ),
    ));
  }
}
