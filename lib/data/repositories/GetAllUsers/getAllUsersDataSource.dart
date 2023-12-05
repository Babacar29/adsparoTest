// ignore_for_file: file_names

import 'package:firebase_database/firebase_database.dart';

import '../../../utils/api.dart';


class GetAllUsersRemoteDataSource {
   getUsers() async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final result = await db.child("users").get();
      return result.value;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
