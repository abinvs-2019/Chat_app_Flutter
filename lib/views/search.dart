import 'package:chat_app/helper/contants.dart';
import 'package:chat_app/helper/helperFunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/Conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myname = "";

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchText = TextEditingController();
  QuerySnapshot searchSnapshot;

  nitiateSearch() {
    DatabaseMethods().getUserbyUsername(searchText.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  void initState() {
    getUserINfo();
    super.initState();
  }

  getUserINfo() async {
    Constants.myName = await HelperFunction.getuserNameInSharedPreferrence();
    setState(() {});
  }

  // String groupName;
  // List<String> memberOfGroup;
  // String emailCeated = "@gmail.com";

  // createGroupCHat(String groupName, memberOfGroup) {
  //   String grpupname = getGroupId(groupName, emailCeated);

  //   Auth().signUpWithEmailAndPaaword(grpupname, "adminPass");
  //   String chatRoomId = getChatRoomId(groupName, memberOfGroup.toString());

  //   Map<String, dynamic> chatRoomMap = {
  //     "users": memberOfGroup,
  //     "chatroomId": chatRoomId
  //   };
  //   DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
  // }

  createChatRoomConversation({
    String userName,
  }) async {
    userName = Constants.usernameFOrProfile = userName;
    if (userName != Constants.myName) {
      Constants.myName = await HelperFunction.getuserNameInSharedPreferrence();
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {}
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearcTile(
                userEmail: searchSnapshot.docs[index].get("email"),
                username: searchSnapshot.docs[index].get("name"),
              );
            })
        : Container(
            child: Center(
            child: Text("No Such Users"),
          ));
  }

  Widget SearcTile({String username, String userEmail}) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          createChatRoomConversation(
            userName: username,
          );
          print("username$username");
          _myname = username;
          print(Constants.myName);
        },
        child: Container(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userEmail,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    username,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  createChatRoomConversation(
                    userName: username,
                  );
                  print("username$username");
                  _myname = username;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Message"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: ((value) {
                      nitiateSearch();
                    }),
                    controller: searchText,
                    decoration: InputDecoration(
                        hintText: "search", border: InputBorder.none),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      nitiateSearch();
                    },
                    child: Container(child: Icon(Icons.search)))
              ],
            ),
          ),
          searchList(),
        ],
      )),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

getGroupId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
