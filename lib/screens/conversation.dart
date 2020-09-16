import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/authenticate/helperfunction.dart';
import 'package:messenger/modals/user.dart';
import 'package:messenger/services/database.dart';

class Conversation extends StatefulWidget {
  final String chatRoomId;
  Conversation({this.chatRoomId});
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  DataBaseMethods _dataBaseMethods = DataBaseMethods();
  TextEditingController messageTextEditingController = TextEditingController();
  Stream chatMessageStream;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    getMessageUser();
    super.initState();
    _dataBaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
  }

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _controller,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.documents[index].data['message'],
                      isSendByMe:
                          snapshot.data.documents[index].data['sendBy'] ==
                              Contrains.myName,
                    );
                  })
              : Container();
        });
  }

  getMessageUser() async {
    Constrains.messageUser =
        await HelperFunctions.getMessageUserSharedPreference();
    setState(() {});
  }

  sendMessage() {
    _scrollToBottom();
    if (messageTextEditingController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Contrains.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      _dataBaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextEditingController.text = '';
    }
  }

  void _scrollToBottom() async {
    if (_controller.hasClients) {
      await _controller.animateTo(_controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 5), curve: Curves.elasticOut);
    } else {
      Timer(Duration(milliseconds: 5), () => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            SizedBox(
              width: 60,
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(50)),
              child: Center(
                child: Text(
                  Constrains.messageUser.substring(0, 1).toUpperCase(),
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
            Text(Constrains.messageUser),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Scrollbar(child: chatMessageList())),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          onTap: () {
                            _scrollToBottom();
                          },
                          controller: messageTextEditingController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                          _scrollToBottom();
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                //color: Colors.blue,
                                borderRadius: BorderRadius.circular(30)),
                            child: Image.asset('assets/sendmessageicon.png')),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatefulWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({this.message, this.isSendByMe});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    ScrollController _controller = ScrollController();
    return SingleChildScrollView(
      controller: _controller,
      child: Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        margin: EdgeInsets.symmetric(vertical: 8),
        width: MediaQuery.of(context).size.width,
        alignment:
            widget.isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
                color: widget.isSendByMe ? Colors.blue : Colors.white,
                borderRadius: widget.isSendByMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(23),
                        bottomLeft: Radius.circular(23),
                        topRight: Radius.circular(23))
                    : BorderRadius.only(
                        topRight: Radius.circular(23),
                        topLeft: Radius.circular(23),
                        bottomRight: Radius.circular(23))),
            child: Text(
              widget.message,
              style: TextStyle(
                  color: widget.isSendByMe ? Colors.white : Colors.black),
            )),
      ),
    );
  }
}
