

import '../../models/chat_model.dart';
import '../user_type_converter.dart';

ChatModel chatMapper(Map<String, dynamic> data){
  List<ChatUser> participants = [];
  List<ChatMessage> messages = [];

  if(data['participants'] is List && data['participants'].isNotEmpty){
    for(var participant in data['participants']){
      ChatUser user = ChatUser(participant['id'], userTypeConverter(participant['userType']), participant['fullName'], participant['profileImage']);
      participants.add(user);
    }
  }

  if(data['messages'] is List && data['messages'].isNotEmpty){
    for(var message in data['messages']){
      ChatMessage m = ChatMessage(message['id'], message['senderId'], message['content'], message['timestamp'], message['read'],answered: message['answered'], expedition: message['expedition'], track: message['track'], offer: message['offer']);
      messages.add(m);
    }
  }
  return ChatModel(data['id'], participants, data['lastMessage'], data['timestamp'], messages, );
}