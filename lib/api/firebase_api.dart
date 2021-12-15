import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:another_nav_bar/models/message.dart';

class FirebaseApi{
  

  // static Future uploadMessage(String userId, String message) async {
  //   final refMessages = FirebaseFirestore.instance.collection('chat_logs/$userId/messages');

  //   final newMessage = Message(
  //     userId: userId,
  //     avatarUrl: avatarUrl,
  //     username: username,
  //     message: message,
  //     createdAt: DateTime.now(),
  //   );
  //   await refMessages.add(newMessage.toJson());

  //   final refUsers = FirebaseFirestore.instance.collection('Kejani Users');
  //   await refUsers
  //       .doc(userId)
  //       .update({UserField.lastMessageTime: DateTime.now()});
  // }

  // static Stream<List<Message>> getMessage(String userId)=>
  // FirebaseFirestore.instance
  // .collection('chat_logs/$userId/messages')
  // .orderBy(MessageField.createdAt,descending: true)
  // .snapshots()
  // .transform(Utils.transformer(Message.fromJson));
}