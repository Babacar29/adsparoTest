// ignore_for_file: file_names, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../cubits/Auth/firebaseAuthCubit.dart';

import '../../../utils/internetConnectivity.dart';
import '../../../utils/uiUtils.dart';
import '../../../utils/validators.dart';
import '../../styles/colors.dart';
import '../../widgets/SnackBarWidget.dart';
import '../../widgets/customTextLabel.dart';
import 'Widgets/fieldFocusChange.dart';
import 'Widgets/setConfimPass.dart';
import 'Widgets/setEmail.dart';
import 'Widgets/setForgotPass.dart';
import 'Widgets/setLoginAndSignUpBtn.dart';
import 'Widgets/setName.dart';
import 'Widgets/setPassword.dart';

class LoginScreen extends StatefulWidget {
  final bool? isFromApp;
  const LoginScreen({super.key, this.isFromApp});

  @override
  LoginScreenState createState() => LoginScreenState();

  static Route route(RouteSettings routeSettings) {
    if (routeSettings.arguments == null) {
      return CupertinoPageRoute(builder: (_) => const LoginScreen());
    } else {
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      return CupertinoPageRoute(
          builder: (_) => LoginScreen(
                isFromApp: arguments['isFromApp'] ?? false,
              ));
    }
  }
}

class LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TabController? _tabController;
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode emailSFocus = FocusNode();
  FocusNode passSFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();
  TextEditingController? emailC, passC, sEmailC, sPassC, sNameC, sConfPassC;
  String? name, email, pass, mobile, profile, confPass;
  bool isChecked = false;
  bool isPolicyAvailable = false;
  bool isObscure = true; //setPassword widget

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    assignAllTextController();
    _tabController!.addListener(() {
      FocusScope.of(context).unfocus(); //dismiss keyboard
      clearLoginTextFields();
      clearSignUpTextFields();
    });
    super.initState();
  }

  updateCheck(bool isCheck) {
    setState(() {
      isChecked = isCheck;
    });
  }

  assignAllTextController() {
    emailC = TextEditingController();
    passC = TextEditingController();
    sEmailC = TextEditingController();
    sPassC = TextEditingController();
    sNameC = TextEditingController();
    sConfPassC = TextEditingController();
  }

  clearSignUpTextFields() {
    setState(() {
      sNameC!.clear();
      sEmailC!.clear();
      sPassC!.clear();
      sConfPassC!.clear();
    });
  }

  clearLoginTextFields() {
    setState(() {
      emailC!.clear();
      passC!.clear();
    });
  }

  disposeAllTextController() {
    emailC!.dispose();
    passC!.dispose();
    sEmailC!.dispose();
    sPassC!.dispose();
    sNameC!.dispose();
    sConfPassC!.dispose();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    disposeAllTextController();
    super.dispose();
  }

  //show form content
  showContent() {
    return Form(
        key: _formkey,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.only(top: 35.0, bottom: 20.0, start: 20.0, end: 20.0),
              width: MediaQuery.of(context).size.width,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                //skipBtn(),
                const SizedBox(height: 50),
                showTabs(),
                showTabBarView(),
              ]),
            ),
          ],
        ));
  }

  //set skip login btn
  /*skipBtn() {
    return Align(
        alignment: Alignment.topRight,
        child: CustomTextButton(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Routes.home, arguments: false);
          },
          text: UiUtils.getTranslatedLabel(context, 'skip'),
          color: adsBlueColor.withOpacity(0.7),
        ));
  }*/

  showTabs() {
    return Align(
        alignment: Alignment.centerLeft,
        child: DefaultTabController(
          length: 2,
          child: Container(
              padding: const EdgeInsetsDirectional.only(start: 10.0),
              width: MediaQuery.of(context).size.width / 1.7,
              child: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  controller: _tabController,
                  labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  labelPadding: EdgeInsets.zero,
                  labelColor: backgroundColor,
                  unselectedLabelColor: adsBlueColor,
                  indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: adsBlueColor),
                  tabs: [Tab(text: UiUtils.getTranslatedLabel(context, 'signInTab')), Tab(text: UiUtils.getTranslatedLabel(context, 'signupBtn'))])),
        ));
  }

  //check validation of form data
  bool validateAndSave() {
    final form = _formkey.currentState;
    form!.save();
    if (form.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Widget setPassword({required FocusNode currFocus, FocusNode? nextFocus, required TextEditingController passC, required String pass, required double topPad, required bool isLogin}) {
    return Padding(
      padding: EdgeInsets.only(top: topPad),
      child: TextFormField(
        focusNode: currFocus,
        textInputAction: isLogin ? TextInputAction.done : TextInputAction.next,
        controller: passC,
        obscureText: isObscure,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
        validator: (val) => Validators.passValidation(val!, context),
        onFieldSubmitted: (v) {
          if (!isLogin) {
            fieldFocusChange(context, currFocus, nextFocus!);
          }
        },
        onChanged: (String value) {
          pass = value;
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: UiUtils.getTranslatedLabel(context, 'passLbl'),
          hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
          suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: IconButton(
                icon: isObscure ? const Icon(Icons.visibility_rounded, size: 20) : const Icon(Icons.visibility_off_rounded, size: 20),
                splashColor: Colors.transparent,
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )),
          filled: true,
          fillColor: adsBlueColor.withOpacity(0.6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: UiUtils.getColorScheme(context).outline.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  showTabBarView() {
    return Expanded(
      child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 1.0,
          child: TabBarView(
            controller: _tabController,
            dragStartBehavior: DragStartBehavior.start,
            children: [
              //Login
              SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(children: [
                      loginTxt(),
                      const SizedBox(height: 20,),
                      SetEmail(currFocus: emailFocus, nextFocus: passFocus, emailC: emailC!, email: email ?? '', topPad: 20),
                      SetPassword(currFocus: passFocus, passC: passC!, pass: pass ?? '', topPad: 20, isLogin: true),
                      setForgotPass(context),
                      SetLoginAndSignUpBtn(
                          onTap: () async {
                            FocusScope.of(context).unfocus(); //dismiss keyboard
                            if (validateAndSave()) {
                              if (await InternetConnectivity.isNetworkAvailable()) {
                                context.read<FirebaseAuthCubit>().firebaseAuthUser(email: emailC!.text.trim(), password: passC!.text, context: context);
                              } else {
                                showSnackBar(UiUtils.getTranslatedLabel(context, 'internetmsg'), context);
                              }
                            }
                          },
                          text: 'loginTxt',
                          topPad: 20
                      ),
                    ]),
                  )),
              //SignUp
              SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        signUpTxt(),
                        SetName(currFocus: nameFocus, nextFocus: emailSFocus, nameC: sNameC!, name: sNameC!.text),
                        SetEmail(currFocus: emailSFocus, nextFocus: passSFocus, emailC: sEmailC!, email: sEmailC!.text, topPad: 20),
                        setPassword(currFocus: passSFocus, nextFocus: confPassFocus, passC: sPassC!, pass: sPassC!.text, topPad: 20, isLogin: false),
                        SetConfirmPass(currFocus: confPassFocus, confPassC: sConfPassC!, confPass: sConfPassC!.text, pass: sPassC!.text),
                        SetLoginAndSignUpBtn(
                            onTap: () async {
                              FocusScope.of(context).unfocus(); //dismiss keyboard

                              if(sPassC?.text != sConfPassC?.text){
                                showSnackBar(UiUtils.getTranslatedLabel(context, 'confirmPasswordFail'), context);
                                return;
                              }

                              if (validateAndSave()) {
                                if (await InternetConnectivity.isNetworkAvailable()) {
                                  await  context.read<FirebaseAuthCubit>().registerUser(
                                      email: sEmailC!.text.trim(), password: sPassC!.text,
                                      context: context, name: sNameC!.text.trim(),);

                                  _tabController?.animateTo(0);
                                  FocusScope.of(context).requestFocus(emailFocus);
                                }
                                else {
                                  showSnackBar(UiUtils.getTranslatedLabel(context, 'internetmsg'), context);
                                }
                              }
                            },
                            text: 'signupBtn',
                            topPad: 25
                        )
                      ],
                    ),
                  ))
            ],
          )),
    );
  }

  loginTxt() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 40.0, start: 10.0),
          child: CustomTextLabel(
            text: 'loginDescr',
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: adsBlueColor, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            textAlign: TextAlign.left,
          ),
        )
    );
  }

  signUpTxt() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 35.0, start: 10.0),
          child: CustomTextLabel(
            text: 'signupDescr',
            textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(color: adsBlueColor, fontWeight: FontWeight.w800, letterSpacing: 0.5),
            textAlign: TextAlign.left,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showContent(),
    );
  }
}
