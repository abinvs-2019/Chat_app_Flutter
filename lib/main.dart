import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/screen_helper.dart/screen_helper.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
        home: Splash());
  }
}

//  userIsLoggedIn ? ChatRoom() :
class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('caution').snapshots(),
        // ignore: missing_return
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (streamSnapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                itemCount: streamSnapshot.data.docs.length,
                itemBuilder: (ctx, index) {
                  return Text(streamSnapshot.data.docs[index]['message']);
                });
          } else if (streamSnapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text('App is Under Maintenance'),
            );
          } else if (streamSnapshot.connectionState == ConnectionState.active) {
            return Center(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: streamSnapshot.data.docs.length,
                  itemBuilder: (ctx, index) {
                    return Text(streamSnapshot.data.docs[index]['message']);
                  }),
            );
          }
          print(streamSnapshot.connectionState);
          print(streamSnapshot.data);

          return Container();
        },
      ),
    );
  }
}
