import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:twitter_app/Data%20Storage%20and%20API%20Calls/google_sign_in.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[50],
        title: const Text('Login Page'),
      ),
      body: Container(
        color: Colors.cyan[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity,50)
                ),
                icon: const FaIcon(FontAwesomeIcons.google),
                label: Text(
                  'Login',
                  style: TextStyle(color: Colors.cyan[400], fontSize: 16.0),
                ),
                onPressed:() {
                  final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                  provider.googleLogin();
                  context.go('/home');
                },
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/sign_up');
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.cyan[400], fontSize: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
