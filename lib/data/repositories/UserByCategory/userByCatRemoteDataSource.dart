// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../../utils/api.dart';
import '../../../utils/strings.dart';

class UserByCatRemoteDataSource {
  Future<dynamic> getUserByCat({required BuildContext context, required String userId}) async {
    try {
      final body = {
        USER_ID: userId,
      };
      final result = await Api.post(body: body, url: Api.getUserByIdApi);
      return result;
    } catch (e) {
      throw ApiMessageAndCodeException(errorMessage: e.toString());
    }
  }
}
