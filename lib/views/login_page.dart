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
            snapshotUserInfo.docs[0].data()["name"]);
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
    var height = MediaQuery.of(context).size.height;
    var widht = MediaQuery.of(context).size.width;
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
          : Container(
              height: height,
              width: widht,
              child: SingleChildScrollView(
                child: Container(
                  height: height,
                  width: widht,
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Container(
                        width: widht,
                        color: Colors.grey[350],
                        child: Image(
                            image:
                                AssetImage('android/assets/images/makw.jpg')),
                      ),
                      SizedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height / 30,
                            ),
                            Text(
                              "Let's Chat",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ),
                            Text("Login"),
                          ],
                        ),
                        height: height / 10,
                      ),
                      Container(
                        width: widht / 1.1,
                        child: Center(
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                            child: TextFormField(
                                              controller: emailcontroller,
                                              decoration: InputDecoration(
                                                labelText: "Enter your Email",
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
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
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: new TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height / 80),
                                      Container(
                                        alignment: Alignment.center,
                                        width: height / 3,
                                        child: TextFormField(
                                          controller: pascontroller,
                                          validator: (val) {
                                            if (notvalid == true) {
                                              return "Account Not registered";
                                            }
                                            return val.length != null
                                                ? null
                                                : "Please enter a valid pass";
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Enter Password ",
                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      25.0),
                                              borderSide: new BorderSide(),
                                            ),
                                          ),
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          style: new TextStyle(
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          "$error" ?? "$error2",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.width /
                                                17,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          singInvalidateForm();
                                        },
                                        child: GestureDetector(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: widht,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.teal,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OtpReg(null),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: widht,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            "Register New",
                                            style:
                                                TextStyle(color: Colors.teal),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Forgot Password.?",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          GestureDetector(
                                            child: Text(
                                              "Reset",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.blue),
                                            ),
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Forgotpassword()));
                                            },
                                          ),
                                        ],
                                      )
                                    ]),
                              ),
                              SizedBox(
                                height: height / 30,
                              ),
                              Text("v1.16.21"),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
