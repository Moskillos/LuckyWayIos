import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucky_way_ios/components/expeditions/articles_dimensions.dart';
import 'package:lucky_way_ios/components/expeditions/destination_address.dart';
import 'package:lucky_way_ios/components/expeditions/expedition_offer.dart';
import 'package:lucky_way_ios/components/expeditions/expedition_summary.dart';
import 'package:lucky_way_ios/components/expeditions/merchandise_choose.dart';
import 'package:lucky_way_ios/components/expeditions/other_questions.dart';
import 'package:lucky_way_ios/components/expeditions/address_handler_form.dart';
import 'package:lucky_way_ios/components/expeditions/publish_expedition.dart';
import 'package:lucky_way_ios/components/expeditions/sender_receiver_choose_widget.dart';
import 'package:lucky_way_ios/layout/lucky_way_layout.dart';
import 'package:lucky_way_ios/layout/page_view_builder_layout.dart';
import 'package:lucky_way_ios/models/package_model.dart';
import 'package:lucky_way_ios/models/track_model.dart';
import 'package:lucky_way_ios/models/user_model.dart';
import 'package:lucky_way_ios/screens/success_screen.dart';
import 'package:lucky_way_ios/store/app_state.dart';
import 'package:lucky_way_ios/utils/date_format.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../models/address_model.dart';
import '../../models/expedition_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../utils/popupValidation.dart';

class NewExpeditionScreen extends StatefulWidget {
  TrackModel? track;
  NewExpeditionScreen({super.key, this.track});

  @override
  State<NewExpeditionScreen> createState() => _NewExpeditionScreenState();
}

class _NewExpeditionScreenState extends State<NewExpeditionScreen> {
  PageController pageController = PageController();
  String userRole = 'sender';
  int step = 0;

  //indirizzo di ritiro
  String? selectedCity;
  String? selectedStreet;
  String? selectedNumber;
  String? selectedPostalCode;
  String? selectedProvince;
  String senderPhone = '';
  String senderEmail = '';

  String retireNotes = '';
  String senderName = '';

  // indirizzo di destinazione
  String? selectedDestinationCity;
  String? selectedDestinationStreet;
  String? selectedDestinationNumber;
  String? selectedDestinationPostalCode;
  String? selectedDestinationProvince;
  String recipientName = '';
  String destinationNotes = '';
  String recipientPhone = '';
  String recipientEmail = '';

  //offerta
  int offer = 0;
  String specialRequest = '';

  // tipo di merce
  String merchandiseSelected = '';

  // dimensioni articolo
  List<PackageModel> articles = [];
  TextEditingController _nameArticleController = TextEditingController();
  TextEditingController _widthArticleController = TextEditingController();
  TextEditingController _lengthArticleController = TextEditingController();
  TextEditingController _heightArticleController = TextEditingController();
  TextEditingController _weightArticleController = TextEditingController();
  String nameArticle = '';
  int widthArticle = 0;
  int lengthArticle = 0;
  int heightArticle = 0;
  int weightArticle = 0;

  //altro
  String equip = '';
  bool isFlammable = false;
  bool isFragile = false;

  void setSenderRole(String role) {
    setState(() {
      userRole = role;
    });
  }

  void changePage() {
    setState(() {
      step = step + 1;
    });
    pageController.jumpToPage(step);
  }

  void setCity(String value) {
    setState(() {
      selectedCity = value;
    });
  }

  void setStreet(String value) {
    setState(() {
      selectedStreet = value;
    });
  }

  void setCivicNumber(String value) {
    setState(() {
      selectedNumber = value;
    });
  }

  void setPostalCode(String value) {
    setState(() {
      selectedPostalCode = value;
    });
  }

  void setProvince(String value) {
    setState(() {
      selectedProvince = value;
    });
  }

  void setRecipientName(String value) {
    setState(() {
      recipientName = value;
    });
  }

  void setSenderName(String value) {
    setState(() {
      senderName = value;
    });
  }

  void setRetireNotes(String value) {
    setState(() {
      retireNotes = value;
    });
  }

  void setDestinationNotes(String value) {
    setState(() {
      destinationNotes = value;
    });
  }

  void setDestinationCity(String value) {
    setState(() {
      selectedDestinationCity = value;
    });
  }

  void setDestinationStreet(String value) {
    setState(() {
      selectedDestinationStreet = value;
    });
  }

  void setDestinationCivicNumber(String value) {
    setState(() {
      selectedDestinationNumber = value;
    });
  }

