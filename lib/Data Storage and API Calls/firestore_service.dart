import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:twitter_app/Models/chatMessage_model.dart';
import 'package:twitter_app/main.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseService {
  final CollectionReference db = FirebaseFirestore.instance.collection('chat');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorkey.currentState?.context.go('/chatroom');
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(settings,
        onDidReceiveNotificationResponse : (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload as String));
      handleMessage(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> saveChat(List<ChatMessage> chat) async {
    String safeKey = "chatroom1";
    try {
      await db.doc(safeKey).set({
        'messages': chat
            .map((message) => {
                  'username': message.username,
                  'gmail': message.gmail,
                  'message': message.message,
                  'time': message.dateTime,
                  'profile': message.profile,
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
        DocumentSnapshot documentSnapshot = await db.doc(safeKey).get();

        if (documentSnapshot.exists) {
          List<dynamic> messages = documentSnapshot['messages'];
          List<ChatMessage> chat = messages.map((message) {
            return ChatMessage(
                username: message['username'],
                gmail: message['gmail'],
                message: message['message'],
                dateTime: (message['time'] as Timestamp).toDate(),
                profile: message['profile']);
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
