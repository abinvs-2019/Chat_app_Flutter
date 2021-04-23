import 'package:chat_app/views/singup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({
    @required this.phoneNumber,
  });
  final String phoneNumber;

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  TextEditingController _otpController1 = TextEditingController();

  Future<bool> loginUser(String phoneNunber) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNunber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpPage()));
          UserCredential result = await _auth.signInWithCredential(credential);
          User user = result.user;
          if (user != null) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => SignUpPage()));
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(""),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: _otpController1,
                        decoration: InputDecoration(
                          labelText: "Enter Otp",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(),
                          ),
                          // fillColor: Colors.green
                        ),
                        validator: (value) {
                          return value.isEmpty || value.length < 6
                              ? "Enter Valid Otp"
                              : null;
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () async {
                          final code = _otpController1.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          UserCredential result =
                              await _auth.signInWithCredential(credential);
                          User user = result.user;
                          if (user != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()));
                          } else {
                            print("error");
                          }
                        },
                        child: Text("confirm"))
                  ],
                );
              });
          AuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: valueOtp);
        },
        codeAutoRetrievalTimeout: null);
  }

  @override
  void initState() {
    final phone = "+91${widget.phoneNumber}";
    print(phone);
    loginUser(phone);
    // TODO: implement initState
    super.initState();
  }

  String valueOtp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Otp Verification",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text("Verifying Otp Automatically"),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Center(
                  child: Row(
                    children: [
                      Text("Verfitying Your otp sent to"),
                      Text(
                        widget.phoneNumber,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        "Verifying Otp...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
              width: MediaQuery.of(context).size.width,
            ))
          ],
        ),
      ),
    );
  }
}
