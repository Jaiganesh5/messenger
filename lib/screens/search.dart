import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/authenticate/helperfunction.dart';
import 'package:messenger/modals/user.dart';
import 'package:messenger/screens/conversation.dart';
import 'package:messenger/services/database.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  TextEditingController searchTextEditingController = TextEditingController();
  QuerySnapshot searchSnapshots;

  initiateSearch() {
    HelperFunctions.saveMessageUserSharedPreference(
        searchTextEditingController.text);
    _dataBaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      // print(val.toString());
      setState(() {
        searchSnapshots = val;
      });
    });
  }

  //create chat room ,send usser to covo screen

  Widget searchList() {
    return searchSnapshots != null
        ? ListView.builder(
            itemCount: searchSnapshots.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshots.documents[index].data["name"],
                userEmail: searchSnapshots.documents[index].data["email"],
              );
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Search',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration: InputDecoration(
                          hintText: 'search',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        initiateSearch();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              //color: Colors.blue,
                              borderRadius: BorderRadius.circular(30)),
                          child: Image.asset('assets/search.png')),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              searchList(),
            ],
          ),
        ));
  }
}

createChatRoomAndStartConversation(BuildContext context, String userName) {
  if (userName != Contrains.myName) {
    String chatRoomId = getChatroomId(userName, Contrains.myName);
    List<String> users = [userName, Contrains.myName];
    Map<String, dynamic> chatRoomMap = {
      'users': users,
      'chatroomId': chatRoomId,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    DataBaseMethods().createChatRoom(chatRoomId, chatRoomMap);
    print(Contrains.myName);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Conversation(
                  chatRoomId: chatRoomId,
                )));
  } else {
    print('you cannot send messages');
  }
}

class SearchTile extends StatefulWidget {
  final String userName;
  final String userEmail;

  SearchTile({this.userName, this.userEmail});
  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  QuerySnapshot snapshot;
  // DataBaseMethods _dataBaseMethods = DataBaseMethods();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.userName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                widget.userEmail,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(context, widget.userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Message',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

getChatroomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
