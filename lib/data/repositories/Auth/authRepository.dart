// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/api.dart';
import 'authRemoteDataSource.dart';


class AuthRepository {
  static final AuthRepository _authRepository = AuthRepository._internal();
  late AuthRemoteDataSource _authRemoteDataSource;

  factory AuthRepository() {
    _authRepository._authRemoteDataSource = AuthRemoteDataSource();
    return _authRepository;
  }

  AuthRepository._internal();


  //First we signin user with given provider then add user details
  Future<UserCredential?> signInUser({required BuildContext context, String? email, String? password}) async {
    try {
      var userDataTest = await _authRemoteDataSource.signInWithEmailPassword(
          email: email ?? "",
          context: context,
          password: password ?? "",
       );

      return userDataTest;
    } catch (e) {
      //signOut(authProvider);
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<UserCredential?> signUpUser({required BuildContext context, required String email, required String password, name}) async {
    try {
      var userDataTest = await _authRemoteDataSource.register(
          email: email,
          context: context,
          password: password,
          name: name
       );

      return userDataTest;
    } catch (e) {
      //signOut(authProvider);
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }

  Future<dynamic> updateUserData({required String userId, String? name, String? mobile, String? email, String? filePath, required BuildContext context}) async {
    final result = await _authRemoteDataSource.updateUserData(userId: userId, email: email, name: name, mobile: mobile, filePath: filePath);
    return result;
  }

  //to update fcmId user's data to database. This will be in use when authenticating using fcmId
  Future<Map<String, dynamic>> registerToken({required String fcmId, required BuildContext context}) async {
    final result = await _authRemoteDataSource.registerToken(fcmId: fcmId, context: context);
    return result;
  }

  //to delete my account
  Future<dynamic> deleteUser({required BuildContext context, required String userId}) async {
    final result = await _authRemoteDataSource.deleteUserAcc(userId: userId, context: context);
    return result;
  }

  Future<void> signOut(AuthProvider authProvider) async {
    _authRemoteDataSource.signOut(authProvider);
  }
}
