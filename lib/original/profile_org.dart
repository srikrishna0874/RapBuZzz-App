import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern/ChatScreen.dart';
import 'package:intern/original/chatscreen_org.dart';
import 'package:intern/original/login_org.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/swiping_page.dart';

import 'chatroom_org.dart';
import 'edit_profile_org.dart';

class MyProfile extends StatefulWidget {
  final Profile profile;
  MyProfile(this.profile);

  @override
  State<MyProfile> createState() => _MyProfileState(profile);
}

class _MyProfileState extends State<MyProfile> {
  final Profile profile;
  _MyProfileState(this.profile);

  bool _isVisibleMutualFriends = true;
  bool _isVisibleLikedByMe = false;

  final _db = FirebaseFirestore.instance.collection("UsersData");
  final _auth = FirebaseAuth.instance;

  final String _text = "RapBuZzz";

  String _message = "You have no mutual friends...Make friends here";

  List<String> _mutualFriendsImageUrls = [];

  ColorFilter colorFilter = ColorFilter.matrix([
    0.5,
    0,
    0,
    0,
    0,
    0,
    0.5,
    0,
    0,
    0,
    0,
    0,
    0.5,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  String chatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "${user1}${user2}";
    } else {
      return "${user2}${user1}";
    }
  }

  Future<void> fetchFriendsImages() async {
    final currentUserDoc = await _db.doc(_auth.currentUser?.uid).get();
    final mutualFriendsEmails =
        List<String>.from(currentUserDoc.get("Mutual Friends"));
    final mutualFriendsDocs =
        await _db.where("Email", whereIn: mutualFriendsEmails).get();
    final mutualFriendsImageUrls = <String>[];
    for (final mutualFriendDoc in mutualFriendsDocs.docs) {
      final friendImageUrls = mutualFriendDoc.get("profile_pic");
      mutualFriendsImageUrls.add(friendImageUrls);
    }

    _mutualFriendsImageUrls = _mutualFriendsImageUrls;
  }

