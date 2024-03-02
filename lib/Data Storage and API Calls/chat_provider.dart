import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_app/Data%20Storage%20and%20API%20Calls/google_sign_in.dart';
import 'package:twitter_app/Models/chatMessage_model.dart';

import 'firestore_service.dart';

class ChatProvider extends ChangeNotifier{
  List<ChatMessage> _chat = [];
  List<ChatMessage> get chat => _chat;

  void chatStore(String username) async {
    final FirebaseService firebaseService = FirebaseService();
    await firebaseService.saveChat(_chat);
  }

  void getChat() async {
    final FirebaseService firebaseService = FirebaseService();
    _chat = await firebaseService.getChat();
    notifyListeners();
  }

  void addMessage(String user, String message,String gmail, String profile) {
    ChatMessage chatMessage = ChatMessage(username: user, message: message, dateTime: DateTime.now(),gmail: gmail,profile: profile) ;
    _chat.add(chatMessage);
    notifyListeners();
  }
}