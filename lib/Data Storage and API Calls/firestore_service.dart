import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twitter_app/Models/chatMessage_model.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseService {
  final CollectionReference db = FirebaseFirestore.instance.collection('chat');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /*FirebaseMessaging.instance.getInitialMessage().then(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);*/
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }

  Future<void> saveChat(List<ChatMessage> chat) async {
    String safeKey = "chatroom1";
    try {
      await db.doc(safeKey).set({
        'messages': chat
            .map((message) => {
                  'username': message.username,
                  'message': message.message,
                  'time': message.dateTime,
                })
            .toList(),
      });
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  Future<List<ChatMessage>> getChat() async {
    String safeKey = "chatroom1";
    try {
      String? email = _auth.currentUser?.email;
      if (email != null) {
        DocumentSnapshot documentSnapshot =
            await db.doc(safeKey).get();

        if (documentSnapshot.exists) {
            List<dynamic> messages = documentSnapshot['messages'];
            List<ChatMessage> chat = messages.map((message) {
              return ChatMessage(
                username: message['username'],
                message: message['message'],
                dateTime: (message['time'] as Timestamp).toDate(),
              );
            }).toList();

            return chat;
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return [];
  }

  Future<String?> currentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }
}
