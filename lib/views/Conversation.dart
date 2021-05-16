import 'dart:io';
import 'package:chat_app/views/imageViewer.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  String imgURL;
  Stream chatmessageStream;
  String _path;
  Map<String, String> _paths;
  String _extension;
  FileType _pickType;
  File file;
  int lenght;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatmessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    lenght = snapshot.data.docs.length;
                    return Column(
                      children: [
                        MessageTile(
                          imageUrl: snapshot.data.docs[index].data()['imgUrl'],
                          message: snapshot.data.docs[index].data()['message'],
                          msgEmpty:
                              snapshot.data.docs[index].data()['message'] ==
                                  null,
                          isSentByMe:
                              snapshot.data.docs[index].data()['sendBy'] ==
                                  Constants.myName,
                        )
                      ],
                    );
                  })
              : Container(
                  child: Center(child: Text("NO DATA")),
                );
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      print(messageController.text);
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "imgUrl": null
      };

      DatabaseMethods().addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }
  }

  sendImage() {
    print(messageController.text);
    Map<String, dynamic> messageMap = {
      "message": null,
      "sendBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "imgUrl": imgURL
    };

    DatabaseMethods().addConversationMessages(widget.chatRoomId, messageMap);
    messageController.text = "";
  }

  void openImageFile() async {
    try {
      _path = null;
      FilePickerResult result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png']);
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
      print(
        "Unsupported operation" + e.toString(),
      );
      toastShoer(e.toString());
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
    toastShoer("Sending Image...");
    _extension = fileName.toString().split('.').last;
    Reference storageRef =
        FirebaseStorage.instance.ref().child("chats/$userName/$fileName");
    final UploadTask uploadTask = storageRef.putFile(
      File(filePath),
    );
    print("yyyyyyyyyyyyy");
    imgURL = await storageRef.getDownloadURL();
    print(imgURL);
    _extension = null;
    await sendImage();
  }

  toastShoer(String msessageOfToast) {
    Fluttertoast.showToast(
        msg: msessageOfToast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  String userName;
  @override
  void initState() {
    userName = Constants.usernameFOrProfile;
    DatabaseMethods().getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatmessageStream = value;
        print("value$value");
        print("chatmessagestream$chatmessageStream");
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(Constants.usernameFOrProfile == null
            ? ""
            : Constants.usernameFOrProfile),
      ),
      body: Stack(
        children: [
          Container(
            child: chatMessageList() == null
                ? Container(
                    child: Center(child: Text("no Messgaes Yest, null")),
                  )
                : chatMessageList(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        openImageFile();
                      },
                      icon: Icon(Icons.file_copy)),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: "Message", border: InputBorder.none),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // nitiateSearch();
                      sendMessage();
                    },
                    child: Container(
                      child: Icon(
                        Icons.send_sharp,
                        size: 35,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color color;
}

class MessageTile extends StatelessWidget {
  final String message;
  final String imageUrl;
  final bool isSentByMe;
  final bool msgEmpty;
  MessageTile({
    this.message,
    this.msgEmpty,
    this.imageUrl,
    this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    print("$imageUrl");
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSentByMe ? 0 : 24,
          right: isSentByMe ? 24 : 0),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: msgEmpty
          ? InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImageViewer()));
              },
              child: Container(
                height: 200,
                width: 200.0,
                color: Color.fromRGBO(0, 0, 0, 0.2),
                padding: EdgeInsets.all(5),
                child: Image.network(
                    '$imageUrl' == null ? '$imageUrl' : '$imageUrl'),
              ),
            )
          : Container(
              margin: isSentByMe
                  ? EdgeInsets.only(left: 30)
                  : EdgeInsets.only(right: 30),
              padding:
                  EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: isSentByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomLeft: Radius.circular(23))
                    : BorderRadius.only(
                        topLeft: Radius.circular(23),
                        topRight: Radius.circular(23),
                        bottomRight: Radius.circular(23)),
                color: isSentByMe ? Colors.green : Colors.black,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }
}

// class BUildedContainer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       child: Container(
//         color: Colors.white,
//         child: Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   openFileExplorer();
//                 },
//                 icon: Icon(Icons.file_copy)),
//             Expanded(
//               child: Container(
//                 color: Colors.white,
//                 child: TextField(
//                   controller: messageController,
//                   decoration: InputDecoration(
//                       hintText: "Message", border: InputBorder.none),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 // nitiateSearch();
//                 sendMessage();
//               },
//               child: Container(
//                 child: Icon(
//                   Icons.send_sharp,
//                   size: 35,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// dynamic image = await ImagePicker.platform
//                               .pickImage(source: ImageSource.gallery);
//                           print(image);
//                           setState(() {
//                             _image = image;
//                           });
//                           int timestamp =
//                               new DateTime.now().millisecondsSinceEpoch;
//                           Reference storageReference = FirebaseStorage.instance
//                               .ref()
//                               .child(
//                                   'chats/img_' + timestamp.toString() + '.jpg');

//                           UploadTask uploadTask =
//                               storageReference.putFile(image);
//                           await uploadTask.whenComplete(() async {
// String fileUrl = await storageReference.getDownloadURL();
//                             sendImage(fileUrl);
