import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/screens/chat_screen.dart';
import 'package:flutter_complete_guide/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    XFile? image,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        print("Login Going on");
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print("Loggin in Done");
      } else {
        await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');

        if (image != null) {
          await ref.putFile(File(image!.path)).then((p0) {
            p0.ref.getDownloadURL().then((downloadUrl) async {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .set({
                'username': username,
                'email': email,
                'image_url': downloadUrl,
              });
            });
          });
        }
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ChatScreen()));
      //Navigation code goes here
    } on PlatformException catch (err) {
      var message = 'An error occured, Please check your credentials!';

      if (err.message != null) {
        message = err.message.toString();
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
