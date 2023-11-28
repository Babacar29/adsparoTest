// ignore_for_file: file_names

import 'package:adsparo_test/data/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../../data/repositories/Auth/authLocalDataSource.dart';
import '../../data/repositories/Auth/authRepository.dart';

@immutable
abstract class FirebaseAuthState {}

class FirebaseAuthInitial extends FirebaseAuthState {}

class FirebaseAuthProgress extends FirebaseAuthState {}

class FirebaseAuthSuccess extends FirebaseAuthState {
  final UserCredential? userCredential;

  FirebaseAuthSuccess({required this.userCredential});
}

class FirebaseAuthFailure extends FirebaseAuthState {
  final String errorMessage;

  FirebaseAuthFailure(this.errorMessage);
}

class FirebaseAuthCubit extends Cubit<FirebaseAuthState> {
  final AuthRepository _authRepository;
  final SharedPreferencesServices _sharedPreferencesServices;

  FirebaseAuthCubit(this._authRepository, this._sharedPreferencesServices) : super(FirebaseAuthInitial());

  Future<void> insertUserToFirebase(String? uid, Map user) async{
    try {
      final db = FirebaseDatabase.instance.ref();
      debugPrint("instance ======> $user");
      await db.child("users/$uid").set(user);
    }
    catch(e){
      debugPrint("exception =======> $e");
    }
  }
  Future<void> updateUserInFirebase(String? uid, var user) async{
    try {
      final db = FirebaseDatabase.instance.ref();
      debugPrint("instance ======> $user");
      await db.child("users/$uid").update(user);
    }
    catch(e){
      debugPrint("exception =======> $e");
    }
  }

  //to socialFirebaseAuth user
  void firebaseAuthUser({ required BuildContext context, String? email, String? password}) async{
    emit(FirebaseAuthProgress());
      await _authRepository.signInUser(email: email, password: password, context: context).then((result) {
        if(result?.user?.displayName != null && result?.user?.emailVerified == true){
          UserModel user = UserModel(
            uid: result?.user?.uid,
            email: result?.user?.email,
            name: result?.user?.displayName,
          );
          _sharedPreferencesServices.setUserInSharedPref(user);
          insertUserToFirebase(user.uid, user.toMap());
          emit(FirebaseAuthSuccess(userCredential: result));
          Navigator.pushNamedAndRemoveUntil(context, Routes.setUpProfile, (route) => false);
        }
    }).catchError((e) {
      emit(FirebaseAuthFailure(e.toString()));
    });
  }

  //Sign up user
  Future<UserCredential?> registerUser({ required BuildContext context, required String email, required String password, required String name}) async{
    late UserCredential? userCredential;
    emit(FirebaseAuthProgress());
    userCredential = await _authRepository.signUpUser(email: email, password: password, context: context, name: name);
    if(userCredential?.user?.displayName != null){
      emit(FirebaseAuthSuccess(userCredential: userCredential));
      return userCredential;
    }
    return userCredential;
  }
}
