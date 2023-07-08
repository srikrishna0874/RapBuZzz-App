import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/chatscreen_org.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/profile_org.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'dart:ui';

import 'utils/firebase_service.dart';

class MyHomePage extends StatefulWidget {
  final Profile profile;
  const MyHomePage(this.profile, {Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(profile);
}

class _MyHomePageState extends State<MyHomePage> {
  final Profile profile;
  _MyHomePageState(this.profile);

  MatchEngine _matchEngine = new MatchEngine();
  List<SwipeItem> _swipeItems = <SwipeItem>[];

  String _text = "RapBuZzz";
  var screenWidth = (window.physicalSize.shortestSide / window.devicePixelRatio);
  var screenHeight = (window.physicalSize.longestSide / window.devicePixelRatio);

  @override
  void initState() {
    super.initState();
    print(profile.other_user_info.length);
    for (int i = 0; i < profile.other_user_info.length; i++) {
      print("Adding ${profile.other_user_info[i]["Email"]}");
      _swipeItems.add(
        SwipeItem(
          content: Container(
            width: screenWidth,
            height: screenHeight*0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              //border: Border.all(color: Colors.red)
            ),
            child: Stack(
              children: [
                 ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      profile.other_user_info[i]["URL"]!,
                      fit: BoxFit.cover,
                      height: screenHeight*0.8,
                    ),
                  ),

                Positioned(
                  bottom: 20,
                  left: 40,
                  right: 50,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Text(
                      profile.other_user_info[i]["Name"]!,
                      style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 40,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          likeAction: () {
            print("Liked");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Liked"),
                duration: Duration(milliseconds: 1000),
              ),
            );
            FireBaseServices()
                .addToFriend(profile.other_user_info[i]["Email"]!, profile.email, profile);

            //profile.tinder_map[profile.other_names[i]] = true;
          },
          nopeAction: () {
            //profile.tinder_map[profile.other_names[i]] = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Disiked"),
                duration: Duration(milliseconds: 1000),
              ),
            );
          },
          superlikeAction: () {},
          onSlideUpdate: (SlideRegion? region) async {},
        ),
      );
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);

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
                  decoration: BoxDecoration(
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
                profile.other_user_info.isNotEmpty
                    ? Column(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                left: screenWidth * 0.06,
                                right: screenWidth * 0.05,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                //border: Border.all(color: Colors.red,)
                              ),
                              height: screenHeight * 0.5,
                              //width: screenWidth,
                              child: Center(
                                child: SwipeCards(
                                  upSwipeAllowed: false,
                                  matchEngine: _matchEngine,
                                  onStackFinished: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Cards Finished!"),
                                        duration: Duration(milliseconds: 1000),
                                      ),
                                    );
                                  },
                                  likeTag: Container(
                                    width: screenWidth * 0.3,
                                    height: screenHeight * 0.08,
                                    margin: EdgeInsets.all(15),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.thumb_up,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.01,
                                        ),
                                        Text(
                                          "Liked",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  nopeTag: Container(
                                    width: screenWidth * 0.35,
                                    height: screenHeight * 0.08,
                                    margin: EdgeInsets.all(15),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.thumb_down,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.01,
                                        ),
                                        Text(
                                          "DisLiked",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth / 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  fillSpace: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: screenWidth * 0.9,
                                      height: screenHeight * 0.9,
                                      margin: EdgeInsets.only(left: 10, right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: _swipeItems[index].content,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _matchEngine.currentItem?.nope();
                                },
                                child: CircleAvatar(
                                  radius: screenWidth * 0.1,
                                  backgroundColor:
                                      Color.fromRGBO(1, 113, 216, 1),
                                  child: Image.asset(
                                    "assets/images/decline.png",
                                    width: screenWidth * 0.1,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _matchEngine.currentItem?.like();
                                },
                                child: CircleAvatar(
                                  radius: screenWidth * 0.1,
                                  backgroundColor:
                                      Color.fromRGBO(1, 113, 216, 1),
                                  child: Image.asset(
                                    "assets/images/heart.png",
                                    width: screenWidth * 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.08,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: screenWidth * 0.03,
                              right: screenWidth * 0.03,
                            ),
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.05,
                              right: screenWidth * 0.05,
                            ),
                            height: screenHeight * 0.5,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: DottedBorder(
                                dashPattern: [10, 8],
                                borderType: BorderType.RRect,
                                color: Color.fromRGBO(0, 72, 255, 0.8),
                                strokeWidth: 3,
                                padding: EdgeInsets.only(
                                  left: screenWidth * 0.03,
                                  right: screenWidth * 0.03,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/swiping_icon.png",
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                    Center(
                                      child: AutoSizeText(
                                        "No profiles to be display for now....Stay tuned for further updates and enjoy your Rap",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: screenWidth / 25,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                onPressed: () {},
                icon: Image.asset(
                  "assets/images/swiping_icon.png",
                  color: Colors.white,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              print(screenWidth);
              print(screenHeight);
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatHomeScreen(profile)),
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
}
