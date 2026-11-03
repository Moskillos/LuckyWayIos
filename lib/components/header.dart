import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucky_way_ios/costants/loading_equipments.dart';
import 'package:lucky_way_ios/costants/text_style.dart';
import 'package:lucky_way_ios/models/chat_model.dart';
import 'package:lucky_way_ios/upload_image.dart';
import 'package:lucky_way_ios/utils/image_picker.dart';
import 'package:provider/provider.dart';
import '../database.dart';
import '../models/user_model.dart';
import '../store/app_state.dart';

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return Row(
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
        Text(user is LegalPerson
            ? user.companyName
            : '${user.name} ${user.lastName}', style: blueText16w700,),
      ],
    );
  }
}
