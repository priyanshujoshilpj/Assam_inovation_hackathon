import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
          Container(
            color: Color(0xFF536DFE),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.00),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
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
                      "Scan",
                      style: TextStyle(
                          fontSize: 32.00,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              )
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: heightScreen*0.2,
                ),
                Text(
                  qrCodeResult,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                 height: 50.0,
                ),
                SizedBox(
                  height: 40.0,
                  width: 10.0,
                  child: RaisedButton(
                    child: Text("Launch Link", style: TextStyle(color: Colors.white),),
                    color: Color(0xFF536DFE),
                    onPressed: () async{
                      if (await canLaunch(qrCodeResult)) {
                        await launch(qrCodeResult);
                      } else {
                        showSnackBar('Failed to launch embedded URL');
                      }
                    },
                  ),
                ),

                SizedBox(
                  height: 100.0,
                ),
                FlatButton(
                  padding: EdgeInsets.all(15.0),
                  onPressed: () async {
                    String codeScanner = await BarcodeScanner.scan();
                    setState(() {
                      qrCodeResult = codeScanner;
                    });
                  },
                  child: Text(
                    "Open Scanner",
                    style:
                    TextStyle(color: Color(0xFF536DFE), fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF536DFE), width: 3.0),
                      borderRadius: BorderRadius.circular(20.0)),
                )
              ],
            ),
          ),
        ],
      )
    );
  }
  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
