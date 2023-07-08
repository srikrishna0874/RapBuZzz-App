import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/utils/profile_details.dart';

import 'ChatScreen.dart';

class MyChatHomeScreen extends StatefulWidget {
  final Profile profile;
  const MyChatHomeScreen(this.profile, {super.key});

  @override
  State<MyChatHomeScreen> createState() => _MyChatHomeScreenState(profile);
}

class _MyChatHomeScreenState extends State<MyChatHomeScreen> {
  Profile profile;
  _MyChatHomeScreenState(this.profile);

  bool _isClickedSearch = false;
  Map<String, dynamic> data = {};

  final TextEditingController _searchController = TextEditingController();
  final _db = FirebaseFirestore.instance.collection("UsersData");
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void onSearch() async {
    setState(() {
      _isLoading = true;
    });
    if(profile.mutualFriendsInfo.any((element) => (element.containsValue(_searchController.text)))) {
      await _db.where("Name", isEqualTo: _searchController.text).get().then(
            (value) {
          setState(
                () {
              data = value.docs[0].data();
              _isLoading = false;
            },
          );
          print(data);
        },
      ).onError((error, stackTrace) {
        print("Not Found ${error}");
        setState(() {
          _isLoading = false;
        });
      });
    }
    else {
      print("User Not Found");
      setState(() {
        _isLoading = false;
      });
    }

  }

  String chatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "${user1}${user2}";
    } else {
      return "${user2}${user1}";
    }
  }

  Future<String?> getName(String email) async {
    final snapshot = await _db.where("Email", isEqualTo: email).get();
    if (snapshot.size == 0) {
      return null;
    }
    final doc = snapshot.docs.first;
    final name = doc["Name"] as String?;
    return name;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mutual Friends"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isClickedSearch = !_isClickedSearch;
              });
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
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
                        height: screenHeight * 0.02,
                      ),
                      _isClickedSearch
                          ? TextField(
                              autofocus: false,
                              controller: _searchController,
                              decoration: InputDecoration(
                                suffixIcon: Container(
                                  margin: EdgeInsets.only(right: 8),
                                  width: screenWidth * 0.25,
                                  height: screenHeight * 0.01,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      onSearch();
                                    },
                                    child: const Text(
                                      "Search",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.4),
                                hintText: "Search here...",
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 18),
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      data.length != 0
                          ? Container(
                              width: screenWidth,
                              height: screenHeight * 0.08,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                onTap: () {
                                  String roomId =
                                      chatRoomId(profile.email, data["Email"]);

                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatPage(roomId, data, profile),
                                    ),
                                  );*/
                                },
                                title: Text(
                                  data["Name"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(data["Email"]),
                                trailing: Icon(
                                  Icons.chat,
                                  color: Colors.black,
                                ),
                                leading: Icon(
                                  Icons.account_box_rounded,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
