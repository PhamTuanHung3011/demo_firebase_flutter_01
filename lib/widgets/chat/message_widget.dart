import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_firebase_flutter/widgets/chat/messages_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder<User>(
      future: Future.value(currentUser),
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final snapshotData = snapshot.data!.docs;
            return ListView.builder(
              reverse: true,
              itemCount: snapshotData.length,
              itemBuilder: (context, index) => MessageBubble(
                snapshotData[index]['text'],
                snapshotData[index]['userId'] == futureSnapshot.data!.uid ? true : false,
                snapshotData[index]['username'],
                key: ValueKey(snapshotData[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
