import 'package:chat_app/views/login_page.dart';
import 'package:chat_app/views/otp_verifivation_page.dart';
import 'package:chat_app/views/singup_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class OtpReg extends StatefulWidget {
  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpReg> {
  TextEditingController phoneNunber = TextEditingController();

  final formKey = GlobalKey<FormState>();
  validateForm() async {
    if (formKey.currentState.validate()) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text("data"),
          Expanded(
            child: Container(
              child: Image(
                image: AssetImage('android/assets/images/abcd_4x.webp'),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 25,
                          child: Text(
                            "Verify Your Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                        ),
                        Text("Login"),
                      ],
                    ),
                    height: MediaQuery.of(context).size.width / 5,
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextFormField(
                            validator: (val) {
                              return val.length < 10 ||
                                      val.isEmpty ||
                                      val.length > 10
                                  ? "Please enter a valid Phone Number"
                                  : null;
                            },
                            controller: phoneNunber,
                            decoration: InputDecoration(
                              labelText: "Enter Phone Number",
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            keyboardType: TextInputType.phone,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            await validateForm();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpVerification(
                                        phoneNumber: phoneNunber.text)));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 1.5,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account"),
                            GestureDetector(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue),
                              ),
                              onTap: () {
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
