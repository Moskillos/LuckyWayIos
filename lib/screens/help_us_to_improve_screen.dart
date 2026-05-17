import 'package:flutter/material.dart';
import 'package:lucky_way_ios/database.dart';
import 'package:lucky_way_ios/models/improve_request_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:lucky_way_ios/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../app_localizations.dart';
import '../costants/request_types.dart';

class HelpUsToImproveScreen extends StatefulWidget {
  const HelpUsToImproveScreen({super.key});

  @override
  State<HelpUsToImproveScreen> createState() => _HelpUsToImproveScreenState();
}

class _HelpUsToImproveScreenState extends State<HelpUsToImproveScreen> {
  TextEditingController controller = TextEditingController();
  String message = '';
  AnimationController? localAnimationController;
  String type = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ora possiamo accedere a context in sicurezza
    setState(() {
      type = requestTypes(context)[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(AppLocalizations.of(context)
              .translate("helpUsImproveTitlePage")),
          DropdownButton<String>(
            value: type,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            isExpanded: true,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                type = value!;
              });
            },
            items: requestTypes(context).map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextField(
            controller: controller,
            minLines: 5,
            maxLines: 10,
            onChanged: (String value){
              setState(() {
                message = value;
              });
            },
          ),
          ElevatedButton(onPressed: ()async{
            ImproveRequestModel request = ImproveRequestModel(const Uuid().v4(), type, message, user.id);
            await FirebaseDatabase().saveImproveRequest(request);
            showSuccessSnackBar(context, localAnimationController, AppLocalizations.of(context)
                .translate("messageSent"));
            Navigator.of(context).pop();
          }, child: Text(AppLocalizations.of(context)
              .translate("sendMessage")))
        ],
      ),
    );
  }
}
