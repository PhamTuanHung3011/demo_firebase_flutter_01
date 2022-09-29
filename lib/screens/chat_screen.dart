import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo chat'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.exit_to_app_outlined),
                    Text('Logout'),
                  ],
                ),
              )
            ],
            onChanged: (Object? value) {
              if(value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/TFDyVjrApWOaZi7qbpz5/messages')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final doc = snapshot.data.docs;
            return ListView.builder(
              itemCount: doc.length,
              itemBuilder: (ctx, index) => Container(
                child: Text(doc[index]['text']),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/TFDyVjrApWOaZi7qbpz5/messages')
              .add({
            'text': 'more add',
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
