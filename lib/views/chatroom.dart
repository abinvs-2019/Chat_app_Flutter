import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/video_call/src/video_reseaving_page.dart';
import 'package:chat_app/views/Conversation.dart';
import 'package:chat_app/views/profile.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/singup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  QuerySnapshot snapshotUserInfo;
  QuerySnapshot snap;
  String profleImageUrl;
  String nme;
  @override
  void initState() {
    getUserInfogetChats();
    getProfile();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunction.getuserNameInSharedPreferrence();

    DatabaseMethods().getChatRoom(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  Stream prfile;
  getProfile() async {
    DatabaseMethods().getChatRoom(Constants.myName).then((snapshot) {
      setState(() {
        toastShoer("Starting ProfileImages");
        nme = snap.docs[0]
            .get('chatroomId')
            .toString()
            .replaceAll("_", "")
            .replaceAll(Constants.myName, "");
        getuserProfileName(nme);
      });
    });
  }

  getuserProfileName(String nme) {
    DatabaseMethods().getUserbyUsername(nme).then((val) {
      snapshotUserInfo = val;
      toastShoer("Getting Profile Images");
      setState(() {
        profleImageUrl = snapshotUserInfo.docs[0].get("profileImage");

        // ChatRoomsTile(imgUrl: profileImageUrl);

        toastShoer("got images");
      });
    });
  }

  toastShoer(String msessageOfToast) {
    Fluttertoast.showToast(
        msg: msessageOfToast,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.docs[index]
                        .data()['chatroomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatroomId"],
                  );
                },
              )
            : Container();
      },
    );
  }

  getUerInfo() async {
    Constants.myName = await HelperFunction.getuserNameInSharedPreferrence();
    DatabaseMethods().getChatRoom(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  naigateVideoPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecievingCallPage(
                  channelName: Constants.caller,
                  role: ClientRole.Broadcaster,
                )));
  }

  Stream videoCallFinder;

  functio() {
    DatabaseMethods().getConversationMessages("").then((value) {
      setState(() {
        videoCallFinder = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Constants.Video_Page ? naigateVideoPage() : null;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
        centerTitle: false,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.person)))
        ],
      ),
      body: Container(
        child: chatRoomsList() == null ? Container() : chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatefulWidget {
  final String userName;
  final String imgUrl;
  final String chatRoomId;

  ChatRoomsTile({this.userName, this.imgUrl, this.chatRoomId});

  @override
  _ChatRoomsTileState createState() => _ChatRoomsTileState();
}

class _ChatRoomsTileState extends State<ChatRoomsTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  Constants.usernameFOrProfile = widget.userName;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationScreen(
                        widget.chatRoomId,
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${widget.imgUrl}'),
                        radius: 22.5,
                        child: Image.network('${widget.imgUrl}') ??
                            Image.network(''),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        widget.userName,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        ) ??
        Container();
  }
}