  @override
  void initState() {
    super.initState();
    //fetchFriendsImages();
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
                  margin: EdgeInsets.only(
                    top: screenHeight * 0.01,
                  ),
                  width: screenWidth,
                  height: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(229, 236, 246, 1),
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
                                        ? Colors.black
                                        : Color.fromRGBO(0, 72, 255, 1),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.08,
                        ),
                        PopupMenuButton(
                          color: Color.fromRGBO(229, 236, 248, 1),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'Logout',
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.logout_rounded),
                                  SizedBox(
                                    width: screenWidth * 0.01,
                                  ),
                                  Text("Logout"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'Edit',
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(
                                    width: screenWidth * 0.01,
                                  ),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'Logout') {
                              _auth.signOut();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyLogin()),
                              );
                            } else if (value == 'Edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyEditProfile(profile)),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.more_vert_rounded,
                            size: screenWidth * 0.08,
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
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Center(
                  child: AutoSizeText(
                    profile.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth / 15,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Center(
                  child: Text(
                    profile.email,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: screenWidth / 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Phone Number:",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth / 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.5,
                      height: screenHeight * 0.06,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(229, 236, 246, 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          profile.phoneNumber,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth / 19,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.08,
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.03,
                    right: screenWidth * 0.03,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isVisibleMutualFriends
                                ? Color.fromRGBO(0, 75, 255, 1)
                                : Color.fromRGBO(229, 236, 246, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {
                            if (!_isVisibleMutualFriends) {
                              setState(() {
                                _isVisibleMutualFriends = true;
                                _isVisibleLikedByMe = false;
                              });
                            }
                            print(profile.mutualFriendsImageURLs);
                            print(profile.mutualFriendsInfo);
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.people_alt_rounded,
                                  color: _isVisibleMutualFriends
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                Text(
                                  "Mutual Friends",
                                  style: TextStyle(
                                    color: _isVisibleMutualFriends
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.07,
                        width: screenWidth * 0.45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isVisibleLikedByMe
                                ? Color.fromRGBO(0, 75, 255, 1)
                                : Color.fromRGBO(229, 236, 246, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () {
                            if (_isVisibleLikedByMe == false) {
                              setState(() {
                                _isVisibleLikedByMe = true;
                                _isVisibleMutualFriends = false;
                              });
                            }
                            print(profile.likedMeInfo);
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.forum_sharp,
                                  color: _isVisibleLikedByMe
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.02,
                                ),
                                Text(
                                  "Liked Me",
                                  style: TextStyle(
                                    color: _isVisibleLikedByMe
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth / 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildContainer(
                  _isVisibleMutualFriends,
                  _isVisibleLikedByMe,
                  profile.mutualFriendsInfo.isNotEmpty,
                  profile.likedMeInfo.isNotEmpty,
                  screenWidth,
                  screenHeight,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          _buildMyBottomNavigationBar(context, screenHeight, screenWidth),
    );
  }

  Widget _buildMyBottomNavigationBar(
      BuildContext context, double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight * 0.08,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 72, 255, 0.8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(profile)),
                  );
                },
                icon: Image.asset(
                  "assets/images/swiping_icon.png",
                  color: Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/profile_icon.png",
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (contet) => ChatHomeScreen(profile)),
              );
            },
            icon: Image.asset(
              "assets/images/chat_home_icon.png",
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContainer(
      bool isVisibleMutual,
      bool isVisibleLikedMe,
      bool mutualisNotEmpty,
      bool likedmeisNotEmpty,
      double screenWidth,
      double screenHeight) {
    if (isVisibleMutual) {
      print("mutualisNotEmpty=${mutualisNotEmpty}");
      print("mutual info=${profile.mutualFriendsInfo}");
      if (mutualisNotEmpty) {
        for (int i = 0; i < 5; i++) print("Hi");
        print("Case1,${profile.mutualFriendsInfo.length}");
        return Container(
          width: screenWidth,
          height: screenHeight * 0.5,
          padding: EdgeInsets.only(
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: List.generate(
              profile.mutualFriendsInfo.length,
                  (index) {
                return Center(
                  child: Container(
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ColorFiltered(
                            colorFilter: colorFilter,
                            child: Image.network(
                              profile.mutualFriendsInfo[index]["URL"]!,
                              width: screenWidth * 0.45,
                              height: screenHeight * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: screenHeight * 0.05,
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                          child: Text(
                            profile.mutualFriendsInfo[index]["Name"]!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        print("Case2");
        Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.all(15),
          child: DottedBorder(
            dashPattern: [10, 8],
            strokeWidth: 2,
            color: Color.fromRGBO(0, 72, 255, 0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    color: Colors.grey[500],
                    size: screenWidth * 0.1,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    "You have no Mutual Friends...",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: screenWidth / 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Make Friends",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: screenWidth / 20,
                            fontWeight: FontWeight.w500),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage(profile)),
                          );
                        },
                        child: Text(
                          "here",
                          style: TextStyle(
                            fontSize: screenWidth / 20,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    } else {
      if (likedmeisNotEmpty) {
        print("Case3");
        return Container(
          width: screenWidth,
          height: screenHeight * 0.5,
          padding: EdgeInsets.only(
            left: screenWidth * 0.03,
            right: screenWidth * 0.03,
          ),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: List.generate(
              profile.likedMeInfo.length,
              (index) {
                return Center(
                  child: Container(
                    width: screenWidth * 0.45,
                    height: screenHeight * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ColorFiltered(
                            colorFilter: colorFilter,
                            child: Image.network(
                              profile.likedMeInfo[index]["URL"]!,
                              width: screenWidth * 0.45,
                              height: screenHeight * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: screenHeight * 0.05,
                          left: screenWidth * 0.02,
                          right: screenWidth * 0.02,
                          child: Text(
                            profile.likedMeInfo[index]["Name"]!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        print("Case4");
        return Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.all(15),
          child: DottedBorder(
            dashPattern: [10, 8],
            strokeWidth: 2,
            color: Color.fromRGBO(0, 72, 255, 0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_alt_rounded,
                    color: Colors.grey[500],
                    size: screenWidth * 0.1,
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    "You have not liked by anyone...",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: screenWidth / 20,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return Container();
  }
}
