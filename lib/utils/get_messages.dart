import 'package:cloud_firestore/cloud_firestore.dart';

Stream<QuerySnapshot> getMessages(String chatId) {
  return FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots();
}