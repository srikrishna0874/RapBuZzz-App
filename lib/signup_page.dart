import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/utils/firebase_service.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/swiping_page.dart';
import 'package:text_divider/text_divider.dart';
import 'home.dart';
import 'main.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({Key? key}) : super(key: key);

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phnnumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isVisiblePassword = false;

  final collectionReference =
      FirebaseFirestore.instance.collection("UsersData");

  Profile profile = Profile();
  bool _isLoading = false;
  List<String> img_all = [];
  List<String> img_names = [];
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("UsersData");

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(200, 40, 148, 1),
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Container(
                width: screenWidth * 0.08,
                height: screenHeight * 0.05,
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(200, 40, 148, 1),
                  Color.fromRGBO(149, 70, 197, 1),
                  Color.fromRGBO(93, 97, 249, 1),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                      left: screenWidth * 0.025, right: screenWidth * 0.025),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/login_logo.png",
                        fit: BoxFit.fitWidth,
                        width: screenWidth * 0.8,
                        height: screenWidth * 0.8,
                      ),
                      TextField(
                        obscureText: false,
                        cursorColor: Colors.white.withOpacity(0.9),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400),
                        controller: _usernameController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 3,
                                    style: BorderStyle.none)),
                            labelText: "Enter Username",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Colors.white70,
                            )),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
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
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 3)),
                            labelText: "Enter Email",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.white70,
                            )),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        obscureText: false,
                        cursorColor: Colors.white.withOpacity(0.9),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400),
                        controller: _phnnumberController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 3)),
                            labelText: "Enter Phone Number",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: Colors.white70,
                            )),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        obscureText: isVisiblePassword,
                        cursorColor: Colors.white.withOpacity(0.9),
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
                                        isVisiblePassword = !isVisiblePassword;
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
                                        isVisiblePassword = !isVisiblePassword;
                                      });
                                    },
                                  ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 3)),
                            labelText: "Enter Password",
                            labelStyle:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Colors.white70,
                            )),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
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
                                .createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) async {
                              if (value != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                              print("Created New Account Successfully!!!");
                              print(value.runtimeType);
                              print(value);

                              FireBaseServices().createUser(
                                _usernameController.text,
                                _emailController.text,
                                _phnnumberController.text,
                                _passwordController.text,
                                value,
                              );
                              setState(() {
                                profile.updateDetails(
                                  _usernameController.text,
                                  _emailController.text,
                                  _phnnumberController.text,
                                  _passwordController.text,
                                  "",
                                  [],
                                  [],
                                  [],
                                );
                              });

                              //Getting the details of other users so as to display in tinder page...

                              DocumentSnapshot documentSnapshot =
                                  await _db.doc(_auth.currentUser?.uid).get();
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
                                      (!liked_by_me_cur.contains(img_name))) {
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

                              //Done getting the data of other users so as to display in the tinder page...

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyHomePage(profile)));
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextDivider.horizontal(
                        text: const Text(
                          "OR",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.white,
                        thickness: 3,
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth,
                          height: screenHeight * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
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
                        height: screenHeight*0.2,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
