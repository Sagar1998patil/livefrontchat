import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../Utils/Preferences.dart';
import '../auth/login.dart';
import '../models/userslist_model.dart';
import '../providers/autheticationProvider/UserRegistrationProvider.dart';
import '../splashscreen/splashscreen.dart';
import 'chatuser/chatusers.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final FocusNode textFocusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  List<String> messagesList = [];


  AuthProvider? authProvider;
  String? currentUser;
  List<String> userList = [];
  List<User> usersList = []; // Updated list to store User instances

  io.Socket? socket;
  TextEditingController usernameController = TextEditingController();
  var ueserID;

  // Get user ID
  String? userIdutils, fullname;
  var reciveIdParticularindex;
  Future<void> saveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = await Preferences.getUserId();

    ueserID = prefs.getString('idUser');
    fullname = prefs.getString('fulname');
    print("fullnamefullname${fullname}");
    print("fullnamefullname${userId}");

    // prefs.setBool('isLoggedIn', true);
  }

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    // userIdutils = Preferences.getUserId();

    getuserDetails();
    saveToken();
    getuserDetailsfromid();
    initSocket();
  }

  void initSocket() {
    socket = io.io(
      'https://chatapp1-d12f.onrender.com/',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );
    socket!.connect();
    setupConnectionHandlers();
  }

  void setupConnectionHandlers() {
    socket!.on('connect', onConnect);
    socket!.on('userList', onUserList);
    socket!.on('errorMessage', onErrorMessage);
    // socket!.on('disconnect', onDisconnect);
  }

  void onConnect(dynamic _) {
    print('Connected to server');
    socket!.on('getUsers', (users) {
      print("Active Users: $users");
    });
    socket!.emit('setUsername', userName);
    // widget.socket!.emit('setUsername', userName);

    print('Connected to userName ${userName}');
  }

  void onUserList(dynamic data) {
    print('Received userList data: $data');
    setState(() {
      userList = List<String>.from(data);
      final senderSocketId = socket!.id;
      final receiverSocketId;

      print('Sender Socket ID: $senderSocketId');
      // print('Receiver Socket ID: $receiverSocketId');
      print('Received userList userList: $userList');
    });
  }

  // void onDisconnect(dynamic _) {
  //   print('Disconnected from server');
  //   setState(() {
  //     userList.clear(); // Clear the existing list
  //   });
  // }

  void onErrorMessage(dynamic message) {
    print('Error: $message');
  }

