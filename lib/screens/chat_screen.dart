import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;
FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final auth = FirebaseAuth.instance;

  String messageText;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }

    /*void getMessages() async {
    final messages = await _fireStore.collection('messages').getDocuments();
    for (var messages in messages.documents) {
      print(messages.data);
    }*/
  }

  void messageStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                messageStream();
                //  auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('🔥Chat'),
        backgroundColor: Colors.red[800],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _fireStore.collection('messages').add(
                        {
                          'text': messageText,
                          'sender': loggedInUser.email,
                        },
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightGreen[300],
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<MessageBuble> messageBubles = [];
          for (var message in messages) {
            final messageText = message.data['text'];
            final messageSender = message.data['sender'];
            final currentUser = loggedInUser.email;
            if (currentUser == messageSender) {}

            final messageBuble = MessageBuble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );

            messageBubles.add(messageBuble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: messageBubles,
            ),
          );
        });
  }
}

class MessageBuble extends StatelessWidget {
  MessageBuble({this.sender, this.text, this.isMe});
  final String sender;
  final String text;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.yellow[200] : Colors.blue[100],
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text from $sender',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
