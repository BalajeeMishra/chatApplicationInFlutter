import 'dart:html';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messeges extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy("createdAt")
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = streamSnapshot.data.documents;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubble(
              chatDocs[index]["text"],
              chatDocs[index]['userId'] == user.uid,
              key: ValueKey(chatDocs[index].documentId),
            ),
          );
        });
  }
}
