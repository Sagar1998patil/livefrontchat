import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Handlers/api.dart';
import '../../Helper/helper.dart';

import '../../Utils/Preferences.dart';
import '../../Utils/colors.dart';
import '../../auth/login.dart';
import '../../models/conversationreciverlist.dart';
import '../../models/messagelist.dart';
import '../../models/userslist_model.dart';

class AuthProvider with ChangeNotifier {

  //conversation
  bool isConverLoading = false;
  bool isConverSuccess = false;

  conversationPost(data, url, context) async {
    print(data);
    print(url);
    print(isRegisterLoading);
    isConverLoading = true;
    notifyListeners();

    print(isRegisterLoading);
    final Uri uri = Uri.parse(API.conversation + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    var body = json.decode(response.body);
    Preferences.setUserId(body['id']);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Preferences.setUserId(body['id']);
    print('User ID set: ${body['id']}');
    prefs.setString('idUser', body['id']);
    prefs.setString('idUser', body['id']);
    prefs.setString('fulname', body['fullName']);
    print(body['id']);
    print("body of login and register ${body}");
    if (response.statusCode == 201 && body["st"] == "Success") {

      isConverLoading = false;
      print(isRegisterLoading);
      notifyListeners();

      if (body['st'] == "Success") {
        isConverSuccess = true;

      }
      //
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(body['msg']),
      // ));
      notifyListeners();
    } else {
      isConverLoading = false;
      isConverSuccess = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['msg']),
      ));
      // Navigator.pop(context);
      notifyListeners();
    }
  }



  bool isRegisterLoading = false;
  bool isRegisterSuccess = false;

  registerPost(data, url, context) async {
    print(data);
    print(url);
    print(isRegisterLoading);
    isRegisterLoading = true;
    notifyListeners();

    print(isRegisterLoading);
    final Uri uri = Uri.parse(API.register + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    var body = json.decode(response.body);
    Preferences.setUserId(body['id']);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await Preferences.setUserId(body['id']);
    print('User ID set: ${body['id']}');
    prefs.setString('idUser', body['id']);
    // prefs.setString('fulname', body['fullName'].toString());
    print(body['id']);
    print("body of login and register ${body}");
    if (response.statusCode == 201 && body["st"] == "Success") {

      print(isRegisterLoading);
      isRegisterLoading = false;
      print(isRegisterLoading);
      notifyListeners();

      if (body['st'] == "Success") {
        isRegisterSuccess = true;

      }
      //
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(body['msg']),
      // ));
      notifyListeners();
    } else {
      print(isRegisterLoading);
      isRegisterLoading = false;
      isRegisterSuccess = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['msg']),
      ));
      // Navigator.pop(context);
      notifyListeners();
    }
  }

  bool isLoginLoading = false;
  bool isLoginSuccess = false;

  loginPost(data, url, context) async {
    print(data);
    print(url);

    isLoginLoading = true;
    notifyListeners();
    // final response = await http.post(Uri.parse(API.register+${url}));

    final Uri uri = Uri.parse(API.login + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    print('come to here${response.body}');

    print("body of login  ${response.statusCode}");
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      print('come to he2re${body['user']['id'].toString()}');
      print('come to he2re${body['user']}');
      await Preferences.setUserId(body['user']['id'].toString());
      // Preferences.setUserId(body['id']);



        print('come to here${body}');

        isLoginLoading = false;
        isLoginSuccess = true;
        notifyListeners();
        print("its true");

        print("body of token  ${body['token']}");
        print("body of token  ${body['msg']}");

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(body['msg']),
        // ));

        print("user login or login response-${body['msg']}");

        notifyListeners();

        return body;

    } else {
      isLoginLoading = false;
      isLoginSuccess = false;
      print("come to here");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Incorrect Password"),
      // ));
      // Navigator.pop(context);
      print("Login  or Login Post Api Error !!");
      notifyListeners();
    }
  }


  bool isgetLoading = false;
  bool isgetSuccess = false;

  List<Userlist> usersDataListUSer = [];
  List<ConversationreciverData> conversationreciverDataList = [];



