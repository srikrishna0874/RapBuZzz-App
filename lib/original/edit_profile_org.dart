import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern/home.dart';
import 'package:intern/profile.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/profile_org.dart';

import 'utils/firebase_service.dart';

class MyEditProfile extends StatefulWidget {
  final Profile profile;
  const MyEditProfile(this.profile);

  @override
  State<MyEditProfile> createState() => _MyEditProfileState(profile);
}

class _MyEditProfileState extends State<MyEditProfile> {
  final Profile profile;
  _MyEditProfileState(this.profile);

  final String _text = "RapBuZzz";

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance.collection("UsersData");

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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
    setState(() async {
      FireBaseServices().updateData("profile_pic", profile_pic_url);
    });
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
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
              top: screenHeight * 0.01,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.01),
                  width: screenWidth,
                  height: screenHeight * 0.1,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(229, 236, 246, 1),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.004,
                      bottom: screenHeight * 0.004,
                    ),
                    width: screenWidth,
                    height: screenHeight * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(profile)),
                            );
                          },
                        ),
                        Container(
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.25,
                          margin: EdgeInsets.only(
                              left: screenWidth * 0.008,
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
                                        ? Colors.black
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
                  height: screenHeight * 0.03,
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
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                              pickImageSource(
                                                  ImageSource.gallery);
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
                                            pickImageSource(ImageSource.camera);
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
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Color.fromRGBO(5, 78, 255, 1),
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 68,
                          backgroundImage: profile.profile_pic_url == ""
                              ? null
                              : NetworkImage(profile.profile_pic_url),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: screenWidth * 0.1,
                                  height: screenHeight * 0.04,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(1, 76, 249, 1),
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.07,
                    right: screenWidth * 0.07,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Username",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      SizedBox(
                        height: screenHeight * 0.06,
                        child: TextField(
                          controller: _usernameController,
                          cursorHeight: screenHeight * 0.03,
                          cursorColor: Color.fromRGBO(1, 76, 249, 1),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            hintText: profile.name,
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: screenWidth / 25,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(229, 236, 246, 1),
                            focusColor: Color.fromRGBO(229, 236, 246, 1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(1, 76, 249, 1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        children: [
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      SizedBox(
                        height: screenHeight * 0.06,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _phoneNumberController,
                          cursorHeight: screenHeight * 0.03,
                          cursorColor: Color.fromRGBO(1, 76, 249, 1),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.call,
                              color: Colors.black,
                            ),
                            hintText: profile.phoneNumber,
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: screenWidth / 25,
                            ),
                            filled: true,
                            fillColor: Color.fromRGBO(229, 236, 246, 1),
                            focusColor: Color.fromRGBO(229, 236, 246, 1),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(1, 76, 249, 1),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.05,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_phoneNumberController.text != "") {
                                  _db.doc(_auth.currentUser?.uid).update({
                                    "Phone Number": _phoneNumberController.text
                                  });
                                  setState(() {
                                    profile.phoneNumber =
                                        _phoneNumberController.text;
                                  });
                                }
                                if (_usernameController.text != "") {
                                  _db.doc(_auth.currentUser?.uid).update(
                                      {"Name": _usernameController.text});
                                  setState(() {
                                    profile.name = _usernameController.text;
                                  });
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyProfile(profile)),
                                );
                              },
                              child: Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(0, 75, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.05,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyProfile(profile)),
                                );
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontSize: screenWidth / 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(229, 236, 246, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
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
