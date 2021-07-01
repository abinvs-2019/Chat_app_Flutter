import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserbyUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserbyEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future addConversationMessages(String chatRoomId, messageMap) async {
    var id;
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .then((value) => {id = value.id});
    if (id != null) {
      return id;
    } else {
      print("no id got");
    }
  }

  Future<void> UpdateVideoChat(String chatRoomid, id) async {
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomid)
        .collection("chats")
        .doc(id)
        .delete();
    // FirebaseFirestore.instance
    //     .collection('chatRoom')
    //     .doc(chatRoomid)
    //     .collection("chats")
    //     .where("video_call")
    //     .get()
    //     .then((value) => value.docs.forEach((element) {
    //           FirebaseFirestore.instance
    //               .collection("chatRoom")
    //               .doc(chatRoomid)
    //               .delete()
    //               .then((value) => print("success"));
    //         }));
  }

  getConversationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getVideoCallMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .where("video_call")
        .snapshots();
  }

  getChatRoom(String userName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  groupChatCreate() async {
    return await FirebaseFirestore.instance.collection("");
  }
}
