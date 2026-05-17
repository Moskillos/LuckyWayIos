import 'package:flutter/material.dart';

import '../costants/global_color.dart';

class CustomDivider extends StatelessWidget {
  Color? color;
  CustomDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Colors.black,
      height: 1,
      width: MediaQuery.of(context).size.width,
    );
  }
}
