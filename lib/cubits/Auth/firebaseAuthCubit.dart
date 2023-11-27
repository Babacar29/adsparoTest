// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
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

  FirebaseAuthCubit(this._authRepository) : super(FirebaseAuthInitial());

  //to socialFirebaseAuth user
  void firebaseAuthUser({ required BuildContext context, String? email, String? password}) {
    emit(FirebaseAuthProgress());
      _authRepository.signInUser(email: email, password: password, context: context).then((result) {
        if(result?.user?.displayName != null && result?.user?.emailVerified == true){
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
