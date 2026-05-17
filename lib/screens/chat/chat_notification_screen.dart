import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/chat_model.dart';
import '../../models/expedition_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../ui/cards/expedition_card.dart';
import '../../utils/date_format.dart';

class ChatNotificationScreen extends StatefulWidget {
  const ChatNotificationScreen({super.key});

  @override
  State<ChatNotificationScreen> createState() => _ChatNotificationScreenState();
}

class _ChatNotificationScreenState extends State<ChatNotificationScreen> {
  String chat = '';
  String message = '';
  String expeditionId = '';
  String offer = '';
  ExpeditionModel? expedition;


  void setMessage(String value){
    setState(() {
      message = value;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print(ModalRoute.of(context)?.settings.arguments);
    final String payload =
        ModalRoute.of(context)?.settings.arguments as String? ?? "";
    if (payload.isNotEmpty) {
      final data = jsonDecode(payload);
      if (data != null) {
        setState(() {
          chat = data['chatId'];
        });
        if(data['expeditionId'] != null){
          ExpeditionModel expeditionModel = await FirebaseDatabase().getExpedition(data['expeditionId'], null);
          setState(() {
            expedition = expeditionModel;
          });
        }
      }
    }
  }

  Widget messageRender(ChatMessage message){
    if(message.expedition != null){
      return Column(
        children: [
          ExpeditionCard(expedition: expedition!, setExpedition: (){}, isDriver: true, changePage: (){}),
          Row(
            children: [
              InkWell(
                onTap: (){},
                child: Text(AppLocalizations.of(context).translate("yes")),
              ),
              InkWell(
                onTap: (){},
                child: Text(AppLocalizations.of(context).translate("no")),
              )
            ],
          )
        ],
      );
    } else if(message.offer != null){
      return Container(
        child: Row(
          children: [
            InkWell(
              onTap: (){},
              child: Text(AppLocalizations.of(context).translate("yes")),
            ),
            InkWell(
              onTap: (){},
              child: Text(AppLocalizations.of(context).translate("no")),
            )
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    ChatModel chatShow = user.chats.where((chat) => chat.id == chat).toList()[0];

    return LuckyWayLayout(
      title: AppLocalizations.of(context).translate("chat"),
      button: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 40),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: primaryBlue, width: 2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 2),
                  child: TextFormField(
                    style: blueText14w700,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                      hintStyle: greyText18,
                    ),
                    onChanged: (value) {
                      setMessage(value);
                    },
                    validator: (value) {

                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            // Icona di invio
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: primaryBlue, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: InkWell(
                onTap: (){
                  var uuid = Uuid();
                  String chatMessageId = 'MESS${uuid.v4().substring(0, 8)}';
                  ChatMessage m = ChatMessage(chatMessageId, user.id, message, timeFormat(DateTime.now()), true);
                  Provider.of<AppState>(context, listen: false).addMessageToChat(chat, m);
                },
                child: SvgPicture.asset(
                  'assets/send.svg',
                  color: primaryBlue,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
            SizedBox(width: 15),
          ],
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: Column(
          children: [
            Column(
              children: List.generate(
                  chatShow.messages.length,
                      (index) => Align(
                    alignment:
                    user.id == chatShow.messages[index].senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: user.id ==
                              chatShow.messages[index].senderId
                              ? Colors.white
                              : primaryBlue,
                          border: user.id ==
                              chatShow.messages[index].senderId
                              ? Border.all(color: primaryBlue, width: 2)
                              : null,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topLeft: user.id ==
                                chatShow.messages[index].senderId
                                ? Radius.circular(20)
                                : Radius.circular(0),
                            topRight: user.id ==
                                chatShow.messages[index].senderId
                                ? Radius.circular(0)
                                : Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          Text(
                            chatShow.messages[index].content,
                            style:
                            user.id == chatShow.messages[index].senderId
                                ? blackText14
                                : whiteText14,
                          ),
                          messageRender(chatShow.messages[index])
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      showHeader: true,
      isNavigate: true,
    );
  }
}
