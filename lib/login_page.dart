import 'dart:io' as prefix;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intern/original/utils/firebase_service.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/signup_page.dart';
import 'package:intern/original/swiping_page.dart';
import 'package:text_divider/text_divider.dart';
import 'home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'main.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final _auth = FirebaseAuth.instance;
  Profile profile = Profile();
  bool isVisiblePassword = false;
  bool _isLoading = false;

  final _db = FirebaseFirestore.instance.collection("UsersData");

  List<String> img_all = [];
  List<String> img_names = [];

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phnnumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: _isLoading
            ? Center(
                child: Container(
                  width: screenWidth * 0.08,
                  height: screenHeight * 0.05,
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromRGBO(200, 40, 148, 1),
                  Color.fromRGBO(149, 70, 197, 1),
                  Color.fromRGBO(93, 97, 249, 1)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: SingleChildScrollView(
                  child: Container(
                    width: screenWidth,
                    height: screenHeight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20,
                          top: screenHeight * 0.05,
                          right: 20,
                          bottom: 0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/login_logo.png",
                            fit: BoxFit.fitWidth,
                            width: screenWidth * 0.8,
                            height: screenWidth * 0.8,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          //Username field
                          TextField(
                            obscureText: false,
                            cursorColor: Colors.white.withOpacity(0.9),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400),
                            controller: _emailController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.3),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 3)),
                                labelText: "Enter Username",
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white70,
                                )),
                          ),

                          SizedBox(
                            height: screenHeight * 0.02,
                          ),

                          //Password field
                          TextField(
                            obscureText: isVisiblePassword,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w400),
                            controller: _passwordController,
                            decoration: InputDecoration(
                                suffixIcon: isVisiblePassword
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.visibility,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isVisiblePassword =
                                                !isVisiblePassword;
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(
                                          Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            isVisiblePassword =
                                                !isVisiblePassword;
                                          });
                                        },
                                      ),
                                fillColor: Colors.white.withOpacity(0.3),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                      width: 0,
                                      style: BorderStyle.none,
                                    )),
                                labelText: "Enter Password",
                                labelStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.9)),
                                prefixIcon: const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Colors.white70,
                                )),
                          ),

                          SizedBox(
                            height: screenHeight * 0.02,
                          ),

                          //Login Button field
                          Container(
                            width: screenWidth,
                            height: screenHeight * 0.06,
                            margin: const EdgeInsets.only(
                                left: 0, top: 10, right: 0, bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: Colors.white,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                )
                                    .then((value) async {
                                  //Getting current user details

                                  var data = await _db
                                      .doc(_auth.currentUser?.uid)
                                      .get();
                                  profile.updateDetails(
                                    data['Name'],
                                    data['Email'],
                                    data['Phone Number'],
                                    data['Password'],
                                    data['profile_pic'],
                                    data["Liked Me"],
                                    data["Liked By Me"],
                                    data["Mutual Friends"],
                                  );

                                  //Done getting current user details

                                  DocumentSnapshot documentSnapshot = await _db
                                      .doc(_auth.currentUser?.uid)
                                      .get();
                                  List<dynamic> mutual_cur =
                                      documentSnapshot.get("Mutual Friends");
                                  List<dynamic> liked_by_me_cur =
                                      documentSnapshot.get("Liked By Me");
                                  print("Liked By Me: ${liked_by_me_cur}");

                                  QuerySnapshot snapshot = await _db.get();
                                  snapshot.docs.forEach((doc) {
                                    String url = doc.get("profile_pic");
                                    String img_name = doc.get("Email");

                                    if (img_name != profile.email) {
                                      if ((!mutual_cur.contains(img_name)) &&
                                          (!liked_by_me_cur
                                              .contains(img_name))) {
                                        img_all.add(url);
                                        img_names.add(img_name);
                                        print("${img_name} added1");
                                      }
                                    }
                                  });

                                  profile.other = img_all;
                                  profile.other_names = img_names;

                                  print(profile.other_names);
                                  print(
                                      "Length of other names is ${profile.other_names.length}");
                                  setState(() {
                                    _isLoading = false;
                                  });



                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(profile)));
                                }).onError((error, stackTrace) {
                                  print(
                                      "Sorry! Wrong details given!!!${error}");
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: const Text(
                                "LOG IN",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: screenHeight * 0.02,
                          ),

                          TextDivider.horizontal(
                              text: const Text(
                                "OR",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.white,
                              thickness: 3),

                          Container(
                            width: screenWidth,
                            height: screenHeight * 0.06,
                            margin: const EdgeInsets.only(
                                left: 0, top: 10, right: 0, bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: Colors.white,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                await FireBaseServices().signInWithGoogle();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyHomePage(profile)));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.01,
                                  ),
                                  Image.asset(
                                    "assets/images/google_logo.png",
                                    width: 100,
                                    height: 40,
                                  ),
                                  const Text(
                                    "Sign in with Google",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 15),
                              ),
                              SizedBox(
                                width: screenWidth * 0.015,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _navigateToSignUpPage(context);
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
  }
}

void _navigateToSignUpPage(BuildContext context) {
  //Navigator.push(context, MaterialPageRoute(builder: (context) => MySignUp()));
}

void _navigateToHomePage(BuildContext context) {}
