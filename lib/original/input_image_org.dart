import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern/home.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/swiping_page.dart';

import 'dart:io';

import 'utils/firebase_service.dart';

class MyInputProfileImagePage extends StatefulWidget {
  final Profile profile;
  MyInputProfileImagePage(this.profile);

  @override
  State<MyInputProfileImagePage> createState() =>
      _MyInputProfileImagePageState(profile);
}

class _MyInputProfileImagePageState extends State<MyInputProfileImagePage> {
  final Profile profile;
  _MyInputProfileImagePageState(this.profile);
  final String _text = "RapBuZzz";

  bool _isLoading = false;

  bool _isImagePicked = false;

  Future<void> pickImageSource(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    final pickedImageFile = File(pickedImage!.path);

    final ref = FirebaseStorage.instance
        .ref()
        .child('UserImages')
        .child('${profile.email}jpg');
    await ref.putFile(pickedImageFile);

    var profile_pic_url = await ref.getDownloadURL();

    setState(() {
      profile.profile_pic_url = profile_pic_url;
    });

    FireBaseServices().updateData("profile_pic", profile_pic_url);
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
                              AutoSizeText(
                                "Add your Profile Picture",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 13,
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
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.05,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  height: screenHeight * 0.2,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: screenHeight * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Select images from...",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: screenHeight * 0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  elevation: 0,
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  pickImageSource(
                                                    ImageSource.gallery,
                                                  );
                                                  setState(() {
                                                    _isLoading = false;
                                                  });

                                                  Navigator.pop(context);
                                                },
                                                child: Image.asset(
                                                  "assets/images/gallery_icon.png",
                                                  width: screenWidth * 0.2,
                                                )),
                                          ),
                                          Expanded(
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                elevation: 0,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                pickImageSource(
                                                  ImageSource.camera,
                                                );
                                                setState(() {
                                                  _isLoading = false;
                                                });

                                                Navigator.pop(context);
                                              },
                                              child: Image.asset(
                                                "assets/images/camera_icon.png",
                                                width: screenWidth * 0.18,
                                                height: screenHeight * 0.1,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: const [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Gallery",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                "Camera",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: !_isLoading
                              ? Stack(
                                  children: [
                                    DottedBorder(
                                      color: Colors.red,
                                      dashPattern: [10, 8],
                                      strokeWidth: 3,
                                      borderType: BorderType.RRect,
                                      radius: Radius.circular(12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          width: screenWidth * 0.5,
                                          height: screenHeight * 0.3,
                                          color: Colors.grey,
                                          child: profile.profile_pic_url == ""
                                              ? null
                                              : Image.network(
                                                  profile.profile_pic_url,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -10,
                                      right: -10,
                                      child: Container(
                                        width: screenWidth * 0.1,
                                        height: screenHeight * 0.05,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color.fromRGBO(1, 76, 249, 1),
                                        ),
                                        child: const Icon(
                                          Icons.add_circle,
                                          size: 28,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Container(
                                    width: screenWidth * 0.08,
                                    height: screenHeight * 0.05,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Container(
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.05,
                        child: ElevatedButton(
                          onPressed: () {
                            if (profile.profile_pic_url != "") {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage(profile)),
                              );
                            }
                          },
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: profile.profile_pic_url != ""
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              fontSize: screenWidth / 22,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: profile.profile_pic_url != ""
                                ? Color.fromRGBO(1, 71, 244, 1)
                                : Color.fromRGBO(1, 71, 244, 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
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
