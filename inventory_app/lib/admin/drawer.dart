import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventoryapp/admin/profile_admin.dart';
import 'package:inventoryapp/admin/inventory.dart';
import 'package:inventoryapp/admin/requests.dart';
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
                DrawerHeader(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      'Admin',
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height)*0.15 , left: 20.00),
                  child: ListTile(
                    title: Text(
                      'My Profile',
                      textScaleFactor: 1.5,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProfileScreenAdmin()
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Requests()
                      ));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.00),
                  child: ListTile(
                    title: Text(
                      'Inventory',
                      textScaleFactor: 1.5,
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => InventoryScreen()
                      ));
                    },
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