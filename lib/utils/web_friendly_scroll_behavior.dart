import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class WebFriendlyScrollBehavior extends ScrollBehavior {
  const WebFriendlyScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return kIsWeb
        ? const ClampingScrollPhysics()
        : const BouncingScrollPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}