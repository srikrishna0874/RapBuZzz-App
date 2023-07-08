import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intern/original/utils/firebase_service.dart';

class Profile {
  String name = "", email = "", phoneNumber = "", password = "";
  List<String> other = [];
  List<String> other_names = [];
  List<String> name_all_others = [];
  var tinder_map = new Map();
  late String profile_pic_url = "";
  String? id;
  List<dynamic> friends = [];
  List<dynamic> mutualFriends = [];
  List<dynamic> likedMe = [];

  List<String> mutualFriendsImageURLs = [];
  List<String> mutualFriendsNames = [];

  List<Map<String, String>> mutualFriendsInfo = [];
  List<Map<String, String>> likedMeInfo = [];
  bool hadImage = false;
  String errorMessage = "";

  ImagePicker picker = ImagePicker();

  final _db = FirebaseFirestore.instance.collection("UsersData");

  bool isFirst = true;

  List<Map<String, String>> other_user_info = [];
  List<Map<String, String>> mutualChatInfo = [];

  updateDetails(
      String name,
      String email,
      String phoneNumber,
      String password,
      String url,
      List<dynamic> friends,
      List<dynamic> likedMe,
      List<dynamic> mutualFriends) {
    FireBaseServices().updateData("Name", name);
    FireBaseServices().updateData("Email", email);
    FireBaseServices().updateData("Phone Number", phoneNumber);
    this.name = name;
    this.email = email;
    this.phoneNumber = phoneNumber;
    this.password = password;
    this.profile_pic_url = url;
    this.friends = friends;
    this.mutualFriends = mutualFriends;
    this.likedMe = likedMe;
  }

  addFriend(String name) {
    friends.add(name);
  }

  addmutualFriend(String name) {
    mutualFriends.add(name);
  }

  getOthers() {
    print(this.other);
  }
}
