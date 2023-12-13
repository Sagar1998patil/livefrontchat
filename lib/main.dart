import 'package:flutter/material.dart';
import 'package:livefrontchat/providers/autheticationProvider/UserRegistrationProvider.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashhome.dart';
import 'splashscreen/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(

      providers: [

        ChangeNotifierProvider(create: (context) => AuthProvider()),


      ],
      child: MaterialApp(
        title: 'LiveChatapp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  SplashScreen(),
        // home:  Dashboard(),
      ),
    );
  }
}

