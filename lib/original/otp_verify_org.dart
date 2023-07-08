import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intern/home.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/signup_2_org.dart';

class MyOtp extends StatefulWidget {
  final String email;
  EmailOTP myemailAuth;
  MyOtp(this.email, this.myemailAuth);

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  final TextEditingController otpController5 = TextEditingController();
  Profile profile = Profile();

  String _errorMessage = "";

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    Color _color = Color.fromRGBO(31, 31, 31, 1);
    int _curIndex = 0;
    List<TextEditingController> _otpcontroller =
        List.generate(5, (index) => TextEditingController());
    List<FocusNode> focusNodeList = List.generate(5, (index) => FocusNode());

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
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.08),
                  width: screenWidth,
                  height: screenHeight * 0.1,
                  child: Center(
                    child: Text(
                      "Enter OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth / 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: screenWidth / 20,
                      color: Color.fromRGBO(1, 169, 48, 1),
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    Text(
                      "We have sent the OTP to your Email ID",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    widget.myemailAuth.setConfig(
                      appEmail: "kskvsubbarao2019@gmail.com",
                      appName: "RapBuZzz",
                      userEmail: widget.email,
                      otpLength: 5,
                      otpType: OTPType.digitsOnly,
                    );
                    if (await widget.myemailAuth.sendOTP() == true) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        SnackBar(
                          content: Text("OTP has been re-sent"),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "RESEND OTP ?",
                    style: TextStyle(
                      color: Color.fromRGBO(10, 121, 48, 1),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: Color.fromRGBO(10, 121, 48, 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: otpController1,
                        onChanged: (value) {
                          if (FocusScope.of(context).isFirstFocus)
                            _color = Colors.white;
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          }
                          setState(() {
                            _color = Colors.white;
                          });
                        },
                        decoration: InputDecoration(
                          fillColor: _color,
                          filled: true,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: otpController2,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.length == 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(31, 31, 31, 1),
                          filled: true,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: otpController3,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.length == 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(31, 31, 31, 1),
                          filled: true,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: otpController4,
                        onChanged: (value) {
                          if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.length == 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(31, 31, 31, 1),
                          filled: true,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: otpController5,
                        onChanged: (value) {
                          if (value.length == 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(31, 31, 31, 1),
                          filled: true,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(otpController1.text +
                          otpController2.text +
                          otpController3.text +
                          otpController4.text +
                          otpController5.text);
                      if (await widget.myemailAuth.verifyOTP(
                              otp: otpController1.text +
                                  otpController2.text +
                                  otpController3.text +
                                  otpController4.text +
                                  otpController5.text) ==
                          true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("OTP is verified"),
                          ),
                        );
                        try {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MySignUp2(widget.email),
                            ),
                          );
                        } on Exception catch (e) {
                          print(widget.email);
                          print(
                              "Errro in otp page ${e} while creating account");
                        }
                        ;
                      } else {
                        profile.errorMessage = "Invalid OTP!!";
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Invalid OTP"),
                          ),
                        );
                      }
                    },
                    child: Text(
                      "VERIFY",
                      style: TextStyle(
                        fontSize: screenWidth / 22,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(1, 71, 244, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                profile.errorMessage != ""
                    ? Column(
                        children: [
                          Container(
                            width: screenWidth,
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
                                  width: screenWidth * 0.01,
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
