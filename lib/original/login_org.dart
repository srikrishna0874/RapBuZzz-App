import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/signup_org.dart';
import 'package:intern/signup_page.dart';
import 'package:intern/original/swiping_page.dart';
import 'package:text_divider/text_divider.dart';

import 'utils/firebase_service.dart';
import 'forgot_password_org.dart';
import '../home.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _text = "RapBuZzz";
  bool _isObscuredPasssword = true;
  final _auth = FirebaseAuth.instance;
  Profile profile = Profile();
  bool _isLoading = false;
  bool _showError = true;

  List<String> img_all = [];
  List<String> name_all = [];
  List<String> img_names = [];
  final _db = FirebaseFirestore.instance.collection("UsersData");

  String _isVaildated(String email, String password) {
    if (email.isEmpty) {
      return "Email should not be empty";
    }
    if (password.isEmpty) {
      return "Password should not be empty";
    }
    if (!email.contains("@")) {
      return "Invalid Email";
    }
    if (password.length < 8) {
      return "Invalid Password";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    String _errorMessage = "";
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
                        margin: EdgeInsets.only(top: screenHeight * 0.06),
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
                                            fontSize: _text[i] == "R" ||
                                                    _text[i] == "B"
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
                                                : Color.fromRGBO(
                                                    0, 72, 255, 1)),
                                      )
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
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth / 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Please sign in to continue",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: screenWidth / 30),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
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
                              height: screenHeight * 0.02,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Password",
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
                              controller: _passwordController,
                              obscureText: _isObscuredPasssword,
                              cursorHeight: 25,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: "Enter your Password",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.3)),
                                suffixIcon: _isObscuredPasssword
                                    ? IconButton(
                                        icon: Icon(Icons.visibility),
                                        color: Colors.white,
                                        onPressed: () {
                                          setState(() {
                                            _isObscuredPasssword =
                                                !_isObscuredPasssword;
                                          });
                                        },
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _isObscuredPasssword =
                                                !_isObscuredPasssword;
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgotPassword(),
                                      ),
                                    );
                                  },
                                  child: Text("Forgot Password?"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(
                                        screenWidth * 0.3, screenHeight * 0.06),
                                    backgroundColor:
                                        Color.fromRGBO(1, 73, 255, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      profile.errorMessage = _isVaildated(
                                          _emailController.text,
                                          _passwordController.text);
                                    });
                                    if (profile.errorMessage.isEmpty) {
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

                                        print("Getting current data......");

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

                                        DocumentSnapshot documentSnapshot =
                                            await _db
                                                .doc(_auth.currentUser?.uid)
                                                .get();
                                        List<dynamic> mutual_cur =
                                            documentSnapshot
                                                .get("Mutual Friends");
                                        List<dynamic> liked_by_me_cur =
                                            documentSnapshot.get("Liked By Me");
                                        print(
                                            "Liked By Me: ${liked_by_me_cur}");

                                        List<Map<String, String>> other_info =
                                            [];

                                        QuerySnapshot snapshot =
                                            await _db.get();
                                        snapshot.docs.forEach((doc) {
                                          String url = doc.get("profile_pic");
                                          String img_name = doc.get("Email");
                                          String other_name = doc.get("Name");

                                          if (img_name != profile.email) {
                                            if ((!mutual_cur
                                                    .contains(img_name)) &&
                                                (!liked_by_me_cur
                                                    .contains(img_name))) {
                                              other_info.add({
                                                "Name": other_name,
                                                "Email": img_name,
                                                "URL": url,
                                              });
                                              print("${img_name} added");
                                            }
                                          }
                                        });

                                        profile.other_user_info = other_info;

                                        //Getting the information of mutualFriends...

                                        print("Getting info of mutualFriendd");

                                        final currentUserDoc = await _db
                                            .doc(_auth.currentUser?.uid)
                                            .get();
                                        final mutualFriendsEmails =
                                            List<String>.from(currentUserDoc
                                                .get("Mutual Friends"));

                                        List<Map<String, String>>
                                            otherUserMutualInfo = [];

                                        for (String email
                                            in mutualFriendsEmails) {
                                          QuerySnapshot querySnapshot =
                                              await _db
                                                  .where("Email",
                                                      isEqualTo: email)
                                                  .get();
                                          final data = querySnapshot.docs.first;
                                          otherUserMutualInfo.add({
                                            "Name": data["Name"],
                                            "Email": data["Email"],
                                            "URL": data["profile_pic"],
                                          });
                                        }

                                        profile.mutualFriendsInfo =
                                            otherUserMutualInfo;

                                        print(
                                            "Done getting info of mutual friends \n i.e. ${profile.mutualFriendsInfo}");
                                        /*try{
                                          final mutualFriendsDocs = await _db
                                              .where("Email",
                                              whereIn: mutualFriendsEmails)
                                              .get();
                                          print("Line 397");
                                          final mutualFriendsImageUrls =
                                          <String>[];
                                          final mutualFriendsNames = <String>[];
                                          print("before loop...");
                                          for (final mutualFriendDoc
                                          in mutualFriendsDocs.docs) {

                                            print("Loop entered");
                                            final friendImageUrls =
                                            mutualFriendDoc
                                                .get("profile_pic");
                                            final friendName =
                                            mutualFriendDoc.get("Name");
                                            final friendEmail =
                                            mutualFriendDoc.get("Email");
                                            mutualFriendsNames.add(friendName);


                                            otherUserMutualInfo.add(
                                              {
                                                "Name": friendName,
                                                "URL": friendImageUrls,
                                                "Email": friendEmail,

                                              },
                                            );

                                            mutualFriendsImageUrls
                                                .add(friendImageUrls);
                                          }

                                          profile.mutualFriendsImageURLs =
                                              mutualFriendsImageUrls;
                                          profile.mutualFriendsNames =
                                              mutualFriendsNames;
                                          profile.mutualFriendsInfo =
                                              otherUserMutualInfo;
                                        }
                                        catch (e) {
                                          print("ERROR in 400----${e}");
                                        }*/

                                        //Done getting the information of mutual friends...

                                        //Getting the information of likedMefriends....

                                        print("Getting info of likedMe....");

                                        final likedMeEmails = List<String>.from(
                                            currentUserDoc.get("Liked Me"));

                                        List<Map<String, String>>
                                            otherUserlikedMeInfo = [];

                                        for (String email in likedMeEmails) {
                                          QuerySnapshot querySnapshot =
                                              await _db
                                                  .where("Email",
                                                      isEqualTo: email)
                                                  .get();
                                          final data = querySnapshot.docs.first;
                                          otherUserlikedMeInfo.add({
                                            "Name": data["Name"],
                                            "Email": data["Email"],
                                            "URL": data["profile_pic"],
                                          });
                                        }

                                        profile.likedMeInfo =
                                            otherUserlikedMeInfo;

                                        /*final likedMeDocs = await _db
                                            .where("Email",
                                                whereIn: likedMeemails)
                                            .get();
                                        final likedMeImageUrls = <String>[];
                                        for (final likedMe
                                            in likedMeDocs.docs) {
                                          final friendImageUrl =
                                              likedMe.get("profile_pic");
                                          final friendName =
                                              likedMe.get("Name");
                                          final friendEmail =
                                              likedMe.get("Email");

                                          otherUserLikedMe.add({
                                            "Name": friendName,
                                            "Email": friendEmail,
                                            "URL": friendImageUrl,
                                          });
                                        }

                                        profile.likedMeInfo=otherUserLikedMe;*/

                                        //Done getting likedMe info...

                                        profile.other = img_all;
                                        profile.other_names = img_names;
                                        profile.name_all_others = name_all;

                                        print(profile.other_user_info);
                                        print(
                                            "Length of other names is ${profile.other_user_info.length}");
                                        setState(() {
                                          _isLoading = false;
                                          profile.errorMessage = "";
                                        });

                                        print(
                                            "Redirecting to home page plz wait...");

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyHomePage(profile)));
                                        print("Navigated!!!");
                                      }); /*.onError((error, stackTrace) {
                                        setState(() {
                                          _isLoading = false;
                                          profile.errorMessage =
                                              "Please enter valid Email/Password";
                                        });
                                        print(
                                            "Sorry! Wrong details given!!!${error}");
                                      });*/
                                    } else {
                                      print("Error message: ${_errorMessage}");
                                      setState(() {
                                        _showError = true;
                                        print("Called");
                                      });
                                    }
                                  },
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                            profile.errorMessage != ""
                                ? Column(
                                    children: [
                                      Container(
                                        width: screenWidth,
                                        height: screenHeight * 0.08,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.info,
                                              color: Color.fromRGBO(
                                                  202, 40, 36, 1),
                                            ),
                                            SizedBox(
                                              width: screenWidth * 0.02,
                                            ),
                                            AutoSizeText(
                                              profile.errorMessage,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: screenWidth / 25,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.01,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(
                                        "Error Message in sign up: ${_errorMessage}");
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MySignUp()),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Color.fromRGBO(18, 88, 153, 1),
                                        fontSize: screenWidth / 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            TextDivider.horizontal(
                              thickness: 2,
                              text: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: screenHeight * 0.02,
                            ),
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.07,
                              decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.white,),
                                  color: Color.fromRGBO(0, 73, 255, 1)),
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await FireBaseServices().signInWithGoogle();
                                  String name =
                                      _auth.currentUser?.displayName ?? "";
                                  String email = _auth.currentUser?.email ?? "";
                                  String url =
                                      _auth.currentUser?.photoURL ?? "";
                                  String? phoneNumber =
                                      _auth.currentUser?.phoneNumber ?? "";
                                  profile.updateDetails(
                                      name,
                                      email,
                                      phoneNumber,
                                      "google_sign",
                                      url, [], [], []);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyHomePage(profile)));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      child: Image.asset(
                                        "assets/images/google_logo.png",
                                        width: screenWidth * 0.15,
                                        height: screenHeight * 0.07,
                                      ),
                                    ),
                                    Container(
                                      width: screenWidth * 0.6,
                                      child: Center(
                                        child: Text(
                                          "Sign in with Google",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: screenWidth / 20),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
