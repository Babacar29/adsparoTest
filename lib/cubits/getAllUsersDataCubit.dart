// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:adsparo_test/data/models/UserModel.dart';
import 'package:adsparo_test/data/repositories/GetAllUsers/getAllUsersRepository.dart';
import 'package:adsparo_test/ui/screens/HomePage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/Auth/authLocalDataSource.dart';


abstract class GetAllUsersState {}

class GetAllUsersInitial extends GetAllUsersState {}

class GetAllUsersFetchInProgress extends GetAllUsersState {}

class GetAllUsersFetchSuccess extends GetAllUsersState {
  //var result;

  /*GetAllUsersFetchSuccess({
    required this.result,
  });*/
}

class GetAllUsersFetchFailure extends GetAllUsersState {
  final String errorMessage;

  GetAllUsersFetchFailure(this.errorMessage);
}

class GetAllUsersCubit extends Cubit<GetAllUsersState> {
  final GetAllUsersRepository _getAllUserRepository;
  final SharedPreferencesServices _sharedPreferences;

  GetAllUsersCubit(this._getAllUserRepository, this._sharedPreferences) : super(GetAllUsersInitial());

   getUsers({required BuildContext context}) async{
    emit(GetAllUsersFetchInProgress());
    List<UserModel> users = [];
    UserModel? user = _sharedPreferences.getUserFromSharedPref();
    late UserModel? connectedUser;

    try{
      var result = await _getAllUserRepository.getUsers();
      if(result != null){
        result.forEach((k,v){
          var value = UserModel.fromMapObject(v);
          users.add(value);
          if( user?.uid == value.uid){
            connectedUser = value;
          }
        });

        if(connectedUser != null){
          debugPrint("connected user ==>$connectedUser");
          debugPrint("users ==>$users");
          _sharedPreferences.setFirstLogin(true);
          emit(GetAllUsersFetchSuccess());
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userModel: connectedUser!, users: users)
              ),
            (route) => false,
          );
        }
        else{
          emit(GetAllUsersFetchFailure("Failed to connect, please try again later !"));
        }
      }
    }
    catch(e) {
      emit(GetAllUsersFetchFailure(e.toString()));
    }
  }
}
