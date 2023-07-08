import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tinder_swipe/flutter_tinder_swipe.dart';
import 'package:intern/login_page.dart';
import 'package:intern/profile.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intern/original/profile_org.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import 'chat_homeScreen.dart';
import 'original/edit_profile_org.dart';
import 'original/utils/firebase_service.dart';

class HomePage extends StatefulWidget {
  final Profile profile;
  const HomePage(this.profile, {super.key});

  @override
  State<HomePage> createState() => _HomePageState(profile);
}

class _HomePageState extends State<HomePage> {
  Profile profile;
  _HomePageState(this.profile);
  CardController controller = CardController();
  MatchEngine _matchEngine = new MatchEngine();
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  List<String> otherImages = [];
  bool isFirst = true;

  final _db = FirebaseFirestore.instance.collection("UsersData");

  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    print(profile.other.length);
    for (int i = 0; i < profile.other.length; i++) {
      _swipeItems.add(
        SwipeItem(
          content: Image.network(profile.other[i]),
          likeAction: () {
            print("Liked");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Liked"),
              duration: Duration(milliseconds: 1000),
            ));
            FireBaseServices()
                .addToFriend(profile.other_names[i], profile.email, profile);

            profile.tinder_map[profile.other_names[i]] = true;
          },
          nopeAction: () {
            profile.tinder_map[profile.other_names[i]] = true;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(146, 34, 168, 0.8),
        elevation: 0,
        leading: OutlinedButton(
          onPressed: () {
            //_navigateToLoginScreen(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfile(profile)));
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: Text(""),
          ),
        ],
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.orange[50],
            ),
            Container(
              height: screeHeight * 0.4,
              width: screenWidth,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                    ),
                  ],
                  color: Color.fromRGBO(146, 34, 168, 0.8),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80))),
            ),
            //tinder card
            Container(
              margin: const EdgeInsets.only(top: 100, left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: screeHeight * 0.6,
              child: SwipeCards(
                upSwipeAllowed: false,
                matchEngine: _matchEngine,
                onStackFinished: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Cards Finished!"),
                    duration: Duration(milliseconds: 1000),
                  ));
                },
                likeTag: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text("Like"),
                ),
                nopeTag: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text("DisLike"),
                ),
                fillSpace: true,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: screenWidth * 0.9,
                    height: screeHeight * 0.9,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _swipeItems[index].content,
                    ),
                  );
                },
              ),
            ),
            //buttons
            Container(
              margin: const EdgeInsets.only(top: 700),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> shouldInclude(String s) async {
    var snapshot = await _db.doc(FirebaseAuth.instance.currentUser?.uid).get();
    Map<String, dynamic>? data = snapshot.data();
    List<dynamic> tmp = data!["liked Me"];
    if (tmp.contains(s)) {
      //profile.tinder_map[s]=true;
      print("Included ${s}");
      return true;
    }
    return false;
  }
}
