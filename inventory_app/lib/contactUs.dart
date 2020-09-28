import 'package:inventoryapp/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class SendEmail extends StatelessWidget {
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  _sendEmail() async {
    final String _email = 'mailto:' +
        "thebugslayers007@gmail.com" +
        '?subject=' +
        _subjectController.text +
        '&body=' +
        _bodyController.text;
    try {
      await launch(_email);
    } catch (e) {
      throw 'Could not Call Phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
        ScaffoldState>();
    return Scaffold(
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
                      "Inventory",
                      style: TextStyle(
                          fontSize: 28.00,
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Center(
              child: Text('Contact us via email', textScaleFactor: 1.3,),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _subjectController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Subject',
                  ),
                ),
                TextField(
                  controller: _bodyController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Message',
                  ),
                ),
                Container(
                  height: heightScreen*0.05,
                ),
                RaisedButton(
                  child: Text('Send Email', style: TextStyle(
                    color: Colors.white
                  ),),
                  color: Color(0xFF536DFE),
                  onPressed: _sendEmail,
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}
