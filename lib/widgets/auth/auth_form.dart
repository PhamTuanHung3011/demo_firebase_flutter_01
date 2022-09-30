import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  void Function(String username, String email, String password, XFile avatar,
      bool signup, BuildContext ctx) submitFn;

  AuthForm(this.submitFn);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _signup = true;
  XFile? take_image;

  void _takeImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(()  {
      if (image != null) {
        take_image = image;
      }

    });
  }
  Future<User> showImage() async{
      User? user = FirebaseAuth.instance.currentUser;
      final userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
      return userData['image_url'];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (!_signup)
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: take_image != null
                          ? FileImage(File(take_image!.path))
                          : null,
                    ),
                  if (!_signup)
                    TextButton(
                      onPressed: _takeImage,
                      child: Text('Pick image'),
                    ),
                  if (!_signup)
                    TextFormField(
                      key: ValueKey('username'),
                      onSaved: (value) {
                        _username = value ?? '';
                      },
                      validator: (value) {
                        if (value == null || value.length <= 6) {
                          return 'username must than 6 character!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                        labelText: 'username',
                      ),
                    ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    onSaved: (value) {
                      _email = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'email must add @';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      labelText: 'email',
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    obscureText: true,
                    autocorrect: false,
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.length <= 5) {
                        return 'password must than 6 character';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      labelText: 'password',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        if(take_image != null) {
                          widget.submitFn(_username.trim(), _email.trim(),
                              _password.trim(), take_image!, _signup, context);}
                         else {
                           take_image = showImage() as XFile?;
                          widget.submitFn(_username.trim(), _email.trim(),
                              _password.trim(), take_image!, _signup, context);
                        }
                      }
                    },
                    child: Text(_signup ? 'Log in' : 'Sign Up!'),
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _signup = !_signup;
                        });
                      },
                      child: Text(_signup
                          ? 'Create new account!'
                          : 'I already have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