  void setDestinationPostalCode(String value) {
    setState(() {
      selectedDestinationPostalCode = value;
    });
  }

  void setDestinationProvince(String value) {
    setState(() {
      selectedDestinationProvince = value;
    });
  }

  void setOffer(String value) {
    setState(() {
      offer = int.parse(value);
    });
  }

  void setSpecialRequest(String value) {
    setState(() {
      specialRequest = value;
    });
  }

  void setMerchandise(String value) {
    setState(() {
      merchandiseSelected = value;
    });
  }

  void addArticle(PackageModel article) {
    setState(() {
      articles.add(article);
    });
  }

  void setNameArticle(String value) {
    setState(() {
      nameArticle = value;
    });
  }

  void setWidthArticle(String value) {
    setState(() {
      widthArticle = int.parse(value);
    });
  }

  void setHeightArticle(String value) {
    setState(() {
      heightArticle = int.parse(value);
    });
  }

  void setWeightArticle(String value) {
    setState(() {
      weightArticle = int.parse(value);
    });
  }

  void setLengthArticle(String value) {
    setState(() {
      lengthArticle = int.parse(value);
    });
  }

  void setEquip(String value) {
    setState(() {
      equip = value;
    });
  }

  void setIsFlammable() {
    setState(() {
      isFlammable = !isFlammable;
    });
  }

  void setIsFragile() {
    setState(() {
      isFragile = !isFragile;
    });
  }

  void setSenderPhone(String value) {
    setState(() {
      senderPhone = value;
    });
  }

  void setSenderEmail(String value) {
    setState(() {
      senderEmail = value;
    });
  }

  void setRecipientPhone(String value) {
    setState(() {
      recipientPhone = value;
    });
  }

  void setRecipientEmail(String value) {
    setState(() {
      recipientEmail = value;
    });
  }

  int savePackage() {
    print("seaeada");
    print(nameArticle);
    if(nameArticle.isEmpty){
      popUpValidation(
          AppLocalizations.of(context).translate("name"),
          context
      );
      return 0;
    }
    if(widthArticle == 0){
      popUpValidation(
          AppLocalizations.of(context).translate("width"),
          context
      );
      return 0;
    }
    if(lengthArticle == 0){
      popUpValidation(
          AppLocalizations.of(context).translate("length"),
          context
      );
      return 0;
    }
    if(heightArticle == 0){
      popUpValidation(
          AppLocalizations.of(context).translate("height"),
          context
      );
      return 0;
    }
    if(weightArticle == 0){
      popUpValidation(
          AppLocalizations.of(context).translate("weight"),
          context
      );
      return 0;
    }

    PackageModel package = PackageModel(
        nameArticle,
        lengthArticle,
        widthArticle,
        heightArticle,
        weightArticle,
        isFlammable,
        isFragile,
        merchandiseSelected);
    setState(() {
      articles.add(package);
      nameArticle = '';
      lengthArticle = 0;
      widthArticle = 0;
      heightArticle = 0;
      weightArticle = 0;
      isFlammable = false;
      isFragile = false;
      _nameArticleController.text = '';
      _lengthArticleController.text = '';
      _widthArticleController.text = '';
      _heightArticleController.text = '';
      _weightArticleController.text = '';
    });

    return 1;
  }

  void goToNewArticle() {
    setState(() {
      step = step - 4;
    });
    pageController.jumpToPage(step);
  }

