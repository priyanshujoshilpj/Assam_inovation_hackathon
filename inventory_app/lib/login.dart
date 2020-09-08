import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventoryapp/splash.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email','profile']);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Inventory\nManagement\nSystem",
            style: TextStyle(fontSize: 36,
            ),
          ),
          RaisedButton(
            onPressed: () {
              startSignIn();
            },
            child: Text('Tap to sign in with Google'),
          ),
        ],
      ),
    );
  }

  void startSignIn() async {
    await googleSignIn.signOut(); //optional
    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      print('Sign In Failed ');
    } else {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SplashScreen()
      ));
    }
  }
}