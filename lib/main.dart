import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screen_helper.dart/screen_helper.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getuserLoggedInSharedPreferrence().then(
      (value) {
        print("sharedpreference$value");
        setState(() {
          value == null ? userIsLoggedIn = false : userIsLoggedIn = value;
          print("sharedpreference$value");
          print("userIsLoggedIn$userIsLoggedIn");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: userIsLoggedIn ? ChatRoom() : AuthenticationPage());
  }
}
//  userIsLoggedIn ? ChatRoom() :
