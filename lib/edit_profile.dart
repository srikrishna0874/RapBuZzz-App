import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern/profile.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/profile_org.dart';
import 'package:permission_handler/permission_handler.dart';

import 'original/utils/firebase_service.dart';
import 'home.dart';

class EditProfile extends StatefulWidget {
  final Profile profile;
  const EditProfile(this.profile);

  @override
  State<EditProfile> createState() => _EditProfileState(profile);
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phnnumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final Profile profile;

  _EditProfileState(
    this.profile,
  );
  bool isVisiblePassword = false;
  bool isObscured = true;
  ImagePicker picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    () async {
      var _permissionStatus = await Permission.storage.status;
      if (_permissionStatus != PermissionStatus.granted) {
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    };
  }

  void pickImageSource(ImageSource source) async {
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
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(200, 40, 148, 1),
              Color.fromRGBO(149, 70, 197, 1),
              Color.fromRGBO(93, 97, 249, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(
                left: screenWidth * 0.025, right: screenWidth * 0.025),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: screenWidth * 0.1,
                          height: screenHeight * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                  color: const Color.fromRGBO(79, 79, 79, 1))),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyProfile(profile)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5.0),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "SAVE",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
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
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 30,
                                  horizontal: 30,
                                ),
                                child: CircleAvatar(
                                  radius: 71,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundImage: profile.profile_pic_url ==
                                            ""
                                        ? null
                                        : NetworkImage(profile.profile_pic_url),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                right: 40,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blue,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                _buildTextField(
                    "Username", profile.name, false, _usernameController),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                _buildTextField(
                    "Email", profile.email, false, _emailController),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                _buildTextField(
                    "Password", "********", true, _passwordController),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                _buildTextField("Phone Number", profile.phoneNumber, false,
                    _phnnumberController),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfile(profile)));
                      },
                      child: Text(
                        "CANCEL",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 2,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shadowColor: Colors.yellow,
                        elevation: 20,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          profile.updateDetails(
                            _usernameController.text,
                            _emailController.text,
                            _phnnumberController.text,
                            profile.password,
                            profile.profile_pic_url,
                            profile.friends,
                            profile.likedMe,
                            profile.mutualFriends,
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfile(profile)));
                        });
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shadowColor: Colors.green,
                        elevation: 20,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder,
      bool isPasswordTextField, TextEditingController controller) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscured : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? isObscured
                  ? IconButton(
                      icon: Icon(
                        Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscured = !isObscured;
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
                          isObscured = !isObscured;
                        });
                      },
                    )
              : null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.withOpacity(1),
          ),
        ),
      ),
    );
  }
}
