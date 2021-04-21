import 'dart:html';

import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pascontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.teal,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.teal,
                  child: Image(
                    image: AssetImage("android/assets/images/makw.jpg"),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      children: [
                        Form(
                          key: formkey,
                          child: Column(children: [
                            TextFormField(
                              decoration:
                                  textFiledInputDecoration("Enter your email"),
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please enter a valid mail";
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                            TextFormField(
                              decoration: textFiledInputDecoration("Password"),
                              validator: (val) {
                                if (val.length == 0 && val.length < 6) {
                                  return "Passward cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              color: Colors.teal,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                color: Colors.teal,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Register New",
                                  style: TextStyle(color: Colors.white),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            Text("Forgot Password.?"),
                            Text(
                              "Reset",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
