import 'package:chat_app/views/login_page.dart';
import 'package:chat_app/views/mobile_number_vericaton/otp_reg_page.dart';
import 'package:chat_app/views/singup_page.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool showSignin = true;
  void viewScreen() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignin) {
      return LoginPage(viewScreen);
    } else {
      return OtpReg(viewScreen);
    }
  }
}
