// ignore_for_file: file_names

import 'package:adsparo_test/ui/styles/colors.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onTap;
  final double? horizontalPadding;

  const CustomBackButton({Key? key, this.onTap, this.horizontalPadding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 0),
        child: InkWell(
            onTap: () => onTap ?? Navigator.of(context).pop(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: const Icon(Icons.arrow_back, color: adsBlueColor)));
  }
}
