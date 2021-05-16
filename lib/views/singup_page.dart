import 'dart:io';
import 'dart:math';

import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:chat_app/views/login_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  // final Function viewScreen;
  // SignUpPage(this.viewScreen);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

bool isLoading = false;
Auth authMethod = new Auth();
HelperFunction helperfunction = HelperFunction();
TextEditingController _userNamecontroller = TextEditingController();
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _passcontroller = TextEditingController();
String profileImageUrl;
String _path;
Map<String, String> _paths;
String _extension;
FileType _pickType;
File file;
bool isUploaded = false;
bool isUploading = false;

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  signUpvalidateForm() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfo = {
        "name": _userNamecontroller.text.toLowerCase(),
        "email": _emailcontroller.text,
        "profileImage": profileImageUrl,
      };
      HelperFunction.saveuserEmailInSharedPreferrence(_emailcontroller.text);
      HelperFunction.saveuserNameInSharedPreferrence(_userNamecontroller.text);
      setState(() {
        isLoading = true;
      });

      authMethod
          .signUpWithEmailAndPaaword(
              _emailcontroller.text, _passcontroller.text)
          .then((val) {
        if (val == null) {
          print(e.toString());
        }
        print("controller$_emailcontroller");
        print("$val");

        DatabaseMethods().uploadUserInfo(userInfo);
        HelperFunction.saveuserLoggedInSharedPreferrence(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  void openImageFile() async {
    try {
      _path = null;
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
      if (result != null) {
        file = File(result.files.single.path);
        print(file);
        _path = file.path;
        print(_path);
      }
      // _path = await FilePicker.platform
      //     .getFilePath(type: _pickType, fileExtention: _extension);

      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    print("nnnnnnnnnnn");
    if (_path != null) {
      String fileName = _path.split('/').last;
      String filePath = _path;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) async {
    _extension = fileName.toString().split('.').last;
    Reference storageRef =
        FirebaseStorage.instance.ref().child("profileIMages/$fileName");
    setState(() {
      isUploading = true;
    });
    final UploadTask uploadTask = storageRef.putFile(
      File(filePath),
    );
    print("yyyyyyyyyyyyy");
    String imageUrl = await storageRef.getDownloadURL();
    setState(() {
      Constants.userProfilePic = imageUrl;
      isUploaded = true;
      isUploading = false;
    });

    _extension = null;
  }

  @override
  Widget build(BuildContext context) {
    String pass;
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    isUploaded
                        ? GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 190.0,
                              height: 190.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage('$profileImageUrl'),
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              openImageFile();
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  isUploading
                                      ? CircularProgressIndicator()
                                      : Icon(Icons.add_a_photo),
                                  Text("Upload your dp")
                                ],
                              ),
                              color: Colors.teal,
                              width: 190.0,
                              height: 190.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                          Text("Register Account"),
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
                                            MediaQuery.of(context).size.height /
                                                3,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _userNamecontroller,
                                              decoration: InputDecoration(
                                                labelText: "Enter a username",
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          25.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                // fillColor: Colors.green
                                              ),
                                              validator: (val) {
                                                return val.length != null ||
                                                        val.length < 4
                                                    ? null
                                                    : "Please enter a username";
                                              },
                                              keyboardType: TextInputType.name,
                                              style: new TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            TextFormField(
                                              controller: _emailcontroller,
                                              decoration: InputDecoration(
                                                labelText: "Enter Email",
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.height / 3,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _passcontroller,
                                          validator: (val) {
                                            pass = val;
                                            return val.isEmpty || val.length < 6
                                                ? "Enter a Strong Password"
                                                : null;
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
                                        SizedBox(
                                          width: 10,
                                        ),
                                        TextFormField(
                                          validator: (val) {
                                            return val.isEmpty ||
                                                    val.length < 6 ||
                                                    pass != val
                                                ? "Password does not match!!"
                                                : null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: "Re-Enter Password ",
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
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.width / 17,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      signUpvalidateForm();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Register",
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
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage(null)));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                        "Already Have an Account",
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
                                ],
                              ),
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
