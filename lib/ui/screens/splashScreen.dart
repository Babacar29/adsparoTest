// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';

import '../../app/routes.dart';
import '../../utils/uiUtils.dart';
import '../styles/colors.dart';
import '../widgets/Slideanimation.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> with TickerProviderStateMixin {
  AnimationController? _splashIconController;
  AnimationController? _newsImgController;
  AnimationController? _slideControllerBottom;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _slideControllerBottom = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _splashIconController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _newsImgController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        opacity = (opacity == 0.0) ? 1.0 : 0.0;
      });
    });
  }

  @override
  void dispose() {
    _splashIconController!.dispose();
    _newsImgController!.dispose();
    _slideControllerBottom!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: backgroundColor, body: buildScale(context));
  }

  void navigationPage(BuildContext context) {
    if(!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.introSlider);
  }


  Widget buildScale(BuildContext context) {
    Future.delayed(const Duration(seconds: 4) , () => navigationPage(context));
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 2 * kToolbarHeight),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(200)),
        color: darkBackgroundColor,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 150),
        splashLogoIcon(),
        //newsTextIcon(),
        subTitle(),
        const Spacer(),
        //bottomText(),
      ]),
    );
  }

  Widget splashLogoIcon() {
    return Center(
        child: SlideAnimation(
            position: 2,
            itemCount: 3,
            slideDirection: SlideDirection.fromRight,
            animationController: _splashIconController!,
            child: Image.asset(UiUtils.getImagePath("adsparolab_logo.png"), height: 100.0, width: 300, fit: BoxFit.contain)));
  }

  /*Widget newsTextIcon() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Center(
        child: SlideAnimation(
            position: 3,
            itemCount: 4,
            slideDirection: SlideDirection.fromLeft,
            animationController: _newsImgController!,
            child: Image.asset(UiUtils.getImagePath("reewmi_logo.png"), height: 30.0, fit: BoxFit.fill)),
      ),
    );
  }*/

  Widget subTitle() {
    return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(seconds: 1),
        child: Container(
          margin: const EdgeInsets.only(top: 20.0),
          child: Text(UiUtils.getTranslatedLabel(context, 'fastTrendNewsLbl'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: backgroundColor)),
        ));
  }

  /*Widget bottomText() {
    return Container(
        //Logo & text @ bottom
        margin: const EdgeInsetsDirectional.only(bottom: 20),
        child: companyLogo());
  }

  Widget companyLogo() {
    return SlideAnimation(
        position: 1,
        itemCount: 2,
        slideDirection: SlideDirection.fromBottom,
        animationController: _slideControllerBottom!,
        child: Image.asset(UiUtils.getImagePath("reewmi_logo.png"), height: 35.0, fit: BoxFit.fill));
  }*/
}
