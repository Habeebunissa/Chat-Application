import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/fcm/fcm_getcontroller.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'userImage': '', //userData['image_url']
    });

    String other_user_fcm_token = userData['fcm_token'];
    FCMController fcmController = FCMController();

    fcmController.sendNotification(other_user_fcm_token, "New messagae", "You have received a new message. tap to check");


    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(labelText: 'Send a Message..'),
                  onChanged: (value) {
                    setState(() {
                      _enteredMessage = value;
                    });
                  }),
            ),
            IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_enteredMessage.trim().isNotEmpty) {
                    _sendMessage();
                  }
                }),
          ],
        ));
  }
}