  @override
  Widget build(BuildContext context) {
    UserBase user = Provider.of<AppState>(context).user;

    List<Widget> pages = [
      SenderReceiverChooseWidget(
          userRole: userRole, setUserRole: setSenderRole),
      AddressHandlerForm(
        setName: setSenderName,
        setNotes: setRetireNotes,
        selectedCity: selectedCity,
        selectedStreet: selectedStreet,
        selectedPostalCode: selectedPostalCode,
        selectedNumber: selectedNumber,
        selectedProvince: selectedProvince,
        setCity: setCity,
        setStreet: setStreet,
        setCivicNumber: setCivicNumber,
        setPostalCode: setPostalCode,
        setProvince: setProvince,
        userRole: userRole,
        setSenderEmail: setSenderEmail,
        setSenderPhone: setSenderPhone,
        setRecipientEmail: setRecipientEmail,
        setRecipientPhone: setRecipientPhone,
        isRetire: true,
      ),
      AddressHandlerForm(
        setName: setRecipientName,
        setNotes: setDestinationNotes,
        selectedCity: selectedDestinationCity,
        selectedStreet: selectedDestinationStreet,
        selectedPostalCode: selectedDestinationPostalCode,
        selectedNumber: selectedDestinationNumber,
        selectedProvince: selectedDestinationProvince,
        setCity: setDestinationCity,
        setStreet: setDestinationStreet,
        setCivicNumber: setDestinationCivicNumber,
        setPostalCode: setDestinationPostalCode,
        setProvince: setDestinationProvince,
        userRole: userRole,
        setSenderEmail: setSenderEmail,
        setSenderPhone: setSenderPhone,
        setRecipientEmail: setRecipientEmail,
        setRecipientPhone: setRecipientPhone,
        isRetire: false,
      ),
      ExpeditionOffer(setOffer: setOffer, setSpecialRequest: setSpecialRequest),
      MerchandiseChoose(
          merchandiseSelected: merchandiseSelected,
          setMerchadiseSelected: setMerchandise),
      ArticlesDimensions(
          addArticle: addArticle,
          weightArticleController: _weightArticleController,
          nameArticleController: _nameArticleController,
          widthArticleController: _widthArticleController,
          lengthArticleController: _lengthArticleController,
          heightArticleController: _heightArticleController,
          setNameArticle: setNameArticle,
          setWidthArticle: setWidthArticle,
          setHeightArticle: setHeightArticle,
          setWeightArticle: setWeightArticle,
          setLengthArticle: setLengthArticle),
      OtherQuestions(
          setEquip: setEquip,
          setIsFlammable: setIsFlammable,
          setIsFragile: setIsFragile,
          isFragile: isFragile,
          isFlammable: isFlammable),
      ExpeditionSummary(
          retireCity: selectedCity ?? '',
          destinationCity: selectedDestinationCity ?? '',
          senderName: userRole == "sender"
              ? "${user.name} ${user.lastName}"
              : senderName,
          articles: articles,
          retireStreet: selectedStreet ?? '',
          retireNumber: selectedNumber ?? '',
          retireCap: selectedPostalCode ?? '',
          retireProvince: selectedProvince ?? '',
          destinationStreet: selectedDestinationStreet ?? '',
          destinationNumber: selectedDestinationNumber ?? '',
          destinationCap: selectedDestinationPostalCode ?? '',
          destinationProvince: selectedDestinationProvince ?? '',
          recipientName: userRole == "recipient"
              ? "${user.name} ${user.lastName}"
              : recipientName,
          offer: offer,
          merchandise: merchandiseSelected,
          flammable: isFlammable,
          fragile: isFragile,
          userRole: userRole,
          senderPhone: senderPhone,
          senderEmail: senderEmail,
          recipientPhone: recipientPhone,
          recipientEmail: recipientEmail,
          changePage: changePage),
      SuccessScreen(
          title:
          AppLocalizations.of(context).translate("articleInsertSuccess")),
      PublishExpedition(articles: articles, goToNewArticle: goToNewArticle),
      SuccessScreen(
        title:
        AppLocalizations.of(context).translate("expeditionInsertSuccess"),
        description: AppLocalizations.of(context).translate("waitADriver"),
      )
    ];

    return LuckyWayLayout(
        isNavigate: true,
        hidePadding: (step == 8 || step == 10) ? true : null,
        hideTitle: (step == 8 || step == 10) ? true : null,
        title: AppLocalizations.of(context).translate("newExpedition"),
        button: step != 7
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 30,
            ),
            LuckywayBtn(
                icon: step == 9 ? 'assets/send.svg' : null,
                text: AppLocalizations.of(context)
                    .translate(step == 9 ? "publishExpedition" : "goOn"),
                backgroundColor: Colors.black,
                textStyle: whiteText14w700,
                onPressed: () {
                  if(step == 1){
                    if(userRole == "sender"){
                      if(selectedCity != null && selectedCity!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("city"),
                            context
                        );
                      }
                      if(selectedStreet != null && selectedStreet!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("street"),
                            context
                        );
                      }
                      if(selectedNumber != null && selectedNumber!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("number"),
                            context
                        );
                      }
                      if(selectedProvince != null && selectedProvince!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("province"),
                            context
                        );
                      }
                      if(selectedPostalCode != null && selectedPostalCode!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("postalCode"),
                            context
                        );
                      }
                    } else {
                      if(selectedDestinationCity != null && selectedDestinationCity!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("city"),
                            context
                        );
                      }
                      if(selectedDestinationStreet != null && selectedDestinationStreet!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("street"),
                            context
                        );
                      }
                      if(selectedDestinationNumber != null && selectedDestinationNumber!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("number"),
                            context
                        );
                      }
                      if(selectedDestinationProvince != null && selectedDestinationProvince!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("province"),
                            context
                        );
                      }
                      if(selectedDestinationPostalCode != null && selectedDestinationPostalCode!.isEmpty){
                        popUpValidation(
                            AppLocalizations.of(context).translate("postalCode"),
                            context
                        );
                      }
                    }
                  }
                  if (step == 2) {
                    if(recipientName.isEmpty){
                      popUpValidation(
                          AppLocalizations.of(context).translate("name"),
                          context
                      );
                      return;
                    }
                    if(recipientPhone.isEmpty){
                      popUpValidation(
                          AppLocalizations.of(context).translate("phone"),
                          context
                      );
                      return;
                    }
                    if(recipientEmail.isEmpty){
                      popUpValidation(
                          AppLocalizations.of(context).translate("email"),
                          context
                      );
                      return;
                    }
                    final emailRegex = RegExp(
                      r'^[\w\.-]+@[\w\.-]+\.\w+$',
                    );

                    if (!emailRegex.hasMatch(recipientEmail)) {
                      popUpValidation(
                          AppLocalizations.of(context).translate("emailInvalid"),
                          context
                      );
                      return;
                    }

                    if (recipientPhone.isEmpty) {
                      popUpValidation(
                          AppLocalizations.of(context).translate("phone"),
                          context
                      );
                      return;
                    }
                    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
                    if (!phoneRegex.hasMatch(recipientPhone)) {
                      popUpValidation(
                          AppLocalizations.of(context).translate("phoneInvalid"),
                          context
                      );
                      return;
                    }


                  }
                  if(step == 3){
                    if(offer == 0){
                      popUpValidation(
                          AppLocalizations.of(context).translate("offer"),
                          context
                      );
                      return;
                    }
                  }
                  if (step == 5) {
                    if(savePackage() == 0){
                      return;
                    };
                  }
                  if (step == 9) {
                    var uuid = Uuid();
                    String expeditionId = 'E${uuid.v4().substring(0, 8)}';
                    String addressId = 'A${uuid.v4().substring(0, 8)}';
                    String addressId2 = 'A${uuid.v4().substring(0, 8)}';
                    AddressModel retireAddress = AddressModel(
                        addressId,
                        selectedStreet!,
                        int.parse(selectedNumber!),
                        selectedCity!,
                        selectedProvince!,
                        int.parse(selectedPostalCode!));
                    AddressModel destinationAddress = AddressModel(
                        addressId2,
                        selectedDestinationStreet!,
                        int.parse(selectedDestinationNumber!),
                        selectedDestinationCity!,
                        selectedDestinationProvince!,
                        int.parse(selectedDestinationPostalCode!));

                    ExpeditionModel expedition = ExpeditionModel(
                      dateFormat(DateTime.now()),
                      expeditionId,
                      articles,
                      true,
                      'equipment',
                      retireAddress,
                      destinationAddress,
                      offer,
                      OwnerExModel(
                        user.id,
                        user.name,
                        user.email,
                        user.phone,
                        user.token,
                        user.userView,
                        user.profileImage,
                        fiscalCode: (user is PhysicPerson)
                            ? user.fiscalCode
                            : null,
                        vatNumber:
                        (user is LegalPerson) ? user.vatNumber : null,
                      ),
                      false,
                      false,
                      false,
                      false,
                      userRole,
                      UserExpeditionType(
                          'recipient',
                          userRole == 'recipient'
                              ? '${user.name} ${user.lastName}'
                              : recipientName,
                          userRole == 'recipient'
                              ? user.email
                              : recipientEmail,
                          userRole == 'recipient'
                              ? user.phone
                              : recipientPhone),
                      UserExpeditionType(
                          'sender',
                          userRole == 'sender'
                              ? '${user.name} ${user.lastName}'
                              : recipientName,
                          userRole == 'sender'
                              ? user.email
                              : recipientEmail,
                          userRole == 'sender'
                              ? user.phone
                              : recipientPhone),
                    );
                    Provider.of<AppState>(context, listen: false)
                        .addNewExpedition(expedition);
                  }
                  if (step == 10) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                    return;
                  }
                  changePage();
                }),
          ],
        )
            : SizedBox(),
        content:
        PageViewBuilderLayout(pageController: pageController, pages: pages),
        showHeader: true);
  }
}
