
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../costants/text_style.dart';
import '../database.dart';
import '../models/chat_model.dart';
import '../models/user_model.dart';
import '../store/app_state.dart';
import '../upload_image.dart' show uploadImageProfileToFirebase;
import '../utils/handle_chats.dart';
import '../utils/image_picker.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? _userCollection;

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    if(user is TruckDriverModel){
      setState(() {
        _userCollection = FirebaseFirestore.instance.collection('truckDrivers').doc(user.id).snapshots();
      });
    } else if(user is LegalPerson){
      setState(() {
        _userCollection = FirebaseFirestore.instance.collection('legalPersons').doc(user.id).snapshots();
      });
    } else if(user is PhysicPerson){
      setState(() {
        _userCollection = FirebaseFirestore.instance.collection('physicPersons').doc(user.id).snapshots();
      });
    }

    Widget emptyHeader(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  XFile? imagePicked = await pickImage();
                  if (imagePicked != null) {
                    String? imageUploaded = await uploadImageProfileToFirebase(imagePicked);
                    if (imageUploaded != null) {
                      Provider.of<AppState>(context, listen: false).saveUserImage(imageUploaded);
                    }
                  }
                },
                child: user.profileImage.isNotEmpty
                    ? Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Image.network(user.profileImage, width: 60, height: 60, fit: BoxFit.cover),
                )
                    : SvgPicture.asset(
                  'assets/user.svg',
                  height: 60,
                  width: 40,
                ),
              ),
              const SizedBox(width: 20),
              Text('${user.name} ${user.lastName}', style: blueText16w700,),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none, // Permette ai figli di uscire fuori dai limiti del genitore
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //       builder: (context) => ChatList()),
                      // );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none, // Permette al contenuto di uscire
                      children: [
                        SvgPicture.asset(
                          'assets/message.svg',
                          height: 40,
                          width: 40,
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ],
          )

        ],
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _userCollection,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return emptyHeader();
        }
        if (snapshot.hasError) {
          return emptyHeader();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return emptyHeader();
        }

        final userData = snapshot.data!.data();

        if (userData == null || userData.isEmpty) {
          return emptyHeader();
        }

        return FutureBuilder<List<ChatModel>>(
          future: handleChats(userData!['chats']),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return emptyHeader();
            }
            if (futureSnapshot.hasError) {
              return emptyHeader();
            }
            if (!futureSnapshot.hasData || futureSnapshot.data!.isEmpty) {
              return emptyHeader();
            }

            List<ChatModel> chats = futureSnapshot.data!;

            List<ChatModel> notReadchats(){
              List<ChatModel> notRead = [];

              for(var chat in chats){
                List<ChatMessage> messages = chat.messages.where((message) => message.senderId != userData['id']).toList();

                for(var m in messages){
                  if(m.read == false){
                    notRead.add(chat);
                  }
                }
              }
              return notRead;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        XFile? imagePicked = await pickImage();
                        if (imagePicked != null) {
                          String? imageUploaded = await uploadImageProfileToFirebase(imagePicked);
                          if (imageUploaded != null) {
                            Provider.of<AppState>(context, listen: false).saveUserImage(imageUploaded);
                          }
                        }
                      },
                      child: user.profileImage.isNotEmpty
                          ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Image.network(user.profileImage, width: 60, height: 60, fit: BoxFit.cover),
                      )
                          : SvgPicture.asset(
                        'assets/user.svg',
                        height: 60,
                        width: 60,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text('${user.name} ${user.lastName}', style: blueText16w700,),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none, // Permette ai figli di uscire fuori dai limiti del genitore
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //       builder: (context) => ChatList()),
                            // );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none, // Permette al contenuto di uscire
                            children: [
                              SvgPicture.asset(
                                'assets/message.svg',
                                height: 40,
                                width: 40,
                              ),

                            ],
                          ),
                        ),
                        Positioned(
                            top: -10,
                            right: -5,
                            child: notReadchats().length == 0 ? SizedBox() : Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                notReadchats().length.toString(),
                                style: blackText14,
                              ),
                            ))
                      ],
                    ),
                  ],
                )

              ],
            );
          },
        );
      },
    );
  }
}
