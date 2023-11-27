// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../styles/colors.dart';
import 'customTextLabel.dart';


class Btn extends StatelessWidget {
  final Function onTap;
  final String text;
  final double topPad;
  final double width;

  const Btn({Key? key, required this.onTap, required this.text, required this.topPad, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPad),
      child: InkWell(
          splashColor: Colors.transparent,
          child: Container(
            height: 55.0,
            width: width,
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
