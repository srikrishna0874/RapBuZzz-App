import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intern/login_page.dart';

import 'login_org.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String text = "RapBuZzz";

  bool _isLoading = true;

  bool _isIncreasing1 = true, _isIncreasing2 = false;
  Color _color1 = Colors.white, _color2 = Color.fromRGBO(0, 72, 255, 1);
  late Timer _timer;
  //late AnimationController _controller;
  late Animation<double> _animation;
  double _textSize1 = 25, _textSize2 = 25;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 5),() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyLogin()));
    });

    animateText();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      animateText();
    });

    /*_timer = Timer(
      Duration(seconds: 5),
      () {
        Navigator.pushReplacementNamed(context, '/home');
      },
    );*/
  }

  void animateText() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_isIncreasing1) {
          _textSize1 += 0.5;

          _color1 = Color.fromRGBO(0, 72, 255, 1);
        } else {
          _textSize1 -= 0.5;

          _color1 = Colors.white;
        }

        if (_isIncreasing2) {
          _textSize2 += 0.5;
          _color2 = Colors.white;
        } else {
          _textSize2 -= 0.5;
          _color2 = Color.fromRGBO(0, 72, 255, 1);
        }

        // Reverse the direction of animation when the font size reaches a certain limit
        if (_textSize1 >= 40) {
          _isIncreasing1 = false;
        } else if (_textSize1 <= 20) {
          _isIncreasing1 = true;
        }

        if(_textSize2>=40) {
          _isIncreasing2=false;
        }
        else if(_textSize2<=20){
          _isIncreasing2=true;
        }
      });

      // Stop the animation after 1 minute
      if (timer.tick == 1200) {
        timer.cancel();
      }
    });
  }

  void startLoading() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      stopLoading();
    });
  }

  void stopLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: null,
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              width: screenWidth,
              height: screenHeight * 0.85,
              child: Image.asset(
                "assets/images/splash_pic1.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: screenWidth,
              height: screenHeight * 0.15,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 1),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Welcome to",
                        style: TextStyle(
                          fontSize: screenWidth / 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(),
                          children: [
                            for (int i = 0; i < text.length; i++)
                              TextSpan(
                                text: text[i],
                                style: TextStyle(
                                  color: i < 3 ? _color1 : _color2,
                                  fontWeight: FontWeight.w900,
                                  fontSize: text[i] == "R" || text[i] == "B"
                                      ? 60
                                      : i < 3
                                          ? _textSize1
                                          : _textSize2,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  )
                  /*Expanded(
                    child: Container(),
                  )*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
