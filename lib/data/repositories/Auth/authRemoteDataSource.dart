// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../ui/widgets/SnackBarWidget.dart';
import '../../../utils/api.dart';
import '../../../utils/strings.dart';
import '../../../utils/uiUtils.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<dynamic> loginAuth(
      {required BuildContext context, required String firebaseId, required String name, required String email, required String type, required String profile, required String mobile}) async {
    try {
      final body = {FIREBASE_ID: firebaseId, NAME: name, TYPE: type, EMAIL: email};
      if (profile != "") {
        body[PROFILE] = profile;
      }
      if (mobile != "") {
        body[MOBILE] = mobile;
      }
      var result = await Api.post(body: body, url: Api.getUserSignUpApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> deleteUserAcc({required BuildContext context, required String userId}) async {
    try {
      final body = {USER_ID: userId};

      final result = await Api.post(body: body, url: Api.userDeleteApi);

      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  //to update fcmId of user's
  Future<dynamic> updateUserData({
    required String userId,
    String? name,
    String? mobile,
    String? email,
    String? filePath,
  }) async {
    try {
      Map<String, dynamic> body = {USER_ID: userId};
      Map<String, dynamic> result = {};

      if (filePath != null) {
        body[IMAGE] = await MultipartFile.fromFile(filePath);
        result = await Api.post(body: body, url: Api.setProfileApi);
      } else {
        if (name != null) {
          body[NAME] = name;
        }
        if (mobile != null) {
          body[MOBILE] = mobile;
        }
        if (email != null) {
          body[EMAIL] = email;
        }
        result = await Api.post(body: body, url: Api.setUpdateProfileApi);
      }
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  //to update fcmId of user's
  Future<dynamic> updateFcmId({required String userId, required String fcmId, required BuildContext context}) async {
    try {
      //body of post request
      final body = {USER_ID: userId, FCM_ID: fcmId};
      final result = await Api.post(body: body, url: Api.updateFCMIdApi);

      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> registerToken({required String fcmId, required BuildContext context}) async {
    try {
      final body = {TOKEN: fcmId};
      final result = await Api.post(body: body, url: Api.setRegisterToken);
      return result;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }


  Future<UserCredential?> signInWithPhone({required BuildContext context, required String otp, required String verifiedId}) async {
    String code = otp.trim();

    if (code.length == 6) {
      try {
        final PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifiedId,
          smsCode: otp,
        );
        final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          assert(!user.isAnonymous);

          final User? currentUser = _firebaseAuth.currentUser;
          assert(user.uid == currentUser?.uid);
          showSnackBar(UiUtils.getTranslatedLabel(context, 'otpMsg'), context);
          return authResult;
        } else {
          showSnackBar(UiUtils.getTranslatedLabel(context, 'otpError'), context);
          return null;
        }
      } on FirebaseAuthException catch (authError) {
        if (authError.code == 'invalidVerificationCode') {
          showSnackBar(UiUtils.getTranslatedLabel(context, 'invalidVerificationCode'), context);
          return null;
        } else {
          showSnackBar(authError.message.toString(), context);
          return null;
        }
      } on FirebaseException catch (e) {
        showSnackBar(e.message.toString(), context);
        return null;
      } catch (e) {
        showSnackBar(e.toString(), context);
        return null;
      }
    } else {
      showSnackBar(UiUtils.getTranslatedLabel(context, 'enterOtpTxt'), context);
      return null;
    }
  }

  //sign in with email and password in firebase
  Future<UserCredential?> signInWithEmailPassword({required String email, required String password, required BuildContext context}) async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("User credential =======>$userCredential");
      if(userCredential.user?.emailVerified == false){
        showSnackBar(UiUtils.getTranslatedLabel(context, 'emailNotVerified'), context);
      }
      else{
        return userCredential;
      }
    } on FirebaseAuthException catch (authError) {
      debugPrint("error code =====> ${authError.code}");
      if(authError.code == "INVALID_LOGIN_CREDENTIALS"){
        showSnackBar(UiUtils.getTranslatedLabel(context, 'wrongCredentials'), context);
      }
      if (authError.code == 'userNotFound') {
        showSnackBar(UiUtils.getTranslatedLabel(context, 'userNotFound'), context);
      } else if (authError.code == 'wrongPassword') {
        showSnackBar(UiUtils.getTranslatedLabel(context, 'wrongPassword'), context);
      } else {
        throw ApiMessageAndCodeException(errorMessage: authError.message!);
      }
    } on FirebaseException catch (e) {
      showSnackBar(e.toString(), context);
    } catch (e) {
      String errorMessage = e.toString();
      showSnackBar(errorMessage, context);
    }
    return null;
  }
  //sign up with email and password in firebase
  Future<UserCredential?> register({required String email, required String password, name, required BuildContext context}) async {
    late UserCredential userCredential;
    try {
         userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        debugPrint("User credential =======>$userCredential");
        User? user = userCredential.user;
        user!.updateDisplayName(name).then((value) => debugPrint("updated name is - ${user.displayName}"));
        user.reload();
        user.sendEmailVerification().then((value) => showSnackBar('${UiUtils.getTranslatedLabel(context, 'verifSentMail')} $email', context));
      //return userCredential;
    } on FirebaseAuthException catch (authError) {
      debugPrint("error code =====> ${authError.code}");
      if (authError.code == 'weak-password') {
        showSnackBar(UiUtils.getTranslatedLabel(context, 'weakPassword'), context);
      }

      if (authError.code == 'invalid-email') {
        showSnackBar(UiUtils.getTranslatedLabel(context, 'invalidEmail'), context);
      }

      if (authError.code == 'email-already-in-use') {
        showSnackBar(UiUtils.getTranslatedLabel(context, 'emailAlreadyInUse'), context);
      } else {
        throw ApiMessageAndCodeException(errorMessage: authError.message!);
      }
    } on FirebaseException catch (e) {
      showSnackBar(e.toString(), context);
    } catch (e) {
      String errorMessage = e.toString();
      showSnackBar(errorMessage, context);
    }
    return userCredential;
  }


  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut(AuthProvider? authProvider) async {
    _firebaseAuth.signOut();
  }
}
