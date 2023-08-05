import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter_complete_guide/widgets/chats/messages.dart';
import 'package:flutter_complete_guide/widgets/chats/new_message.dart'; //

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//can you paste here
  //can you
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'fcm_token': value});
    });
    super.initState();
    requestPermissions();
    subscribeToMessages();
  }

  void requestPermissions() async {
    await _firebaseMessaging.requestPermission();
    // Handle the permission response if needed
  }

  void subscribeToMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }

  Future<void> _onBackgroundMessage(RemoteMessage message) async {
    print("onBackgroundMessage: $message");
    // Handle the background message here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(children: <Widget>[
          Expanded(
            child: Messages(),
          ),
          NewMessage()
        ]),
      ),
    );
  }
}
