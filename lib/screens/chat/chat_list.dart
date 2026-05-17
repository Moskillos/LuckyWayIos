import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../utils/handle_chats.dart';
import 'chat_screen.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final CollectionReference<Map<String, dynamic>> _physicPersonsCollection = FirebaseFirestore.instance.collection('physicPersons');
  final CollectionReference<Map<String, dynamic>> _legalPersonsCollection =
  FirebaseFirestore.instance.collection('legalPersons');
  final CollectionReference<Map<String, dynamic>> _truckDriversCollection = FirebaseFirestore.instance.collection('truckDrivers');

  Stream<DocumentSnapshot<Map<String, dynamic>>> collection(String userId,UserBase user){
    if(user is TruckDriverModel){
      return _truckDriversCollection.doc(userId).snapshots();
    } else if(user is LegalPerson){
      return _legalPersonsCollection.doc(user.id).snapshots();
    } else {
      return _physicPersonsCollection.doc(user.id).snapshots();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserChatsStream(
      String userId, UserBase user) {
    final userStream = collection(userId, user);
    final chatsStream =
    FirebaseFirestore.instance.collection('chats').snapshots();

    return Rx.combineLatest2(userStream, chatsStream, (user, chat) => user);
  }

  Widget chatItem(ChatModel chat, UserBase user){
    for (var p in chat.participants) {
      if (p.id != user.id) {
        return Column(
          children: [
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(chat: chat.id,)),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/user.svg',
                        color: primaryBlue,
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.fullName, style: blackText14w700,),
                          Text(chat.lastMessage.length > 30 ? '${chat.lastMessage.substring(0, 30)}...' : chat.lastMessage, style: greyText12,)
                        ],
                      ),
                    ],
                  ),
                  Text(chat.timeStamp, style: greyText18,)
                ],
              ),
            ),
          ],
        );
      }
    }
    // Se non trova nessuno o se l'utente è l'unico partecipante
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: getUserChatsStream(user.id, user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox();
          }
          if (snapshot.hasError) {
            return const SizedBox();
          }
          if (!snapshot.hasData || snapshot.data!.data()!.isEmpty) {
            return const SizedBox();
          }
          final userData = snapshot.data!.data();
          return FutureBuilder<List<ChatModel>>(
            future: handleChats(userData!['chats']),
            builder: (context, futureSnapshot) {
              if (futureSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: Column(
                  children: [
                    SizedBox(height: 30,),
                    CircularProgressIndicator(),
                  ],
                ));
              }
              if (futureSnapshot.hasError) {
                return Center(
                    child: Text(AppLocalizations.of(context).translate("noChats"), style: greyText18,));
              }
              if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Center(child: Text(AppLocalizations.of(context).translate("noChats"), style: greyText18, textAlign: TextAlign.start,)),
                );
              }

              List<ChatModel> chatsMapped = futureSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: chatsMapped.length,
                  itemBuilder: (context, index) {
                    return chatItem(chatsMapped[index], user);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
