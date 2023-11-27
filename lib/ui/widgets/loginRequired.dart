// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../utils/uiUtils.dart';
import 'SnackBarWidget.dart';

Future<void> loginRequired(BuildContext context) {
  showSnackBar(UiUtils.getTranslatedLabel(context, 'loginReqMsg'), context);

  Future.delayed(const Duration(milliseconds: 1000), () {
    return Navigator.of(context).pushNamed(Routes.login, arguments: {"isFromApp": true}); //pass isFromApp to get back to specified screen
  });
  return Future(() => null);
}
