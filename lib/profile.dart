import 'package:flutter/material.dart';
import 'package:intern/original/swiping_page.dart';
import 'chat_homeScreen.dart';
import 'original/chatscreen_org.dart';
import 'edit_profile.dart';
import 'original/edit_profile_org.dart';
import 'home.dart';
import 'original/utils/profile_details.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;
  const ProfilePage(this.profile);

  @override
  State<ProfilePage> createState() => _ProfilePageState(profile);
}

class _ProfilePageState extends State<ProfilePage> {
  Profile profile;
  _ProfilePageState(this.profile);

  bool isEnableMutual = true;
  bool isEnableLikedByMe = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
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
                                          MyHomePage(profile)));
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
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyEditProfile(profile)));
                        },
                        child: const Text(
                          "EDIT",
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
                    onTap: () {},
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
                  height: screenHeight * 0.02,
                ),
                Center(
                  child: Text(
                    profile.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    profile.email,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Phone Number: ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            profile.phoneNumber,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isEnableMutual == false) {
                            isEnableMutual = true;
                            isEnableLikedByMe = false;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: isEnableMutual ? null : 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenHeight * 0.016),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: isEnableMutual
                            ? Color.fromRGBO(30, 144, 255, 1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        "Mutual Friends",
                        style: isEnableMutual
                            ? TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Inter',
                              )
                            : TextStyle(
                                color: Colors.white30,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isEnableLikedByMe == false) {
                            isEnableLikedByMe = true;
                            isEnableMutual = false;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenHeight * 0.016),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        backgroundColor: isEnableLikedByMe
                            ? Color.fromRGBO(30, 144, 255, 1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        "Liked By Me",
                        style: isEnableLikedByMe
                            ? TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Inter',
                              )
                            : TextStyle(
                                color: Colors.white30,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isEnableMutual
                      ? Container(
                          child: profile.mutualFriends.length == 0
                              ? Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Text(""),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "You have no mutual friends😔\nBut Don't Worry!",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * 0.25,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "Make friends ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyHomePage(
                                                                          profile)));
                                                        },
                                                        child: Text(
                                                          "here",
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            color: Colors.blue,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      child: ListView.builder(
                                        itemCount: profile.mutualFriends.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            width: screenWidth,
                                            height: screenHeight * 0.05,
                                            margin: EdgeInsets.only(
                                              left: 10,
                                              bottom: 8,
                                              right: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.only(
                                              left: 10,
                                              top: 8,
                                              bottom: 10,
                                            ),
                                            child: Text(
                                              profile.mutualFriends[index],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatHomeScreen(profile)));
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: ShapeDecoration(
                                            shape: RoundedRectangleBorder(),
                                            color: Colors.transparent,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(1),
                                            child: DecoratedBox(
                                              child: Center(
                                                child: Text(
                                                  "View All",
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                        )
                      : Container(
                          child: profile.friends.length == 0
                              ? Container(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Text(""),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                "You have not liked any one😔",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * 0.35,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "Like ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      MyHomePage(
                                                                          profile)));
                                                        },
                                                        child: Text(
                                                          "here",
                                                          style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            color: Colors.blue,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
