import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern/ChatScreen.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/profile_org.dart';
import 'package:intern/original/swiping_page.dart';

import 'chatroom_org.dart';

class ChatHomeScreen extends StatefulWidget {
  final Profile profile;
  const ChatHomeScreen(this.profile, {Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState(profile);
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with WidgetsBindingObserver {
  final Profile profile;
  _ChatHomeScreenState(this.profile);

  final String _text = "RapBuZzz";

  List<Map<String, String>> mutualChatInfo = [];
  final _db = FirebaseFirestore.instance.collection("UsersData");
  final _auth = FirebaseAuth.instance;

  void setStatus(String status) async {
    await _db.doc(_auth.currentUser?.uid).set({
      "Status": status,
    });
    print("Updated");
  }

  @override
  void didChangeAppLifeCycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "${user1}${user2}";
    } else {
      return "${user2}${user1}";
    }
  }

  void _retrieveChats() async {
    for (int i = 0; i < profile.mutualFriendsInfo.length; i++) {
      String? email = profile.mutualFriendsInfo[i]["Email"];
      String roomId = chatRoomId(profile.email, email!);

      QuerySnapshot snapshot = await _db
          .where("Email", isEqualTo: profile.mutualFriendsInfo[i]["Email"])
          .get();
      DocumentSnapshot documentSnapshot = snapshot.docs.first;
      final String name = documentSnapshot.get("Name");
      final String url = documentSnapshot.get("profile_pic");
      String recentMessage = "";

      QuerySnapshot snapshotChat = await FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(roomId)
          .collection("Chats")
          .orderBy("Time", descending: true)
          .limit(1)
          .get();

      if (snapshotChat.docs.isNotEmpty) {
        DocumentSnapshot mostRecentDoc = snapshotChat.docs.first;
        recentMessage = mostRecentDoc.get("Message");
      }

      mutualChatInfo.add({
        "Name": name,
        "Email": email,
        "URL": url,
        "Recent Message": recentMessage,
      });
    }
    setState(() {
      profile.mutualChatInfo = mutualChatInfo;
    });
    //print(mutualChatInfo);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _retrieveChats();
    print(profile.mutualChatInfo);
    super.initState();
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.03,
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Text(
                        "Recent Chats",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth / 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.03,
                  ),
                  child: Column(
                    children:
                        List.generate(profile.mutualChatInfo.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          String roomId = chatRoomId(profile.email,
                              profile.mutualChatInfo[index]["Email"]!);
                          print("Navigating...");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(roomId,
                                    profile.mutualChatInfo[index], profile)),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              //bottom: screenHeight*0.03,
                              ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      profile.mutualChatInfo[index]["URL"]!,
                                    ),
                                    radius: screenWidth * 0.08,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.03,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        profile.mutualChatInfo[index]["Name"]!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth / 22,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            profile.mutualChatInfo[index]
                                                ["Recent Message"]!,
                                            maxLines: 1,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile(profile)),
              );
            },
            icon: Image.asset(
              "assets/images/profile_icon.png",
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset(
              "assets/images/chat_home_icon.png",
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
