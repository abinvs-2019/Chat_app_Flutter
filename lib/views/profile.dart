import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/login_page.dart';
import 'package:chat_app/views/singup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  QuerySnapshot snapshotUserInfo;
  DatabaseMethods datamethods = DatabaseMethods();
  String profieImg;
  String name = Constants.myName;

  signout() async {
    await authMethod.signOut();
    HelperFunction.saveuserLoggedInSharedPreferrence(false);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage(null)));
  }

  @override
  void initState() {
    super.initState();
    datamethods.getUserbyUsername(name).then((val) {
      snapshotUserInfo = val;
      setState(() {
        profieImg = snapshotUserInfo.docs[0].data()["profileImage"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('$profieImg'),
                    backgroundColor: Colors.grey[400],
                    child: Image.network('$profieImg'),
                    radius: 120,
                  ),
                  Text(
                    name == null ? "" : name,
                  ),
                  Text(Constants.userEmail == null ? "" : Constants.userEmail),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              signout();
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width / 1.1,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
