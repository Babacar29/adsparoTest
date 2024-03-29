// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/AuthModel.dart';
import '../../data/repositories/Auth/authRepository.dart';

const String loginEmail = "email";
const String loginMbl = "mobile";

enum AuthProviders { mobile, email }

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  //to store authDetails
  final AuthModel authModel;

  Authenticated({required this.authModel});
}

class Unauthenticated extends AuthState {}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  AuthRepository get authRepository => _authRepository;

  String getUserId() {
    return (state is Authenticated) ? (state as Authenticated).authModel.id! : "0";
  }

  String getUserName() {
    return (state is Authenticated) ? (state as Authenticated).authModel.name! : "";
  }

  String getEmail() {
    return (state is Authenticated) ? (state as Authenticated).authModel.email! : "";
  }

  String getProfile() {
    return (state is Authenticated) ? (state as Authenticated).authModel.profile! : "";
  }

  String getMobile() {
    return (state is Authenticated) ? (state as Authenticated).authModel.mobile! : "";
  }

  String getStatus() {
    return (state is Authenticated) ? (state as Authenticated).authModel.status! : "";
  }

  String getIsFirstLogin() {
    return (state is Authenticated) ? (state as Authenticated).authModel.isFirstLogin! : "";
  }

  String getRole() {
    return (state is Authenticated) ? (state as Authenticated).authModel.role! : "";
  }

  void updateDetails({required AuthModel authModel}) {
    emit(Authenticated(authModel: authModel));
  }

  //to signOut
  Future signOut({required BuildContext context}) async {
    _authRepository.signOut(context: context);
    emit(Unauthenticated());
  }
}
