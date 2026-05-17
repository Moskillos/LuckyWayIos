import 'package:flutter/material.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../database.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/chat_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';
import '../../utils/date_format.dart';
import '../../utils/send_notifications.dart';

class UpdateTrackState extends StatefulWidget {
  final TrackModel track;
  const UpdateTrackState({super.key, required this.track});

  @override
  State<UpdateTrackState> createState() => _UpdateTrackStateState();
}

class _UpdateTrackStateState extends State<UpdateTrackState> {
  bool started = false;
  bool completed = false;
  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return LuckyWayLayout(
        isNavigate: true,
        showHeader: true,
        title: AppLocalizations.of(context).translate("updateStatus"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).translate("updateTrackStatus"), style: greyText18, textAlign: TextAlign.start,),
              SizedBox(height: 20,),
              Column(
                children: [
                  SizedBox(height: 10,),
                  CustomDivider(color: grey,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).translate("yourTrackStarted"), style: blackText14w700),
                      Switch(
                        value: started,
                        onChanged: (bool value) async {
                          setState(() {
                            started = value;
                          });
                          if (started) {

                            await FirebaseDatabase().setTrackState(widget.track.id, TrackStates.STARTED);

                            for(var expedition in widget.track.expeditions){
                              if(expedition.paid){
                                var uuid = Uuid();
                                String chatMessageId =
                                    'MESS${uuid.v4().substring(0, 8)}';

                                String timeStamp = timeFormat(DateTime.now());

                                ChatMessage firstMessage = ChatMessage(
                                  chatMessageId,
                                  user.id,
                                  AppLocalizations.of(context)
                                      .translate("journeyBegun"),
                                  timeStamp,
                                  true,

                                );
                                for(var chat in user.chats){
                                  for(var partecipant in chat.participants){
                                    if(partecipant.id == expedition.owner.id){

                                      Provider.of<AppState>(context, listen: false)
                                          .addMessageToChat(chat.id, firstMessage);
                                      await sendNotification(
                                          expedition.owner.token,
                                          '${user.name} ${user.lastName}',
                                          firstMessage.content,
                                          chat.id,
                                          null);

                                    }
                                  }
                                }
                              } else {
                                Provider.of<AppState>(context, listen: false).deleteExpeditionFromTrack(widget.track, expedition);
                              }
                            }





                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: primaryBlue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        trackOutlineColor: MaterialStateProperty.all(Colors.black), // <-- Colore bordo track
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  CustomDivider(color: grey,),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).translate("yourTrackCompleted"), style: blackText14w700),
                      Switch(
                        value: completed,
                        onChanged: (bool value) async {
                          setState(() {
                            completed = value;
                          });
                          if(completed){
                            await FirebaseDatabase().setTrackState(widget.track.id, TrackStates.COMPLETED);
                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: primaryBlue,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey,
                        trackOutlineColor: MaterialStateProperty.all(Colors.black), // <-- Colore bordo track
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        button: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(text: AppLocalizations.of(context).translate("goBack"), backgroundColor: Colors.black, textStyle: whiteText14w700, icon: 'assets/back-arrow.svg', onPressed: (){
              Navigator.of(context).pop();
            }),
          ],
        ));
  }
}
