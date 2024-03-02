import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:twitter_app/Data%20Storage%20and%20API%20Calls/chat_provider.dart';
import 'package:twitter_app/Models/chatMessage_model.dart';

import '../Data Storage and API Calls/google_sign_in.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ChatProvider>(context, listen: false);
      provider.getChat();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    final user = FirebaseAuth.instance.currentUser;
    final provider = Provider.of<ChatProvider>(context);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.cyan[50],
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.cyan[50],
                ),
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:Icon(Icons.logout,
                      size: 30,),
                      onPressed: () {
                        final provider1 = Provider.of<GoogleSignInProvider>(context,listen: false);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(child: Text("Logout")),
                              content: Text(
                                  "Are you sure you want to logout from this account?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  child: Text("Logout"),
                                  onPressed: () {
                                    context.pop();
                                    provider1.logout();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    const Text(
                      "Bitter App",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Current User Details"),
                              content: Text(
                                  "Name: ${user.displayName}\nEmail: ${user.email}\nPh No:${user.phoneNumber ?? 1234567890}"),
                              actions: [
                                TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    context.pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(user!.photoURL!),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  reverse: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: provider.chat.length,
                    itemBuilder: (context, index) {
                      ChatMessage chatMessage = provider.chat[index];
                      return Column(
                        children: [
                          (user.displayName! == chatMessage.username)
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                        '${chatMessage.dateTime.hour}:${chatMessage.dateTime.minute}'),
                                    Flexible(
                                      child: Container(
                                        constraints: BoxConstraints(
                                            minWidth: size.width / 3,
                                            maxWidth: size.width - 20,
                                            minHeight: 0,
                                            maxHeight: double.infinity),
                                        margin: EdgeInsets.fromLTRB(8, 6, 8, 6),
                                        padding:
                                            EdgeInsets.fromLTRB(18, 18, 18, 18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(17.36),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2,
                                              color: Colors.grey,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          chatMessage.message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 14.0,
                                      backgroundImage:
                                          NetworkImage(chatMessage.profile),
                                    ),
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 14.0,
                                      backgroundImage:
                                          NetworkImage(chatMessage.profile),
                                    ),
                                    Flexible(
                                      child: Container(
                                        constraints: BoxConstraints(
                                            minWidth: size.width / 3,
                                            maxWidth: size.width - 20,
                                            minHeight: 0,
                                            maxHeight: double.infinity),
                                        margin: EdgeInsets.fromLTRB(8, 6, 8, 6),
                                        padding:
                                            EdgeInsets.fromLTRB(18, 18, 18, 18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(17.36),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2,
                                              color: Colors.grey,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          chatMessage.message,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    Text(
                                        '${chatMessage.dateTime.hour}:${chatMessage.dateTime.minute}'),
                                  ],
                                ),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              /*Container(
                              child: Text('${user.displayName} has entered the chat!'),
                            ),*/
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: 'Enter your Message',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                  //SizedBox(width: 4.0,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        fixedSize: Size(10, 50),
                        backgroundColor: Colors.blue[50]),
                    onPressed: () {
                      provider.addMessage(user.displayName!, controller.text,user.email!,user.photoURL!);
                      controller.text = '';
                      provider.chatStore(user.displayName!);
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                    child: Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
