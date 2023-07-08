import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _text = "RapBuZzz";

  String _errorMessage = "";

  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  String _validate(String email) {
    if (email.isEmpty) {
      return "Email shouldn't be empty!!!";
    } else if (!email.contains("@")) {
      return "Invalid Email";
    }
    return "";
  }

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.25,
                          margin: EdgeInsets.only(
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
                          Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 12,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.04,
                      ),
                      Row(
                        children: [
                          Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      TextField(
                        controller: _emailController,
                        cursorHeight: 25,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your Email",
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.3)),
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Container(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.05,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(1, 73, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _errorMessage = _validate(_emailController.text);
                              if (_errorMessage.isEmpty) {
                                _auth
                                    .sendPasswordResetEmail(
                                        email: _emailController.text.toString())
                                    .then((value) {
                                  setState(() {
                                    _errorMessage =
                                        "We have sent you email to reset your password...Please Check!!! ";
                                  });
                                }).onError((error, stackTrace) {
                                  print(
                                      "Error in forgot pasword field: ${error}");
                                });
                              }
                            });
                          },
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth / 22,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      _errorMessage != ""
                          ? Container(
                              width: screenWidth,
                              height: screenHeight * 0.08,
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.04,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text.rich(
                                  TextSpan(children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                    ),
                                    TextSpan(
                                        text:
                                            "We have sent you a email to reset your password. Please verify!!!",
                                        style: TextStyle(
                                          height: screenHeight*0.0016,
                                          fontSize: screenWidth / 28,
                                          fontWeight: FontWeight.bold,
                                        ),)
                                  ]),
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
