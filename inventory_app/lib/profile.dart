import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inventoryapp/currentUserProfileData.dart';
import 'package:inventoryapp/drawer.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount account;
  GoogleSignInAuthentication auth;
  bool gotProfile = false;
  final dbRefUser = FirebaseDatabase.instance.reference().child("User");

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    //double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    return gotProfile
        ? Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
      body: ListView(
        children: <Widget>[
          Container(
            color: Color(0xFF536DFE),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.00),
                  child: IconButton(
                    icon: Icon(Icons.dehaze),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: (){
                      _scaffoldKey.currentState.openDrawer();
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            height: heightScreen*0.33,
            decoration: BoxDecoration(
              color: Color(0xFF536DFE),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50.00), bottomLeft: Radius.circular(50.00)
              )
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30.00),
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                account.photoUrl
                            )
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.00),
                  child: Text(
                    "Hello ${account.displayName.split(" ")[0]}",
                    style: TextStyle(
                      fontSize: 28.00,
                      color: Colors.white
                    ),
                  ),
                )
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.00, left: 30.00),
            child: Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 24.00),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.00, left: 30.00),
            child: Text(
              "${account.displayName}",
              style: TextStyle(fontWeight: FontWeight.w300,
                  fontSize: 24.00),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.00, left: 30.00),
            child: Text(
              "Email ID",
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 24.00),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.00, left: 30.00),
            child: Text(
              "${account.email}",
              style: TextStyle(fontWeight: FontWeight.w300,
                  fontSize: 24.00),
            ),
          ),
        ],
      )
    )
        : LinearProgressIndicator();
  }

  void getProfile() async {
    await googleSignIn.signInSilently();
    account = googleSignIn.currentUser;
    auth = await account.authentication;
    currentUserData.UserName = account.displayName;
    currentUserData.EmailID = account.email;
    setState(() {
      gotProfile = true;
      dbRefUser.once().then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value}');
        print(snapshot.value.toString().contains(account.email));
        if(!snapshot.value.toString().contains(account.email)){
          dbRefUser.child("${account.displayName}").set(
              {
                'Email' : account.email,
                'Username' : account.displayName
              }
          );
        }
      });
    });
  }
}
