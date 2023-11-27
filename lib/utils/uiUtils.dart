// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app/routes.dart';
import '../cubits/Auth/authCubit.dart';
import '../cubits/languageJsonCubit.dart';
import '../ui/styles/appTheme.dart';
import '../ui/styles/colors.dart';
import 'labelKeys.dart';


class UiUtils {
  static GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();


  //used for IntroSlider Images only
  static String getImagePath(String imageName) {
    return "assets/images/$imageName";
  }

  static String getSvgImagePath(String imageName) {
    return "assets/images/svgImage/$imageName.svg";
  }

  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

// get app theme
  static String getThemeLabelFromAppTheme(AppTheme appTheme) {
    if (appTheme == AppTheme.Dark) {
      return darkThemeKey;
    }
    return lightThemeKey;
  }

  static AppTheme getAppThemeFromLabel(String label) {
    if (label == darkThemeKey) {
      return AppTheme.Dark;
    }
    return AppTheme.Light;
  }

  static String getTranslatedLabel(BuildContext context, String labelKey) {
    return context.read<LanguageJsonCubit>().getTranslatedLabels(labelKey);
  }


  static setUIOverlayStyle({required AppTheme appTheme}) {
    appTheme == AppTheme.Light
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: backgroundColor.withOpacity(0.8), statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark))
        : SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(statusBarColor: darkSecondaryColor.withOpacity(0.8), statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light));
  }

  static userLogOut({required BuildContext contxt}) {

    for (int i = 0; i < AuthProviders.values.length; i++) {
      if (AuthProviders.values[i].name == contxt.read<AuthCubit>().getType()) {
        contxt.read<AuthCubit>().signOut(AuthProviders.values[i]).then((value) {
          Navigator.of(contxt).pushNamedAndRemoveUntil(Routes.login, (route) => false);
        });
      }
    }
  }

//widget for User Profile Picture in Comments
  static Widget setFixedSizeboxForProfilePicture({required Widget childWidget}) {
    return SizedBox(height: 35, width: 35, child: childWidget);
  }
}
