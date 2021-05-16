import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/Conversation.dart';
import 'package:chat_app/views/login_page.dart';
import 'package:chat_app/views/profile.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/singup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  QuerySnapshot snapshotUserInfo;

  @override
  void initState() {
    getUserInfogetChats();
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
                })
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
        centerTitle: false,
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
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

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String imgUrl;
  final String chatRoomId;

  ChatRoomsTile({this.userName, this.imgUrl, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: GestureDetector(
            onTap: () {
              Constants.usernameFOrProfile = userName;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConversationScreen(
                    chatRoomId,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.green,
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
    );
  }
}
