import 'package:chat_app/views/otp_reg_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController pascontroller = TextEditingController();

  validateForm() async {
    if (formKey.currentState.validate()) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                color: Colors.grey[200],
                child: Image(
                  image: AssetImage("android/assets/images/makw.jpg"),
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                    ),
                    Text(
                      "Lets's Chat",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                    ),
                    Text("Login"),
                  ],
                ),
                height: MediaQuery.of(context).size.width / 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Center(
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.height / 3,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Enter Email",
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(25.0),
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
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.height / 3,
                                child: TextFormField(
                                  validator: (val) {
                                    return val.isEmpty || val.length < 6
                                        ? "Enter a Strong Password"
                                        : null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Enter Password ",
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  keyboardType: TextInputType.visiblePassword,
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width / 17,
                              ),
                              GestureDetector(
                                onTap: () {
                                  validateForm();
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
                              SizedBox(height: 15),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtpReg()));
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Text(
                                    "Register New",
                                    style: TextStyle(color: Colors.teal),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Forgot Password.?",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //TODO
                                    },
                                    child: Text(
                                      "Reset",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue),
                                    ),
                                  ),
                                ],
                              )
                            ]),
                      ),
                    ],
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
