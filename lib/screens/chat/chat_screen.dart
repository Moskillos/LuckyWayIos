import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../components/header.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/chat_model.dart';
import '../../models/expedition_model.dart';
import '../../models/track_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';
import '../../utils/date_format.dart';
import '../../utils/get_messages.dart';
import '../../utils/mapper/chat_mapper.dart';
import '../../utils/send_notifications.dart';
import 'chat_text_input.dart';

class ChatScreen extends StatefulWidget {
  final String chat;
  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }


  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('chats').doc(widget.chat).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          final chatData = snapshot.data!.data();
          ChatModel chat = chatMapper(chatData!);
          List<ChatMessage> messages = chat.messages;
          List<ChatUser> partecipants = chat.participants;

          ChatUser talker = partecipants.where((p) => p.id != user.id).toList()[0];


          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 35),
                    Header(),
                    SizedBox(height: 30),
                    Text(
                      talker.fullName,
                      style: blackText28w700,
                    ),
                    SizedBox(height: 20),
                    CustomDivider(),
                  ],
                ),
              ),

              // 👇 Expanded prende tutto lo spazio disponibile
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(children: [
                        // 👇 Lista messaggi scrollabile
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context, index) {
                              final msg = messages[index];
                              final isUser = msg.senderId == user.id;

                              if (!msg.read && !isUser) {
                                FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(widget.chat)
                                    .update({
                                  'messages': FieldValue.arrayRemove([{
                                    "id": msg.id,
                                    "senderId": msg.senderId,
                                    "read": msg.read,
                                    "timestamp": msg.timeStamp,
                                    "content": msg.content,
                                  }]) // Rimuovi il messaggio vecchio
                                }).then((_) {
                                  final updatedMsg = {
                                    "id": msg.id,
                                    "senderId": msg.senderId,
                                    "read": true,
                                    "timestamp": msg.timeStamp,
                                    "content": msg.content,
                                  };
                                  FirebaseFirestore.instance
                                      .collection('chats')
                                      .doc(widget.chat)
                                      .update({
                                    'messages': FieldValue.arrayUnion([updatedMsg])
                                  });
                                });
                              }

                              return Align(
                                alignment: isUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color:
                                    isUser ? Colors.white : primaryBlue,
                                    border: isUser
                                        ? Border.all(
                                        color: primaryBlue, width: 2)
                                        : null,
                                    borderRadius: BorderRadius.only(
                                      topLeft:
                                      Radius.circular(isUser ? 20 : 0),
                                      topRight:
                                      Radius.circular(isUser ? 0 : 20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: ((msg.content == AppLocalizations.of(context).translate("newOffer") && (msg.answered != null && msg.answered! == false)) && !isUser) ? Column(
                                    children: [
                                      Text(
                                        msg.content,
                                        style:
                                        isUser ? blackText14 : whiteText14,
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        '${AppLocalizations.of(context).translate("offer")}: ${msg.offer!}€',
                                        style:
                                        isUser ? blackText14 : whiteText14,
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            '${AppLocalizations.of(context).translate("doYouAcceptOffer")}',
                                            style:
                                            isUser ? blackText14 : whiteText14,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await FirebaseDatabase().setMessageAnswered(chat.id, msg.id);
                                              TrackModel selectedTrack = await FirebaseDatabase().getTrack(msg.track!);
                                              ExpeditionModel selectedExpedition = await FirebaseDatabase().getExpedition(msg.expedition!, null);
                                              await Provider.of<AppState>(context, listen: false).addExpeditionToTrack(selectedTrack, selectedExpedition);
                                              var uuid = Uuid();
                                              String timeStamp = timeFormat(DateTime.now());
                                              String chatMessageId = 'MESS${uuid.v4().substring(0, 8)}';
                                              ChatMessage message = ChatMessage(chatMessageId, user.id, AppLocalizations.of(context).translate("offerAccepted"), timeStamp, true,answered: true);
                                              List<ChatMessage> messages = [
                                                message,
                                              ];
                                              await FirebaseDatabase().updateChat(chat.id, message);
                                              await sendNotification(selectedTrack.truckDriver.token, '${user.name} ${user.lastName}', messages.last.content, chat.id, null);
                                            },
                                            child: Text(AppLocalizations.of(context).translate("yes"), style: whiteText14w700,),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var uuid = Uuid();
                                              await FirebaseDatabase().setMessageAnswered(chat.id, msg.id);
                                              TrackModel selectedTrack = await FirebaseDatabase().getTrack(msg.track!);
                                              String timeStamp = timeFormat(DateTime.now());
                                              String chatMessageId = 'MESS${uuid.v4().substring(0, 8)}';
                                              ChatMessage message = ChatMessage(chatMessageId, user.id, AppLocalizations.of(context).translate("offerRefused"), timeStamp, true,answered: true);
                                              List<ChatMessage> messages = [
                                                message,
                                              ];
                                              await FirebaseDatabase().updateChat(chat.id, message);
                                              await sendNotification(selectedTrack.truckDriver.token, '${user.name} ${user.lastName}', messages.last.content, chat.id, null);
                                            },
                                            child: Text(AppLocalizations.of(context).translate("no"), style: whiteText14w700,),
                                          ),
                                        ],
                                      )

                                    ],
                                  ) : Text(
                                    msg.content,
                                    style:
                                    isUser ? blackText14 : whiteText14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ]))),

              // 👇 Campo di input + bottone invio
              ChatTextInput(chat: widget.chat,),
              SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
