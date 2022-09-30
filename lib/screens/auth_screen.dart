import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(
    String username,
    String email,
    String password,
    XFile avatar,
    bool signup,
    BuildContext ctx,
  ) async {
    try {
      if (signup) {
        final credential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('image_url')
            .child('${credential.user!.uid}.jpg');
        ref.putFile(File(avatar.path)).whenComplete(() async {
          final url = await ref.getDownloadURL();
          FirebaseFirestore.instance
              .collection('users')
              .doc(credential.user?.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': url,
          });
        });
      }
    } on FirebaseAuthException catch (error) {
      var mes = 'An error occurred, please check your credentials';

      if (error.message != null) {
        mes = error.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: Text(mes),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: AuthForm(_submitAuthForm));
  }
}
