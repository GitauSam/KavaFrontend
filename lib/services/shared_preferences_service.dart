import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kava_journal/model/login_model.dart';
import 'package:kava_journal/model/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var loginDetails = prefs.getString("login_details");

    return loginDetails != null && loginDetails != '0' ? true : false;
  }

  static Future<LoginResponseModel> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    var deets = prefs.getString("login_details");
    print(deets);
    return deets != null
        ? LoginResponseModel.fromSharedPrefs(json.decode(deets))
        : null;
  }

  static Future<void> setLoginDetails(LoginResponseModel loginResponseModel) async {
    print("Setting up shared prefs");
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
      "login_details", loginResponseModel != null
                        ? jsonEncode(loginResponseModel.toJson(),)
                        : '0'
    );
    print("Saved shared prefs as: " + prefs.getString('login_details'));
  }

  static Future<void> setRegisterDetails(RegisterResponseModel registerResponseModel) async {
    print("Setting up shared prefs (Reg)");
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(
        "login_details", registerResponseModel != null
        ? jsonEncode(registerResponseModel.toJson(),)
        : '0'
    );
    print("(Reg) Saved shared prefs as: " + prefs.getString('login_details'));
  }

  static Future<void> logout(BuildContext context) async {
    await setLoginDetails(null);
    Navigator.of(context).pushReplacementNamed('/login');
  }
}