import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern/original/utils/profile_details.dart';

class FireBaseServices {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _db = FirebaseFirestore.instance.collection("UsersData");

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  updateData(String key, String value) {
    _db.doc(_auth.currentUser?.uid).update({key: value});
  }

  Future<void> createUser(String name, String email, String phoneNumber,
      String password, UserCredential value) async {
    _db
        .doc(value.user?.uid)
        .set({
          "Email": email,
          "Name": name,
          "Phone Number": phoneNumber,
          "Password": password,
          "profile_pic": "",
          "Liked Me": [],
          "Liked By Me": [],
          "Mutual Friends": [],
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  getData() async {}

  //this method is called when current user(email) liked other person(s).
  //First checks if other person(s) also liked current user(email). If yes, then both's mutual friends field will be updated.
  //else only liked me of other person(s) will be updated with current user(email).
  Future<void> addToFriend(
      String other_email, String cur_email, Profile profile) async {
    print("This function called!!!");
    //retrieving details of other person(s) field..
    QuerySnapshot snapshot_other =
        await _db.where("Email", isEqualTo: other_email).get();
    QuerySnapshot snapshot_cur =
        await _db.where("Email", isEqualTo: cur_email).get();
    DocumentSnapshot document_other = snapshot_other.docs[0];
    DocumentSnapshot document_cur = snapshot_cur.docs[0];
    final id_cur = document_cur.id;
    final id_other = document_other.id;
    for (int i = 0; i < 3; i++) {
      print("Hi");
    }
    //print(document_cur.get("Liked Me").runtimeType);
    List<dynamic> liked_by_me_cur = document_cur.get("Liked By Me") ?? [];
    liked_by_me_cur.add(other_email);
    _db
        .doc(id_cur)
        .update({"Liked By Me": FieldValue.arrayUnion(liked_by_me_cur)}).then(
            (value) => print("Liked By Me Updated_cur"));
    List<dynamic> likedMe_cur = document_cur.get("Liked Me") ?? [];
    List<dynamic> likedMe_other = document_other.get("Liked Me") ?? [];

    profile.other.remove(document_other.get("profile_pic"));
    profile.other_names.remove(document_other.get("Email"));
    profile.name_all_others.remove(document_other.get("Name"));
    profile.other_user_info.removeWhere(
        (element) => element["Email"] == document_other.get("Email"));

    print("Liked Me_cur: ${likedMe_cur}");
    print("Liked Me_other: ${likedMe_other}");

    print("Checking if there is a chance to be mutual");
    if (likedMe_cur.contains(other_email)) {
      print("Both are seems to be mutually liked. Let us update both's mutual");
      profile.mutualFriendsInfo.add({
        "Name": document_other.get("Name"),
        "Email": document_other.get("Email"),
        "URL": document_other.get("profile_pic"),
      });

      print("Liked Me for now_cur: ${likedMe_cur}");
      print("Liked Me for now_other: ${likedMe_other}");

      print("ID of current: ${id_cur}");
      print("ID of other: ${id_other}");
      _db.doc(id_cur).update({
        "Mutual Friends": FieldValue.arrayUnion([other_email])
      }).then((value) => print("Mutual Array updated_cur"));
      _db.doc(id_other).update({
        "Mutual Friends": FieldValue.arrayUnion([cur_email])
      }).then((value) => print("Mutual Array updated_other"));
      _db.doc(id_cur).update({
        "Liked Me": FieldValue.arrayRemove([other_email])
      }).then((value) => print("Liked Array updated_cur"));

      profile.addmutualFriend(other_email);
    } else {
      print("Seems to be other not liked current. Let's update other liked me");
      likedMe_other.add(cur_email);
      _db
          .doc(id_other)
          .update({"Liked Me": FieldValue.arrayUnion(likedMe_other)}).then(
        (value) => print("Liked Me Array updated_other"),
      );
      profile.addFriend(other_email);
    }
  }
}
