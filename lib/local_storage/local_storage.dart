
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{

  static setToken(String userId) async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("userID")) { prefs.remove("userID"); }
    if(userId.isNotEmpty){
      await prefs.setString("userID",userId);
    }
  }

  static Future<String?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString("userID");
    return value;
  }

  static removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("userID")) { prefs.remove("userID"); }
  }

  Future<bool> tokenExits() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("userID")) { return true; }
    return false;
  }
}