import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String sharedPrefernceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPrefernceUserNameKey = "USERNAMEKEY";
  static String sharedPrefernceUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveuserLoggedInSharedPreferrence(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefernceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveuserNameInSharedPreferrence(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefernceUserNameKey, userName);
  }

  static Future<bool> saveuserEmailInSharedPreferrence(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefernceUserEmailKey, userEmail);
  }

  static Future<bool> getuserLoggedInSharedPreferrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPrefernceUserLoggedInKey);
  }

  static Future<String> getuserNameInSharedPreferrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefernceUserNameKey);
  }

  static Future<String> getuserEmailInSharedPreferrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPrefernceUserEmailKey);
  }
}
