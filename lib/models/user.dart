import 'package:cloud_firestore/cloud_firestore.dart';

class TheUser{
  final String uid;

  TheUser({required this.uid});
}

class LastField{
static final String lastMessageTime = 'lastMessageTime';
}


class UserData{
  final String username;
  final String urlAvatar;
  final String uid;
  final Timestamp lastMessageTime;

  UserData({
    required this.lastMessageTime, 
    required this.uid,
    required this.username, 
    required this.urlAvatar});
}