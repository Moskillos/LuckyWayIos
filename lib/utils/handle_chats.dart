
import '../database.dart';
import '../models/chat_model.dart';

Future<List<ChatModel>> handleChats(chats) async {
  List<ChatModel> chatList = [];
  for (var chat in chats) {
    ChatModel e = await FirebaseDatabase().getChat(chat);
    chatList.add(e);
  }
  return chatList;
}