import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  final String uid;
  DataBaseMethods({this.uid});
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  getUserByUsername(String username) async {
    return await userCollection
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByEmail(String email) async {
    return userCollection.where("email", isEqualTo: email).getDocuments();
  }

  uploadUserInfo(userMap) async {
    return await userCollection.document(uid).setData(userMap);
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .setData(chatRoomMap)
        .catchError((e) => print(e.toString()));
  }

  addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .collection('chats')
        .document()
        .setData(messageMap)
        .catchError((e) => print(e.toString()));
  }

  getConversationMessages(String chatRoomId) async {
    return Firestore.instance
        .collection('chatroom')
        .document(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  getChatRooms(String username) async {
    return Firestore.instance
        .collection('chatroom')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
