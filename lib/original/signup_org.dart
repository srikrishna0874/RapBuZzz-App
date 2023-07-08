import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intern/original/login_org.dart';
import 'package:intern/original/utils/profile_details.dart';

import 'otp_verify_org.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({Key? key}) : super(key: key);

  @override
  State<MySignUp> createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  String _text = "RapBuZzz";

  Profile profile=Profile();

  EmailOTP myemailAuth = EmailOTP();

  bool _validate(String email) {
    if (email.isEmpty) {
      return false;
    }
    if (!email.contains("@")) {
      return false;
    }
    return true;
  }

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
                                    left: screenWidth*0.1,
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
                                          fontSize:
                                              _text[i] == "R" || _text[i] == "B"
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
                              height: screenHeight * 0.04,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.9),
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
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3)),
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
                              height: screenHeight * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      minimumSize: Size(screenWidth * 0.3,
                                          screenHeight * 0.06),
                                      backgroundColor:
                                          Color.fromRGBO(1, 73, 255, 1)),
                                  onPressed: () async {
                                    if (_validate(_emailController.text)) {
                                      myemailAuth.setConfig(
                                          appEmail:
                                              "kskvsubbarao2019@gmail.com",
                                          appName: "RapBuZzz",
                                          userEmail: _emailController.text,
                                          otpLength: 5,
                                          otpType: OTPType.digitsOnly);
                                      if (await myemailAuth.sendOTP() == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text("OTP has been sent"),
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyOtp(
                                                  _emailController.text,
                                                  myemailAuth)),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text("OTP send failed"),
                                          ),
                                        );

                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Enter Vaild Email"),
                                        ),
                                      );
                                      setState(() {
                                        profile.errorMessage="Enter valid email";
                                      });
                                    }
                                  },
                                  child: Text(
                                    "SEND OTP",
                                    style: TextStyle(
                                        fontSize: screenWidth / 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.01,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyLogin()),
                              );
                            },
                            child: Text(
                              "Log in",
                              style: TextStyle(
                                  color: Color.fromRGBO(18, 88, 153, 1),
                                  fontSize: screenWidth / 20,
                                  fontWeight: FontWeight.w900),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight*0.08,
                      ),
                      profile.errorMessage != ""
                          ? Column(
                        children: [
                          Container(
                            width: screenWidth*0.8,
                            height: screenHeight * 0.07,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Color.fromRGBO(202, 40, 36, 1),
                                ),
                                SizedBox(
                                  width: screenWidth*0.01,
                                ),
                                AutoSizeText(
                                  profile.errorMessage,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth / 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          )
                        ],
                      )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
