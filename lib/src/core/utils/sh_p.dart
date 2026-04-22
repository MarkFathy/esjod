import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SHP {
  static Future<bool> saveString(
      {required String key, required String value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
      return true;
    } catch (e) {
      debugPrint("save data error is $e");
      return false;
    }
  }

  static Future<String?> loadString({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

/////////////////////////
  static Future<bool> saveInt({required String key, required int value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt(key, value);
      return true;
    } catch (e) {
      debugPrint("save data error is $e");
      return false;
    }
  }

  static Future<int?> loadInt({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(key);
  }

///////////////////////
  static Future<bool> saveDouble(
      {required String key, required double value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble(key, value);
      return true;
    } catch (e) {
      debugPrint("save data error is $e");
      return false;
    }
  }

  static Future<double?> loadDouble({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getDouble(key);
  }

///////////////////////////////
  static Future<bool> saveList(
      {required String key, required List<String> value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(key, value);
      return true;
    } catch (e) {
      debugPrint("save data error is $e");
      return false;
    }
  }

  static Future<List<String>?> loadList({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(key);
  }

///////////////////////////////
  static Future<bool> saveBool(
      {required String key, required bool value}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(key, value);
      return true;
    } catch (e) {
      debugPrint(("save bool error is $e"));
      return false;
    }
  }

  Future<bool?> loadBool({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key);
  }

//////////////////////////////////
  removeData({required String key}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.remove(key);
  }
}
