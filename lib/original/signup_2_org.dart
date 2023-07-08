import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/utils/profile_details.dart';

import 'utils/firebase_service.dart';
import '../home.dart';
import 'input_image_org.dart';

class MySignUp2 extends StatefulWidget {
  final String email;
  MySignUp2(@required this.email);

  @override
  State<MySignUp2> createState() => _MySignUp2State();
}

class _MySignUp2State extends State<MySignUp2> {
  String _text = "RapBuZzz";
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;

  bool _isLoading = false;
  Profile profile = Profile();

  List<String> img_all = [];
  List<String> img_names = [];
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("UsersData");

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.01,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.08),
                  width: screenWidth,
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 9, 88, 1),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: screenHeight * 0.004,
                        bottom: screenHeight * 0.004),
                    width: screenWidth,
                    height: screenHeight * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.25,
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.1,
                              top: screenHeight * 0.03,
                              right: screenWidth * 0.01),
                          child: Image.asset(
                            "assets/images/app_logo.png",
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              for (int i = 0; i < _text.length; i++)
                                TextSpan(
                                  text: _text[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: _text[i] == "R" || _text[i] == "B"
                                        ? 40
                                        : i == 5
                                            ? 35
                                            : i == 6
                                                ? 30
                                                : _text[i] != "z"
                                                    ? 35
                                                    : 20,
                                    color: i < 3
                                        ? Colors.white
                                        : Color.fromRGBO(0, 72, 255, 1),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Start your RAP Journey with us.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.07,
                    right: screenWidth * 0.07,
                  ),
                  padding: EdgeInsets.only(top: screenHeight * 0.04),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Row(
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: screenWidth / 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        controller: _usernameController,
                        cursorHeight: 25,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Name",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.3)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          fillColor: Color.fromRGBO(25, 25, 25, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: screenWidth / 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: _phoneNumberController,
                        cursorHeight: 25,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Phone Number",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.3)),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Colors.white,
                          ),
                          fillColor: Color.fromRGBO(25, 25, 25, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Password",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: screenWidth / 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: _isObscuredPassword,
                        cursorHeight: 25,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Password",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.3)),
                          suffixIcon: _isObscuredPassword
                              ? IconButton(
                                  icon: Icon(Icons.visibility),
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _isObscuredPassword =
                                          !_isObscuredPassword;
                                    });
                                  },
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscuredPassword =
                                          !_isObscuredPassword;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          fillColor: Color.fromRGBO(25, 25, 25, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "Confirm Password",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.8),
                              fontSize: screenWidth / 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _isObscuredConfirmPassword,
                        cursorHeight: 25,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Password again",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.3)),
                          suffixIcon: _isObscuredConfirmPassword
                              ? IconButton(
                                  icon: Icon(Icons.visibility),
                                  color: Colors.white,
                                  onPressed: () {
                                    setState(() {
                                      _isObscuredConfirmPassword =
                                          !_isObscuredConfirmPassword;
                                    });
                                  },
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscuredConfirmPassword =
                                          !_isObscuredConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          fillColor: Color.fromRGBO(25, 25, 25, 1),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: widget.email,
                                      password: _passwordController.text)
                                  .then((value) async {
                                if (value != null) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                                print(
                                    "Created New Account Successfully!!! with email=${widget.email} and password=${_passwordController.text}");
                                print(value.runtimeType);
                                print(value);

                                FireBaseServices().createUser(
                                  _usernameController.text,
                                  widget.email,
                                  _phoneNumberController.text,
                                  _passwordController.text,
                                  value,
                                );
                                setState(() {
                                  profile.updateDetails(
                                    _usernameController.text,
                                    widget.email,
                                    _phoneNumberController.text,
                                    _passwordController.text,
                                    "",
                                    [],
                                    [],
                                    [],
                                  );
                                });

                                //Getting the details of other users so as to display in tinder page...

                                List<Map<String, String>> other_info = [];

                                QuerySnapshot snapshot = await _db.get();
                                snapshot.docs.forEach((doc) {
                                  String url = doc.get("profile_pic");
                                  String name = doc.get("Name");
                                  String img_name = doc.get("Email");

                                  if (img_name != profile.email) {
                                    other_info.add({
                                      "Name": name,
                                      "Email": img_name,
                                      "URL": url,
                                    });
                                    print("${img_name} added");
                                  }
                                });

                                profile.other = img_all;
                                profile.other_names = img_names;
                                profile.other_user_info = other_info;

                                print(profile.other_names);
                                print(
                                    "Length of other names is ${profile.other_names.length}");
                                setState(() {
                                  _isLoading = false;
                                });

                                //Done getting the data of other users so as to display in the tinder page...

                                print(profile.email);
                                print("Sign up done and going to image input");
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyInputProfileImagePage(profile)));
                              }).onError((error, stackTrace) {
                                print("Error ${error.toString()}");
                              });
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: screenWidth / 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(screenWidth * 0.4, screenHeight * 0.06),
                              backgroundColor: Color.fromRGBO(1, 73, 255, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
