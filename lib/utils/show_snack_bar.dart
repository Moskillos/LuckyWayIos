import 'package:flutter/cupertino.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../app_localizations.dart';

void showErrorSnackBar(context, localAnimationController,String message){
  showTopSnackBar(
    onTap: (){
      localAnimationController!.reverse();
    },
    Overlay.of(context),
    CustomSnackBar.error(
      message: message,
      maxLines: 4,
    ),
    persistent: true,
    onAnimationControllerInit: (controller) =>
    localAnimationController = controller,
  );
}

void showSuccessSnackBar(context, localAnimationController, message){
  showTopSnackBar(
    onTap: (){
      localAnimationController!.reverse();
    },
    Overlay.of(context),
    CustomSnackBar.success(
      message: message,
      maxLines: 4,
    ),
    persistent: true,
    onAnimationControllerInit: (controller) =>
    localAnimationController = controller,
  );
}