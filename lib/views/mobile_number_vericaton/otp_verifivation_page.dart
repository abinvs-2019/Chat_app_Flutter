import 'package:chat_app/views/singup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          Navigator.pushReplacement(
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
                            return Text("Enter Valid Otp");
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

  otpsetagain() async {
    await loginUser(widget.phoneNumber);
    Fluttertoast.showToast(
        msg: "Otp sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  @override
  void initState() {
    final phone = "+91${widget.phoneNumber}";
    print(phone);
    loginUser(phone);

    super.initState();
  }

  String valueOtp;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Otp Verification",
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        "Verfitying Your otp sent to",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "+91 ${widget.phoneNumber}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
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
                          "Verifying Otp Automatically",
                          style: TextStyle(color: Colors.white),
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          otpsetagain();
        },
      ),
    );
  }
}
