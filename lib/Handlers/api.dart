import 'dart:io';

import '../Utils/Preferences.dart';


class API {

  static const apiKey = "base64:9wMwQDEBjAK5OVvehRlQhF5PE1dNk6xK3RRIUkcDyGA=";
  static const baseUrl = "https://liveserverbackend.onrender.com/"; // live


  static Map<String, String> authheader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'apikey': apiKey,
  };
  static Map<String, String> header = {
    // HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    // 'apikey': apiKey,
    'Authorization': "Bearer ${Preferences.getString(Preferences.accesstoken)}"
  };


  static const login = "${baseUrl}api/";
  static const register = "${baseUrl}api/";
  static const idgetDetails = "${baseUrl}api/users/";
  static const conversation = "${baseUrl}api/";
  static const message = "${baseUrl}api/";
  static const messageID = "${baseUrl}api/";
  static const conversationID = "${baseUrl}api/";

}
