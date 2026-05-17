import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucky_way_ios/models/expedition_model.dart';

import '../../app_localizations.dart';
import '../../costants/global_color.dart';
import '../../costants/text_style.dart';
import '../../layout/lucky_way_layout.dart';
import '../../models/package_model.dart';
import '../../ui/buttons/luckyway_btn.dart';
import '../../ui/custom_divider.dart';

class ExpeditionInfoScreen extends StatefulWidget {
  final ExpeditionModel expedition;
  const ExpeditionInfoScreen({super.key, required this.expedition});

  @override
  State<ExpeditionInfoScreen> createState() => _ExpeditionInfoScreenState();
}

class _ExpeditionInfoScreenState extends State<ExpeditionInfoScreen> {
  String getUniqueMerchandiseString(List<PackageModel> packages) {
    final seen = <String>{};

    for (var package in packages) {
      if (!seen.contains(package.merchandise)) {
        seen.add(package.merchandise);
      }
    }

    return seen.join(', ');
  }

  String getUniquePackageDescriptions(List<PackageModel> packages) {
    final seen = <String>{};

    for (var package in packages) {
      final description =
          '${package.height} x ${package.width} x ${package.length} - ${package.weight}';
      if (!seen.contains(description)) {
        seen.add(description);
      }
    }

    return seen.join(', ');
  }

  void copyString(String text){
    Clipboard.setData(ClipboardData(text: text));
  }

  Widget itemRender(
      String title, String value, String? icon, Function? action) {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: blackText14w700,
                ),
                Text(
                  value,
                  style: blueText14,
                )
              ],
            ),
            if (icon != null)
              InkWell(
                onTap: () {
                  if (action != null) {
                    action(value);
                  }
                },
                child: SvgPicture.asset(
                  icon,
                  color: Colors.black,
                  height: 30,
                  width: 30,
                ),
              )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        CustomDivider(
          color: primaryBlue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LuckyWayLayout(
        isNavigate: true,
        showHeader: true,
        title: AppLocalizations.of(context).translate("expedition"),
        content: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate("expeditionDesc"),
                style: greyText18,
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 20,
              ),
              CustomDivider(
                color: primaryBlue,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    itemRender(
                        AppLocalizations.of(context).translate("retireAddress"),
                        '${widget.expedition.retireAddress.street}, ${widget.expedition.retireAddress.civicNumber}, ${widget.expedition.retireAddress.city}',
                        'assets/copy.svg', copyString),
                    itemRender(
                        AppLocalizations.of(context)
                            .translate("destinationAddress"),
                        '${widget.expedition.destinationAddress.street}, ${widget.expedition.destinationAddress.civicNumber}, ${widget.expedition.destinationAddress.city}',
                        'assets/copy.svg', copyString),
                    itemRender(
                      AppLocalizations.of(context)
                          .translate("merchandiseTypologies2"),
                      getUniqueMerchandiseString(widget.expedition.packages),
                      null,
                      null
                    ),
                    itemRender(
                        AppLocalizations.of(context).translate("articleQuantity"),
                        widget.expedition.packages.length.toString(),
                        null, null),
                    itemRender(
                        AppLocalizations.of(context)
                            .translate("dimensionsAndWeight"),
                        getUniquePackageDescriptions(widget.expedition.packages),
                        null, null),
                    itemRender(
                        AppLocalizations.of(context)
                            .translate("paid2"),
                        widget.expedition.paid ? AppLocalizations.of(context)
                            .translate("yes") : AppLocalizations.of(context)
                        .translate("no"),
                        null, null),
                    itemRender(
                        AppLocalizations.of(context)
                            .translate("offer"),
                        '${widget.expedition.offer.toString()} €',
                        null, null),

                  ],
                ),
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
            LuckywayBtn(
                text: AppLocalizations.of(context).translate("goBack"),
                backgroundColor: Colors.black,
                textStyle: whiteText14w700,
                icon: 'assets/back-arrow.svg',
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ));
  }
}
