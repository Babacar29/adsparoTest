import 'package:flutter/material.dart';

import '../../utils/uiUtils.dart';

showSnackBar(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textScaleFactor: 1.1,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      showCloseIcon: false,
      duration: const Duration(milliseconds: 2000), //bydefault 4000 ms
      backgroundColor: UiUtils.getColorScheme(context).primaryContainer,
      elevation: 1.0,
    ),
  );
}
