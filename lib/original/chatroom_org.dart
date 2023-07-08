import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intern/original/utils/profile_details.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String roomId;
  final Map<String, String> userMap;
  final Profile profile;

  ChatPage(this.roomId, this.userMap, this.profile);

  @override
  State<ChatPage> createState() => _ChatPageState(roomId, userMap, profile);
}

class _ChatPageState extends State<ChatPage> {
  final String roomId;
  final Map<String, String> userMap;
  final Profile profile;

  _ChatPageState(this.roomId, this.userMap, this.profile);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _message = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 113, 217, 1),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(userMap["URL"]!),
            ),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            Text(
              userMap["Name"]!,
            ),
          ],
        ),
      ),
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
                              margin: EdgeInsets.only(
                                right: screenWidth*0.02,
                              ),
                              alignment: snapshot.data?.docs[index]["SendBy"] ==
                                      profile.email
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 14),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: snapshot.data?.docs[index]
                                                  ["SendBy"] ==
                                              profile.email
                                          ? Color.fromRGBO(236, 236, 236, 1)
                                          : Color.fromRGBO(229, 243, 254, 1),
                                    ),
                                    child: Text(
                                      snapshot.data?.docs[index]["Message"],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('hh:mm a').format(snapshot
                                        .data?.docs[index]["Time"]
                                        .toDate()),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(),
                                  )
                                ],
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
                  color: Colors.white,
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
                              hintText: "Your Message",
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
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
                            color: Colors.black,
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
