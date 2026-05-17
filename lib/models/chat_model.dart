

import 'package:lucky_way_ios/models/user_model.dart';

class ChatUser{
  String id;
  UserType userType;
  String fullName;
  String profileImage;

  ChatUser(this.id, this.userType, this.fullName, this.profileImage);
}

class ChatMessage{
  String id;
  String senderId;
  String content;
  String timeStamp;
  bool read;
  bool? answered;
  String? expedition;
  String? offer;
  String? track;


  ChatMessage(this.id, this.senderId, this.content, this.timeStamp, this.read,  {this.answered, this.expedition, this.offer, this.track});
}

class ChatModel{
  String id;
  List<ChatUser> participants;
  String lastMessage;
  String timeStamp;
  List<ChatMessage> messages;

  ChatModel(this.id, this.participants, this.lastMessage, this.timeStamp, this.messages);
}