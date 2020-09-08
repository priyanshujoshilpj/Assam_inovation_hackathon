import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventoryapp/profile.dart';
import 'package:inventoryapp/splash.dart';

class MyDrawer extends StatelessWidget{
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount account;
  GoogleSignInAuthentication auth;
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height)*0.3 , left: 20.00),
                  child: ListTile(
                    title: Text(
                      'My Profile',
                      textScaleFactor: 1.5,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProfileScreen()
                      ));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.00),
                  child: ListTile(
                    title: Text(
                      'Requests',
                      textScaleFactor: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.00),
                  child: ListTile(
                    title: Text(
                      'Inventory',
                      textScaleFactor: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.00),
                  child: ListTile(
                    title: Text(
                      'Contact Support',
                      textScaleFactor: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height)*0.2 , left: 20.00),
                  child: ListTile(
                    title: Text(
                      'Log Out',
                      textScaleFactor: 1.5,
                    ),
                    onTap: () async{
                      await googleSignIn.signOut();
                      //await googleSignIn.disconnect();
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SplashScreen()
                      ));
                    },
                  ),
                )
              ],
            )
    );
  }
}