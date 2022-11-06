// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:earner_app/Services/global_variables.dart';
// import 'package:earner_app/pages/Fragments_seller/login_page.dart';
// import 'package:earner_app/pages/login_page.dart';
// import 'package:earner_app/widgets/drawer.dart';
import 'package:bfmh_canteen/screen/bottom_nav_pages/MDrawer.dart';
import 'package:bfmh_canteen/stuff/Mydrawer.dart';
import 'package:flutter/material.dart';

//import 'package:nb_utils/nb_utils.dart';
//import 'package:gradient_app_bar/gradient_app_bar.dart';
class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 30));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BFMH Canteen",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            // child: CircleAvatar(
            //   backgroundImage: AssetImage("assets/Logo.jpeg"),
            // ),
          ),
        ],
      ),
      drawer: const Drawer(
        child: MyDrawer(),
      ),
      body: Stack(
        children: [
          // CachedNetworkImage(
          //   imageUrl: aboutusImage,
          //   // placeholder: ((context, url) => Image.asset(
          //   //       'assets/Images/wallpaper.jpg',
          //   //       fit: BoxFit.fill,
          //   //     )),
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          //   width: double.infinity,
          //   height: double.infinity,
          //   fit: BoxFit.cover,
          //   alignment: FractionalOffset(_animation.value, 0),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 100, top: 10, right: 30, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/Logo.jpeg'),
                  radius: MediaQuery.of(context).size.height / 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                // Text(data['name'],
                //     style: const TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w500,
                //       fontSize: 22,
                //     )),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(8)),
          Center(
            child: Container(
              margin: EdgeInsets.all(15),
              child: RichText(
                text: const TextSpan(
                  text: '\n \n \n \nAbout Our App',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFFFD8803)),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '\n  \n Our hall Bangmata Fazilatunessa Mujib Hall of Jagannath University ,there have canteen system food buying.When we go and purches food there are too many crowd and it wastes our important time.It creates awkward situation.\n \n This BFMH Apss releases us from this problem.We can save our time. We can purches food in this apps.And we can take our food when it prepared and get notifications.And donot need to stand in queue for taking food.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF080808))),
                    TextSpan(text: "\n \nContact with us"),
                    TextSpan(
                        text:
                            "\n \n Susmita Saha(Priya) \n Email : b180305047@cse.jnu.ac.bd \n \n Laboni akter \n Email: labonicsejnu@gmail.com",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF080808))),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: " © BFMH Canteen 2022",
            icon: SizedBox(),
          ),
          BottomNavigationBarItem(
            label: " © Susmita Saha(Priya) ",
            icon: SizedBox(),
          )
        ],
      ),
    );
  }
}
