import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/video_call/src/pages/call.dart';
import 'package:chat_app/video_call/src/video_reseaving_page.dart';
import 'package:chat_app/views/imageViewer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/services/database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageController = TextEditingController();
  String imgURL, imageUrl;
  Stream chatmessageStream;
  String _path;
  Map<String, String> _paths;
  String _extension;
  FileType _pickType;
  File file;
  int lenght;
  String folderLocation;
  bool loading = false;
  ScrollController _controller = ScrollController();
  Dio dio = Dio();

  Future<bool> saveFile(String url, String filename) async {
    if (await _requestPermission(Permission.storage)) {
      Directory directory;
      directory = await getExternalStorageDirectory();
      print(directory.path);
      String appPath = "";
      List<String> folders = directory.path.split("/");

      for (int x = 1; x < folders.length; x++) {
        String folder = folders[x];
        if (folder != "Android") {
          appPath = "/" + folder;
        } else {
          break;
        }
      }
      appPath = appPath + "/ChatApp";
      directory = Directory(appPath);
      folderLocation = directory.path;
      print(directory.path);
      dio.download('$url', folderLocation);

      setState(() {
        MessageTile(localDirectory: folderLocation);
      });
    } else {
      return false;
    }
    return false;
  }

  downloadFile(String url, String filename) async {
    String urL = url;
    String fileName = filename;

    setState(() {
      loading = true;
    });
    bool dowloaded = await saveFile(urL, fileName);

    setState(() {
      loading = false;
    });
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == permission.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  lenghtChage() {
    Timer(
      Duration(milliseconds: 300),
      () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatmessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _controller,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    lenght = snapshot.data.docs.length;
                    return Column(
                      children: [
                        MessageTile(
                          channelName:
                              snapshot.data.docs[index].data()['video_call'],
                          isvideo_call:
                              snapshot.data.docs[index].data()['video_call'] ==
                                  null,
                          imageUrl: snapshot.data.docs[index].data()['imgUrl'],
                          imgEmpty:
                              snapshot.data.docs[index].data()['imgUrl'] ==
                                  null,
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
                  child: Center(child: Text("No Chats yet?..Start by typing.")),
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
        "imgUrl": null,
        "video_call": null
      };

      DatabaseMethods().addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
      lenghtChage();
    }
  }

  sendImage() {
    print(messageController.text);
    Map<String, dynamic> messageMap = {
      "message": null,
      "sendBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "imgUrl": imgURL,
      "video_call": null
    };

    DatabaseMethods().addConversationMessages(widget.chatRoomId, messageMap);
    messageController.text = "";
    lenghtChage();
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
        FirebaseStorage.instance.ref().child("chats/$fileName");

    final UploadTask uploadTask = storageRef.putFile(
      File(filePath),
    );
    await uploadTask.whenComplete(() {});
    print("yyyyyyyyyyyyy");
    imgURL = await storageRef.getDownloadURL();
    toastShoer("Image Uploaded");
    print(imgURL);

    await uploadTask.then(sendImage());
    // await sendImage();
    _extension = null;
    toastShoer("Image Sent");
    downloadFile(imgURL, imgURL);
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
        lenghtChage();
        print("value$value");
        print("chatmessagestream$chatmessageStream");
      });
    });
    _handleCameraAndMic(Permission.camera);
    _handleCameraAndMic(Permission.microphone);
    super.initState();
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {});

    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    var _id = await videoCall();
    print("object got the video call id her $_id");
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          chatRoomId: widget.chatRoomId,
          docId: _id,
          name: Constants.myName,
        ),
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  // var id;
  // deleteChat() {
  //   DatabaseMethods().UpdateVideoChat(widget.chatRoomId, id);
  // }

  videoCall() async {
    Map<String, dynamic> messageMap = {
      "message": null,
      "sendBy": Constants.myName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "imgUrl": null,
      "video_call": Constants.myName
    };

    var id = await DatabaseMethods()
        .addConversationMessages(widget.chatRoomId, messageMap);
    print("here id the id for the document  $id");
    return id;
  }

  Future<void> recieveonJoin() async {
    // update input validation
    setState(() {});

    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    // var _id = await videoCall();
    // print("object got the video call id her $_id");
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RecievingCallPage(
                channelName: Constants.caller,
                role: ClientRole.Broadcaster,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("video page${Constants.Video_Page}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(Constants.usernameFOrProfile == null
            ? ""
            : Constants.usernameFOrProfile),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.video_call,
              color: Colors.white,
            ),
            onPressed: () {
              onJoin();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.20,
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    color: Colors.white,
                    child: chatMessageList() == null
                        ? Container(
                            child:
                                Center(child: Text("No Messgaes Yest, null")),
                          )
                        : chatMessageList(),
                  ),
                  // Container(
                  //   alignment: Alignment.bottomCenter,
                  //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  //   child: Container(
                  //     color: Colors.white,
                  //     child: Row(
                  //       children: [
                  //         IconButton(
                  //             onPressed: () {
                  //               openImageFile();
                  //             },
                  //             icon: Icon(Icons.file_copy)),
                  //         GestureDetector(
                  //           onTap: () {
                  //             // nitiateSearch();
                  //             sendMessage();
                  //           },
                  //           child: Container(
                  //             child: Icon(
                  //               Icons.send_sharp,
                  //               size: 35,
                  //             ),
                  //           ),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Stack(children: [
              Container(
                child: Container(
                  // alignment: Alignment.bottomCenter,
                  // padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Container(
                    // color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            openImageFile();
                          },
                          icon: Icon(Icons.share),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: TextField(
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: "Message",
                                  border: InputBorder.none),
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
                height: MediaQuery.of(context).size.height / 20,
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width,
              ),
            ])
          ],
        ),
      ),
    );
  }
}

Color color;

class MessageTile extends StatelessWidget {
  final String channelName;
  final bool isvideo_call;
  final int time;
  final String message;
  final String localDirectory;
  final String imageUrl;
  final bool isSentByMe;
  final bool msgEmpty;
  final bool imgEmpty;
  MessageTile({
    this.channelName,
    this.isvideo_call,
    this.imgEmpty,
    this.message,
    this.time,
    this.msgEmpty,
    this.localDirectory,
    this.imageUrl,
    this.isSentByMe,
  });
  void showDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // isvideo_call ? Constants.Video_Page = true : Constants.Video_Page = false;
    // print(Constants.Video_Page);
    // print("$imageUrl");
    if (imgEmpty == false || msgEmpty == false) {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageViewer(
                                url: imageUrl,
                              )));
                },
                child: Container(
                    height: 400,
                    width: 400.0,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    padding: EdgeInsets.all(5),
                    child: Image.network('$imageUrl')
                    //     Image.file(
                    //       File('$localDirectory' + '/' + '$imageUrl'),
                    //     ) ==
                    //     null
                    // ?
                    // : Image.file(
                    //     File('$localDirectory' + '$imageUrl'),
                    //   ),
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
    } else {
      return isSentByMe
          ? Container(
              child: Text(""),
            )
          : GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecievingCallPage(
                              channelName: channelName,
                              role: ClientRole.Broadcaster,
                            )));
              },
              child: Container(
                color: Colors.green[200],
                padding:
                    EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 24),
                child: Text("Click to attend video call"),
              ),
            );
    }
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