//old code for socket

  /* initSocket() {
    socket = io.io('https://chatapp1-d12f.onrender.com/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();
    socket!.on('connect', (_) {
      print('Connected to server');
      socket!.emit('setUsername', userName);

      socket!.on('userList', (data) {
        print('Received userList data: $data');
        setState(() {
          userList = List<String>.from(data);
          print('Received userList userList: $userList');
        });
      });
    });

    */ /* socket!.on('privateMessage', (data) {
      print('Received privateMessage: $data');
      setState(() {
        messagesList.add('${data['from']}: ${data['message']}');
      });
    });*/ /*
    // socket!.on('roomMessage', (data) {
    //   setState(() {
    //     messagesList.add('${data['from']} (Room): ${data['message']}');
    //   });
    // });

    socket!.on('errorMessage', (message) {
      print('Error: $message');
    });
  }*/

  String? userName, senderIdUser;
  int? selectedIndex;

  getuserDetailsfromid() async {
    await authProvider!
        .getUserByIdspecific(userIdutils.toString(), context)
        .then((value) {
      print("che vaue ${value}");
      userName = value['fullName'];
      senderIdUser = value['id'];
      print("che vaue ${userName}");
      if (authProvider!.isgetSuccess) {}
    });
  }

  getuserDetails() async {
    try {
      List<Userlist> usersList =
          await authProvider!.getUserById(userIdutils.toString(), context);
      print('User ID retrieved: $userIdutils');

      for (var userEntry in usersList) {
        User user = userEntry.user;

        print("Email: ${user.email}");
        print("FullName: ${user.fullName}");
        print("ReceiverId: ${user.receiverId}");
      }

      // Other logic after fetching user details, if needed
      if (authProvider!.isgetSuccess) {
        // Handle success if needed
      }
    } catch (error) {
      // Handle errors if any
      print("Error fetching user details: $error");
    }
  }

  @override
  void dispose() {
    socket!.disconnected;
    // Disconnect the socket when the screen is disposed
    socket!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    authProvider = Provider.of<AuthProvider>(context, listen: true);
    Future<bool> showExitPopUp() async {
      return await showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        top: 18.0,
                      ),
                      margin: EdgeInsets.only(top: 13.0, right: 8.0),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Text("Are you sure to exit ?",
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.black)),
                          ) //
                              ),
                          SizedBox(height: 24.0),
                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                    bottomRight: Radius.circular(16.0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    // passing true
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.black26,
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    // passing false
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black26),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopUp,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Welcome ${userName}"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                // Clear all data in shared preferences
                prefs.setBool('isLoggedIn', false);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginPage()));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Text(
              'User Online',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black26,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              height: MediaQuery.of(context).size.height /
                  6, // Adjust the height as needed
              child: /*ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  currentUser = userList[index];
                  print("its give current index ? ${currentUser}");
                  // currentUser = userList[selectedIndex!];
                  if (currentUser == userName) {
                    return SizedBox.shrink(); // Skip this item
                  }
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        // final senderSocketId = socket!.id;
                        // final receiverSocketId = data['socketId'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              selectedUser: userList[index],
                              socket: socket!,
                            ),
                          ),
                        );
                      });

                      print("Selected index: $selectedIndex");
                      print("Selected user: ${userList[selectedIndex!]}");
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: Card(
                        color: index == selectedIndex ? Colors.blue : null,
                        // Change the color for selected item
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.blue,
                                // Set your desired background color
                                child: Text(
                                  currentUser != null &&
                                          currentUser!.isNotEmpty
                                      ? currentUser![0]
                                          .toUpperCase() // Display the first letter in uppercase
                                      : '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      // Set your desired text color
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(currentUser.toString().trim()),
                                    Expanded(
                                        child: SizedBox(
                                      width: 20,
                                    )),
                                    Icon(
                                      Icons
                                          .do_not_disturb_on_total_silence_rounded,
                                      color: Colors.green.shade600,
                                      size: 10,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),*/
                  ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: authProvider!.usersDataListUSer.length,
                // Use usersList instead of userList
                itemBuilder: (context, index) {
                  // print("Emaimml: ${ authProvider!.usersDataListUSe[index]}");
                  var reciveIdParticularindex = authProvider!.usersDataListUSer[index].user.receiverId;
                  // var ConversationidreciveIdParticularindex = authProvider!.usersDataListUSer[index].u;

                  // User currentUser =  authProvider!.usersDataListUSer[index];
                  print("Email: ${reciveIdParticularindex}");
                  // print("FullName: ${currentUser.fullName}");

                  return InkWell(
                    onTap: () async {
                          var data = {
                          "senderId": senderIdUser,
                          "receiverId":reciveIdParticularindex,
                          };

                          await authProvider!.getSenderReciverIdToConversationList(data, "conversation", context)
                              .then((value) async {
                            print("Responsecheck: $value");

                           await authProvider!.getConversationdetailsRecieveDeatilsList(senderIdUser!,context);
                            print("Senderuserid: ${senderIdUser}");
                          } );},
                      // Handle onTap as needed

                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: Card(
                        // Card details as needed
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Your card content
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blue,
                                // Set your desired background color
                                child: Text(
                                  authProvider!.usersDataListUSer[index].user !=
                                              null &&
                                          authProvider!.usersDataListUSer[index]
                                              .user.fullName!.isNotEmpty
                                      ? authProvider!.usersDataListUSer[index]
                                          .user.fullName![0]
                                          .toUpperCase() // Display the first letter in uppercase
                                      : '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      // Set your desired text color
                                      fontSize: 8,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${authProvider!.usersDataListUSer[index].user.email}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        "${authProvider!.usersDataListUSer[index].user.fullName}"),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              // Other card content
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 40,),
            Text("Conversation"),

            Container(
              height: MediaQuery.of(context).size.height /
                  4,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: authProvider!.conversationDetailsList!.length,
                // Use usersList instead of userList
                itemBuilder: (context, index) {
                  print("Emaimml: ${ authProvider!.conversationDetailsList![index]}");
                  print("Emaimml: ${ authProvider!.conversationDetailsList![index].conversationId}");
                   reciveIdParticularindex = authProvider!.conversationDetailsList![index].conversationId;

                  // User currentUser =  authProvider!.usersDataListUSer[index];
                  print("conversationEmail: ${reciveIdParticularindex}");
                  // print("FullName: ${currentUser.fullName}");

                  return InkWell(
                    onTap: () async {
                   /*   var data = {
                        "senderId": senderIdUser,
                        "receiverId":reciveIdParticularindex,
                      };

                      await authProvider!.getSenderReciverIdToConversationList(data, "conversation", context)
                          .then((value) async {
                        print("Responsecheck: $value");

                        await authProvider!.getConversationdetailsRecieveDeatilsList(senderIdUser!,context);
                        print("Senderuserid: ${senderIdUser}");
                      } );*/
                    },
                    // Handle onTap as needed

                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 20, right: 20, top: 8),
                      child: Card(
                        // Card details as needed
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Your card content
                              // CircleAvatar(
                              //   radius: 10,
                              //   backgroundColor: Colors.blue,
                              //   // Set your desired background color
                              //   child: Text(
                              //     authProvider!.usersDataListUSer[index].user !=
                              //         null &&
                              //         authProvider!.usersDataListUSer[index]
                              //             .user.fullName!.isNotEmpty
                              //         ? authProvider!.usersDataListUSer[index]
                              //         .user.fullName![0]
                              //         .toUpperCase() // Display the first letter in uppercase
                              //         : '',
                              //     style: TextStyle(
                              //         color: Colors.white,
                              //         // Set your desired text color
                              //         fontSize: 8,
                              //         fontWeight: FontWeight.w600),
                              //   ),
                              // ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${authProvider!.conversationDetailsList![index].user!.fullName}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                        "${authProvider!.conversationDetailsList![index].user!.email}"),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              // Other card content
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: ListView.builder(
                // itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  // final isCurrentUserMessage =
                  // messagesList[index].startsWith('You');

                  return Align(
                    alignment:/* isCurrentUserMessage
                        ? Alignment.centerRight
                        : */Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        color:
                       /* isCurrentUserMessage ? Colors.lightBlue :*/ Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(/*
                        messagesList[index*//**//*]"*/"hi",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: 'Type a message...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // sendPrivateMessage();
                          var data = {
                          "conversationId": reciveIdParticularindex,
                          "senderId": senderIdUser,
                          "message": messageController.text
                          };

                          await authProvider!.postsendmessagewithConversationdata(data, "message", context)
                              .then((value) {
                            print("Responsecheck: $value");
                          });},

    child: Text('Send'))

            ]  ),
            ),

          ],
        ),
      ),
    );
  }
}
