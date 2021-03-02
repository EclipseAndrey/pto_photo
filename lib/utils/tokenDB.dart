import 'package:shared_preferences/shared_preferences.dart';

Future<String> tokenDB ({String token})async{
  final prefs = await SharedPreferences.getInstance();

  if(token == null){
    var token = await prefs.getString("token")??"null";
    return token;
  }else{
    await prefs.setString("token",token);
  }
}