import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../store/app_state.dart';
import '../../utils/date_format.dart';

class ChatTextInput extends StatefulWidget {
  final String chat;
  const ChatTextInput({super.key, required this.chat});

  @override
  State<ChatTextInput> createState() => _ChatTextInputState();
}

class _ChatTextInputState extends State<ChatTextInput> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: primaryBlue, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  style: blueText14w700,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '',
                    hintStyle: greyText18,
                  ),
                  onChanged: (value) {
                    setState(() {
                      message = value;
                    });
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primaryBlue, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: InkWell(
              onTap: () {
                if (message.trim().isEmpty) return;

                final uuid = Uuid();
                final newMessage = ChatMessage(
                  'MESS${uuid.v4().substring(0, 8)}',
                  user.id,
                  message.trim(),
                  timeFormat(DateTime.now()),
                  false,
                );

                Provider.of<AppState>(context, listen: false)
                    .addMessageToChat(widget.chat, newMessage);
                },
              child: SvgPicture.asset(
                'assets/send.svg',
                color: primaryBlue,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
