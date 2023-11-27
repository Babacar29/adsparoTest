// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../styles/colors.dart';
import '../../../widgets/customTextLabel.dart';

class SetLoginAndSignUpBtn extends StatelessWidget {
  final Function onTap;
  final String text;
  final double topPad;

  const SetLoginAndSignUpBtn({Key? key, required this.onTap, required this.text, required this.topPad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPad),
      child: InkWell(
          splashColor: Colors.transparent,
          child: Container(
            height: 55.0,
            width: MediaQuery.sizeOf(context).width * 0.9,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: adsBlueColor, borderRadius: BorderRadius.circular(7.0)),
            child: CustomTextLabel(
              text: text,
              textStyle: Theme.of(context).textTheme.titleLarge?.copyWith(color: secondaryColor, fontWeight: FontWeight.w600, fontSize: 21, letterSpacing: 0.6),
            ),
          ),
          onTap: () => onTap()),
    );
  }
}
