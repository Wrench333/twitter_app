import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:twitter_app/Data%20Storage%20and%20API%20Calls/firestore_service.dart';
import 'package:twitter_app/Data%20Storage%20and%20API%20Calls/google_sign_in.dart';
import 'package:twitter_app/UI/login.dart';
import 'package:twitter_app/UI/sign_up.dart';
import 'Data Storage and API Calls/chat_provider.dart';
import 'Data Storage and API Calls/firebase_options.dart';
import 'UI/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
    await FirebaseService().initNotifications();
  } catch (e) {
    print("Failed to initialize Firebase App: $e");
  }
  runApp(const MyApp());
}

final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: '/home',
    builder: (context, state) => const Home(),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GoogleSignInProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Bitter App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