// Modify your getUserById function like this
  Future<List<Userlist>> getUserById(String userId, context) async {
    var userIdutils;
    String? userId = await Preferences.getUserId();

    print('User ID retrieved: $userId');
    // userIdutils = Preferences.getUserId();
    print(userIdutils);
    print(isgetLoading);
    isgetLoading = true;
    // notifyListeners();

    final Uri uri = Uri.parse(API.idgetDetails + userId.toString()); // Assuming getUserById endpoint
    print("urii ${uri}");
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // Add any additional headers if required
      },
    );
    print(uri);
    print(response.body);

    var body = json.decode(response.body);
    print("body of get user by ID: $body");
    if (response.statusCode == 200) {
      print("response.body");
      isgetLoading = false;
      notifyListeners();

      // if (body['st'] == "Success") {

        List<Userlist> usersData = List<Userlist>.from((
            body['usersData'] as List).map(

                (userJson) => Userlist.fromJson(userJson),
          ),
        );
        // Preferences.setString('fulname', body['fullName']);
      // print(usersData);
      print("usersData");

        for(int i =0; i<=usersData.length;i++){
          usersDataListUSer.add(usersData[i]);
          print("usersData");

        }
        // print(usersDataListUSer[0])
        return usersData;

    } else {
      isgetLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['msg']),
      ));
      notifyListeners();
    }

    // Return an empty list if there's an error or no data
    return [];
  }



  //get user from id
  // bool isgetLoading = false;
  // bool isgetSuccess = false;
  getUserByIdspecific(String userId, context) async {
    var userIdutils;
    String? userId = await Preferences.getUserId();
    print('User ID 2retrieved: $userId');
    // userIdutils = Preferences.getUserId();
    print(userIdutils);
    print(isgetLoading);
    isgetLoading = true;
    // notifyListeners();

    final Uri uri = Uri.parse(API.idgetDetails +"getdetailsfromid/"+ userId.toString()); // Assuming getUserById endpoint
    print("urii ${uri}");
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        // Add any additional headers if required
      },
    );
    print(uri);
    print(response.body);

    var body = json.decode(response.body);
    print("body of get1 user by ID: $body");
    if (response.statusCode == 200 && body["st"] == "Success") {
      isgetLoading = false;
      notifyListeners();

      if (body['st'] == "Success") {
        print("sucess user get if body resw1poonse");
        return body['user'];
      }
    } else {
      isgetLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(body['msg']),
      ));
      notifyListeners();
    }
  }


  //For Sender and reciver........

  getSenderReciverIdToConversationList(data, url, context) async {
    print(data);
    print(url);
    print(isRegisterLoading);
    isConverLoading = true;
    notifyListeners();

    print(isRegisterLoading);
    final Uri uri = Uri.parse(API.conversation + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    // var body = json.decode(response.body);
    // Preferences.setUserId(body['id']);
    print(response.statusCode);
    return response;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await Preferences.setUserId(body['id']);
    // print('User ID set: ${body['id']}');
    // prefs.setString('idUser', body['id']);
    // prefs.setString('idUser', body['id']);
    // prefs.setString('fulname', body['fullName']);
    // print(body['id']);


      // Navigator.pop(context);
      notifyListeners();
    }

   List<ConversationreciverData>? conversationDetailsList;
   List<Messagelist>? messagelist;
  //fetch Conversation
  getConversationdetailsRecieveDeatilsList(String senderID, context) async {
    print("sssnnneder: $senderID");
  var userIdutils;
  String? userId = await Preferences.getUserId();
  // userIdutils = Preferences.getUserId();
  print(userIdutils);
  print(isgetLoading);
  isgetLoading = true;
  // notifyListeners();

      final Uri uri = Uri.parse(API.conversationID +"conversations/"+ senderID.toString()); // Assuming getUserById endpoint
      print("urii ${uri}");
      final response = await http.get(
      uri, headers: {
      'Content-Type': 'application/json',
      // Add any additional headers if required
      },);
      print("uri");
      print(response.body);


      // var body = json.decode(response.body);

      // List<ConversationreciverData> usersDataa = List<ConversationreciverData>.from((
    //     body['usersData'] as List).map(
    //
    //       (userJson) => ConversationreciverData.fromJson(userJson),
    // ),
    // );
    final List<dynamic> responseData = json.decode(response.body);
    print("uri");
    print(responseData);
     conversationDetailsList = responseData.map<ConversationreciverData>((data) {
      return ConversationreciverData.fromJson(data);
    }).toList();
    print("222conversationreciverDataList");

    print(conversationDetailsList);


    // for(int i =0; i<=conversationDetailsList!.length;i++){
    //   conversationreciverDataList.add(conversationDetailsList![i]);
    //   print("conversationreciverDataList");
    //   print(conversationDetailsList);
    //
    // }
    print(conversationDetailsList);
    return conversationDetailsList;

      // print("body of get1 user by ID: $body");
      // if (response.statusCode == 200 && body["st"] == "Success") {
      isgetLoading = false;
      notifyListeners();

      // if (body['st'] == "Success") {
      print("sucess user get if body resw1poonse");
      // return body;
     // }
     //  } else {
     //  isgetLoading = false;
     //  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
     //  // content: Text(body['msg']),
     //  ));
      notifyListeners();
      //}
    }


//post send message
  postsendmessagewithConversationdata(data, url, context) async {
    print(data);
    print(url);
    print(isRegisterLoading);
    isConverLoading = true;
    notifyListeners();

    print(isRegisterLoading);
    final Uri uri = Uri.parse(API.message + url);
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
    print(uri);
    print(response.body);

    // var body = json.decode(response.body);
    // Preferences.setUserId(body['id']);
    print(response.statusCode);
    return response;

  }




  //fetch message
  getfetchMessage(String conversationID, context) async {
  print("sssnnneder: $conversationID");


  print(isgetLoading);
  isgetLoading = true;
  // notifyListeners();

  final Uri uri = Uri.parse(API.messageID +"message/"+ conversationID.toString()); // Assuming getUserById endpoint
  print("urwii ${uri}");
  final response = await http.get(
  uri, headers: {
  'Content-Type': 'application/json',
  // Add any additional headers if required
  },);
  print("uribody");
  print("uribody${response}");
  print(response.body);


  // var body = json.decode(response.body);

  // List<ConversationreciverData> usersDataa = List<ConversationreciverData>.from((
  //     body['usersData'] as List).map(
  //
  //       (userJson) => ConversationreciverData.fromJson(userJson),
  // ),
  // );
  final List<dynamic> responseData = json.decode(response.body);
  print("uri");
  print(responseData);
  messagelist = responseData.map<Messagelist>((data) {
  return Messagelist.fromJson(data);
  }).toList();
  print("22112conversationreciverDataList");

  print(messagelist);


  // for(int i =0; i<=conversationDetailsList!.length;i++){
  //   conversationreciverDataList.add(conversationDetailsList![i]);
  //   print("conversationreciverDataList");
  //   print(conversationDetailsList);
  //
  // }
  print(messagelist);
  return messagelist;

  // print("body of get1 user by ID: $body");
  // if (response.statusCode == 200 && body["st"] == "Success") {
  isgetLoading = false;
  notifyListeners();

  // if (body['st'] == "Success") {
  print("sucess user get if body resw1poonse");
  // return body;
  // }
  //  } else {
  //  isgetLoading = false;
  //  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //  // content: Text(body['msg']),
  //  ));
  notifyListeners();
//}
}


}





