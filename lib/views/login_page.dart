import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:chat_app/views/mobile_number_vericaton/emailReset.dart';
import 'package:chat_app/views/mobile_number_vericaton/otp_reg_page.dart';
import 'package:chat_app/views/singup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function viewScreen;
  LoginPage(this.viewScreen);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pascontroller = TextEditingController();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  Auth auth = Auth();
  DatabaseMethods datamethods = DatabaseMethods();
  bool notvalid = false;
  String error = "";
  String error2 = "";

  singInvalidateForm() {
    if (formKey.currentState.validate()) {
      datamethods.getUserbyEmail(emailcontroller.text).then((val) {
        snapshotUserInfo = val;
        Constants.userEmail = emailcontroller.text;

        HelperFunction.saveuserNameInSharedPreferrence(
            snapshotUserInfo.docs[0].get("name"));
      });
      setState(() {
        isLoading = true;
      });
      auth
          .signInWithEmailAndPassword(emailcontroller.text, pascontroller.text)
          .catchError((e) {
        setState(() {
          error = e.toString();
        });
      }).then(
        (value) {
          print("Started");
          if (value != null) {
            print("nnnnnn");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatRoom()));
            HelperFunction.saveuserLoggedInSharedPreferrence(true);
          } else if (value == null) {
            setState(() {
              isLoading = false;
              error2 = "Invalid User..Please Register first";
            });
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      // ),
      backgroundColor: Colors.grey,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(),
    );
  }
}
