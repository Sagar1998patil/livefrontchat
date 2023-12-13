// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Dashboard(),
//     );
//   }
// }
//
// class Dashboard extends StatefulWidget {
//   @override
//   _DashboardState createState() => _DashboardState();
// }
//
// class _DashboardState extends State<Dashboard> {
//   IO.Socket? socket;
//   User? user;
//   List<Conversation> conversations = [];
//   List<ChatMessage> messages = [];
//   String message = "";
//   List<User> users = [];
//   TextEditingController messageController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     getUserFromLocalStorage().then((user) {
//       setState(() {
//         this.user = user;
//       });
//     });
//
//     socket = IO.io('http://localhost:8080', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': true,
//     });
//
//     socket!.on('getUsers', (users) {
//       print("Active Users: $users");
//     });
//
//     socket!.on('getMessage', (data) {
//       setState(() {
//         messages.add(ChatMessage(
//           user: User.fromJson(data['user']),
//           message: data['message'],
//         ));
//       });
//     });
//
//     socket!.emit('addUser', user!.id);
//
//     fetchConversations();
//     fetchUsers();
//   }
//
//   Future<void> fetchConversations() async {
//     final response = await http.get(
//       Uri.parse('http://localhost:8000/api/conversations/${user?.id}'),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> resData = json.decode(response.body);
//       setState(() {
//         conversations = resData.map<Conversation>((data) => Conversation(
//           conversationId: data['conversationId'],
//           user: User.fromJson(data['user']),
//         )).toList();
//       });
//     } else {
//       throw Exception('Failed to load conversations');
//     }
//   }
//
//   Future<void> fetchUsers() async {
//     final response = await http.get(
//       Uri.parse('http://localhost:8000/api/users/${user?.id}'),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> resData = json.decode(response.body);
//       setState(() {
//         users = resData.map<User>((data) => User.fromJson(data)).toList();
//       });
//     } else {
//       throw Exception('Failed to load users');
//     }
//   }
//
//   Future<void> fetchMessages(Conversation conversation) async {
//     final response = await http.get(
//       Uri.parse('http://localhost:8000/api/message/${conversation.conversationId}?senderId=${user?.id}&&receiverId=${conversation.user.id}'),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     if (response.statusCode == 200) {
//       final List<dynamic> resData = json.decode(response.body);
//       setState(() {
//         messages = resData.map<ChatMessage>((data) =>
//             ChatMessage(
//               user: User.fromJson(data['user'] ?? {}),
//               message: data['message'],
//             ),
//         ).toList();
//       });
//     } else {
//       throw Exception('Failed to load messages');
//     }
//   }
//
//   Future<void> sendMessage() async {
//     if (message.isNotEmpty) {
//       socket!.emit('sendMessage', {
//         'senderId': user!.id,
//         'receiverId': messages.isNotEmpty ? messages.first.user.id : "",
//         'message': message,
//         'conversationId':
//         messages.isNotEmpty ? messages.first.conversationId : "",
//       });
//
//       setState(() {
//         messages.add(ChatMessage(user: user!, message: message));
//         message = "";
//       });
//
//       await fetchMessages(Conversation(
//         conversationId: messages.isNotEmpty
//             ? messages.first.conversationId
//             : "new",
//         user: messages.isNotEmpty ? messages.first.user : User(),
//       ));
//     }
//   }
//
//   Future<User?> getUserFromLocalStorage() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userDataString = prefs.getString('user:detail');
//     if (userDataString != null) {
//       try {
//         final userData = json.decode(userDataString);
//         return User.fromJson(userData);
//       } catch (e) {
//         print('Error parsing user data: $e');
//         return null;
//       }
//     } else {
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Sidebar with users and conversations
//           buildSidebar(),
//           // Main chat area with messages
//           buildMainChatArea(),
//           // Sidebar with additional users
//           buildAdditionalUsersSidebar(),
//         ],
//       ),
//     );
//   }
//
//   Widget buildSidebar() {
//     return Container(
//       width: 200,
//       color: Colors.blueGrey[100],
//       // Implement the sidebar with users and conversations here
//     );
//   }
//
//   Widget buildMainChatArea() {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(16),
//         color: Colors.white,
//         // Implement the main chat area with messages here
//       ),
//     );
//   }
//
//   Widget buildAdditionalUsersSidebar() {
//     return Container(
//       width: 200,
//       color: Colors.blueGrey[100],
//       // Implement the sidebar with additional users here
//     );
//   }
// }
//
// class User {
//   final String id;
//   final String fullName;
//   final String email;
//
//   User({
//     required this.id,
//     required this.fullName,
//     required this.email,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'] ?? "",
//       fullName: json['fullName'] ?? "",
//       email: json['email'] ?? "",
//     );
//   }
// }
//
// class Conversation {
//   final String conversationId;
//   final User user;
//
//   Conversation({
//     required this.conversationId,
//     required this.user,
//   });
// }
//
// class ChatMessage {
//   final User user;
//   final String message;
//
//   ChatMessage({
//     required this.user,
//     required this.message,
//   });
// }
