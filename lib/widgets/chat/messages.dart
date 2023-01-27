import 'message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'timeCreated',
            descending: true,
          )
          .snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<dynamic> chatSnapshot) {
        //checking for error
        if (chatSnapshot.hasError) {
          return const Text('Something went wrong');
        }
        //checking if data is loading then showing progress indicator
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        //assigning data received from stream snapshot
        final chatDocs = chatSnapshot.data.docs;

        //Showing data in a ListView on the screen
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index].data()['text'],
            chatDocs[index].data()['username'],
            chatDocs[index].data()['image_url'],
            chatDocs[index].data()['userId'] == user?.uid,
            key: ValueKey(chatDocs[index].id),
          ),
        );
      },
    );
  }
}
