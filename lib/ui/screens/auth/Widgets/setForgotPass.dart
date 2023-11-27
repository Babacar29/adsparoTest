// ignore_for_file: file_names

import 'package:adsparo_test/ui/styles/colors.dart';
import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../widgets/customTextLabel.dart';


setForgotPass(BuildContext context) {
  return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.forgotPass);
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(adsBlueColor.withOpacity(0.7)),
          ),
          child: const CustomTextLabel(
            text: 'forgotPassLbl',
          ),
        ),
      ));
}
