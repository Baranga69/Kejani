
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageField{
  static final String createdAt = 'createdAt';
}

class Message{
  final String userId;
  final String avatarUrl;
  final String message;
  final Timestamp createdAt;

 const Message({
   required this.userId,
   required this.avatarUrl,
   required this.message, 
   required this.createdAt});
}