import 'package:chat_app/services/auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  @override
  _ForgotpasswordState createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController _emailcontrller = TextEditingController();

  Auth _auth = Auth();
  bool reset = false;

  resetPassEmail(String email) {
    _auth.resetPass(email);
    setState(() {
      reset = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: reset
          ? Container(
              child: Center(
                child: Text(
                    "The password reset email has been sent to your account"),
              ),
            )
          : Center(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailcontrller,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      // fillColor: Colors.green
                    ),
                    validator: (val) {
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val) &&
                              val.length != null
                          ? null
                          : "Please enter a valid mail";
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text("Enter your registered email"),
                  GestureDetector(
                    onTap: () {
                      resetPassEmail(_emailcontrller.text);
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
