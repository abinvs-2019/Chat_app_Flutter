import 'package:chat_app/views/login_page.dart';
import 'package:chat_app/views/otp_verifivation_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpVerify extends StatefulWidget {
  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  TextEditingController phoneNunber = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.teal,
                child: Image(
                  image: AssetImage(''),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: phoneNunber,
                            decoration:
                                textFiledInputDecoration("Enter your Phone"),
                            validator: (val) {
                              return val.length < 10
                                  ? null
                                  : "Please enter a valid Phone";
                            },
                            keyboardType: TextInputType.phone,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account"),
                              GestureDetector(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpVerification(
                                        phoneNumber: phoneNunber.toString(),
                                      ),
                                    ),
                                  );
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
      ),
    );
  }
}
