import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static String serverAddress = "http://192.168.106.48:8001/";

  static Future<String?> getNanoId(Map URL) async {
    final res = await http.post(Uri.parse(serverAddress + "url/"), body: URL);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body)['id'].toString();
      return data;
    } else {
      print("Error: ${res.statusCode}, ${res.body}");
      return null;
    }
  }

  static Future<Map?> getAnalytics(String shortID) async {
    final res =
        await http.get(Uri.parse(serverAddress + "url/analytics/$shortID"));
    try {
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(res.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print("Error:$e");
      return null;
    }
  }

  //SignUp Api
  static Future<bool> RegisterUser(Map data) async {
    try {
      final res = await http.post(Uri.parse(serverAddress + "api/user/Signup"),
          body: data);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print("SignUP $data");
        return true;
      } else {
        var data = jsonDecode(res.body);
        print(data['message']);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //Login API
  static Future<String?> Login(Map data) async {
    try {
      final res = await http.post(Uri.parse(serverAddress + "api/user/Login"),
          body: data);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        return data['sessionId'];
      } else {
        return 'User Not found';
      }
    } catch (e) {
      return null;
    }
  }

  static Future<bool> MakeUserAUthenticated() async {

    final sessionId = await getSessionId();
    print(sessionId);
    final response = await http
        .get(Uri.parse(serverAddress + "api/user/protected"), headers: {
      'Authorization': "Bearer $sessionId",
    });
    if (response.statusCode == 200) {
      print('Request successful: ${response.body}');
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}');
      return false;
    }
  }

  static Future<void> setSession(String id) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("sessionId", id);
  }

  static Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }
}
