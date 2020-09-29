import 'package:flutter/material.dart';
import 'package:inventoryapp/currentUserProfileData.dart';
import 'package:inventoryapp/drawer.dart';
import 'package:inventoryapp/new_request.dart';
import 'package:firebase_database/firebase_database.dart';
import "dart:collection";

class Requests extends StatefulWidget {

  Requests();
  @override
  RequestsState createState() => RequestsState();
}

class RequestsState extends State<Requests> {

  RequestsState();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
        ScaffoldState>();
    final dbRefUser = FirebaseDatabase.instance.reference().child("Requests").child(currentUserData.UserName);
    List<dynamic> lists = [];

    return Scaffold(
      key: _scaffoldKey,
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => NewRequests()
          ));
        },
        label: Text('Send New Request'),
        icon: Icon(Icons.add_circle_outline),
        backgroundColor: Color(0xFF536DFE),

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
                      "Requests",
                      style: TextStyle(
                          fontSize: 32.00,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
            child: FutureBuilder(
                future: dbRefUser.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    print(values);
                    if(values == null){
                      return Container(
                        height: heightScreen*0.5,
                        child: Text("No Requests Sent Yet", textScaleFactor: 1.3, textAlign: TextAlign.center,), //If there are no requests made yet
                      );
                    }
                    values.forEach((key, values) { //Converting into nested lists
                          lists.add([int.parse(key.toString().split(" ").last),values["Item"],values['Quantity'],values['Status'],values['Address']]);
                    });
                    print(lists);
                    var temp;
                    for(int i = 0; i< lists.length-1; i++){ // For sorting in descending order
                      if(lists[i][0] < lists[i+1][0]){
                        temp = lists[i];
                        lists[i] = lists[i+1];
                        lists[i+1] = temp;
                      }
                    }
                    print(lists);
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5.0,
                            color: Color(0xFF536DFE),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: ListTile(
                                      title: Text(lists[index][1], textScaleFactor: 1.1, style: TextStyle(color: Colors.white),), // Item name
                                      subtitle: Text(lists[index][2].toString(), style: TextStyle(color: Colors.white),), //Quantity
                                      trailing: Text(lists[index][3], style: TextStyle(color: Colors.white),), // Status
                                    )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 15.0, right: 10.0, bottom: 10.0),
                                  child: Text('Requested at ${lists[index][4]}',textScaleFactor: 1.1 ,style: TextStyle(color: Colors.white),),
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return Container( //For loading
                    height: heightScreen*0.2,
                    width: widthScreen*0.4,
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }}