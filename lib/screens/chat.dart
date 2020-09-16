import 'package:flutter/material.dart';
import 'package:messenger/authenticate/authenticate.dart';
import 'package:messenger/authenticate/helperfunction.dart';
import 'package:messenger/modals/user.dart';
import 'package:messenger/screens/conversation.dart';
import 'package:messenger/screens/search.dart';
import 'package:messenger/services/database.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  Stream chatRoomsStream;
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  getUserName() async {
    Contrains.myName = await HelperFunctions.getUserNameSharedPreference();
    setState(() {});
    print(Contrains.myName);
    _dataBaseMethods.getChatRooms(Contrains.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshots) {
        return snapshots.hasData
            ? ListView.builder(
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    username: snapshots.data.documents[index].data['chatroomId']
                        .toString()
                        .replaceAll('_', '')
                        .replaceAll(Contrains.myName, '')
                        .replaceAll("..", ''),
                    chatroomId:
                        snapshots.data.documents[index].data['chatroomId'],
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messenger',
          style: TextStyle(
            //fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app),
              )),
        ],
        elevation: 0.0,
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Search(),
              ));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatroomId;
  ChatRoomTile({this.username, this.chatroomId});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              HelperFunctions.saveMessageUserSharedPreference(username);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Conversation(
                      chatRoomId: chatroomId,
                    ),
                  ));
            },
            child: Container(
              color: Colors.black26,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        username.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            indent: 60,
            endIndent: 20,
          )
        ],
      ),
    );
  }
}
