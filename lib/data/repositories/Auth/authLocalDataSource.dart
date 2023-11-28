
import 'dart:convert';

import 'package:adsparo_test/data/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServices {
  static final SharedPreferencesServices _instance = SharedPreferencesServices._ctor();

  factory SharedPreferencesServices() {
    return _instance;
  }

  SharedPreferencesServices._ctor();

  static late SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  UserModel? getUserFromSharedPref()  {
    if (!_prefs.containsKey('user')) {
      return null;
    }
    return UserModel.fromJson(json.decode(_prefs.get('user') as String));
  }

  setUserInSharedPref(UserModel user) {
    _prefs.setString("user", json.encode(user.toMap()));
  }
}