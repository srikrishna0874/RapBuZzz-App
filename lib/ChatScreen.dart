import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/utils/profile_details.dart';

class MyChatPage extends StatefulWidget {
  final String roomId;
  final Map<String, String> userMap;
  Profile profile;

  MyChatPage(this.roomId, this.userMap, this.profile);

  @override
  State<MyChatPage> createState() => _MyChatPageState(roomId, userMap, profile);
}

class _MyChatPageState extends State<MyChatPage> {
  final String roomId;
  final Map<String, String> userMap;
  Profile profile;

  _MyChatPageState(this.roomId, this.userMap, this.profile);

  bool _isLoading = false;

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "SendBy": profile.email,
        "Message": _message.text,
        "Time": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection("ChatRoom")
          .doc(roomId)
          .collection("Chats")
          .add(messages)
          .then((value) => print("success"));

      setState(() {
        _message.clear();
      });
    } else {
      print("Enter some message!!!");
    }
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Container(
      alignment: map['SendBy'],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            userMap["Name"]!,
          ),
        ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.8,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("ChatRoom")
                        .doc(roomId)
                        .collection("Chats")
                        .orderBy("Time", descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: screenWidth,
                              alignment: snapshot.data?.docs[index]["SendBy"] ==
                                      profile.email
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 14),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.green,
                                ),
                                child: Text(
                                  snapshot.data?.docs[index]["Message"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
                Container(
                  color: Color.fromRGBO(93, 97, 249, 1),
                  height: screenHeight * 0.09,
                  width: screenWidth,
                  padding: EdgeInsets.only(bottom: 4, top: 4),
                  child: Container(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.9,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          width: screenWidth * 0.85,
                          height: screenHeight * 0.08,
                          child: TextField(
                            controller: _message,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.3),
                              hintText: "Message",
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 18),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            onSendMessage();
                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: screenHeight * 0.04,
                          ),
                        ),
                      ],
                    ),
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
