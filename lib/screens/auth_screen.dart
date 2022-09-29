import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    bool signup,
      BuildContext ctx,
  ) async {
    try {
      if (!signup) {
        final credential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,);
      } else {
        final credential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        
        FirebaseFirestore.instance.collection('user').doc(credential.user?.uid).set({
          'username': username,
          'email': email,
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
