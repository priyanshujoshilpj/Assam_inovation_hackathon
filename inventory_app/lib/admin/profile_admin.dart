import 'package:flutter/material.dart';
import 'package:inventoryapp/currentUserProfileData.dart';
import 'package:inventoryapp/admin/drawer.dart';

import 'ScanPage.dart';

class ProfileScreenAdmin extends StatefulWidget {

  ProfileScreenAdmin();
  @override
  _ProfileScreenAdminState createState() => _ProfileScreenAdminState();
}

class _ProfileScreenAdminState extends State<ProfileScreenAdmin> {

  _ProfileScreenAdminState();

  @override
  Widget build(BuildContext context) {
    //double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
        ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.phone_android),
          backgroundColor: Color(0xFF536DFE),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ScanPage()
            ));
          },
        ),
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
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: heightScreen * 0.1,
                decoration: BoxDecoration(
                    color: Color(0xFF536DFE),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50.00),
                        bottomLeft: Radius.circular(50.00)
                    )
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 30.00),
                      child: Text(
                        "Hello ${currentUserData.UserName.split(" ")[0]}",
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
                "${currentUserData.UserName}",
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
                "${currentUserData.EmailID}",
                style: TextStyle(fontWeight: FontWeight.w300,
                    fontSize: 24.00),
              ),
            ),
          ],
        )
    );
  }
}
