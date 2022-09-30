import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  void Function(String username, String email, String password, bool signup, BuildContext ctx) submitFn;

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
                  if( !_signup)
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          widget.submitFn(_username.trim(), _email.trim(), _password.trim(), _signup, context);
                        }
                      },
                      child: Text(_signup ? 'Log in' : 'Sign Up!'),),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _signup = !_signup;
                        });
                      },
                      child: Text(_signup ? 'Create new account!' : 'I already have an account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
