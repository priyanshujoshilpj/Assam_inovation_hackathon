import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/drawer.dart';


class InventoryScreen extends StatefulWidget {

  InventoryScreen();
  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {

  InventoryScreenState();
  final dbRefUser = FirebaseDatabase.instance.reference().child("Inventory").child("User");
  List<dynamic> lists = [];
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery  //To find height of screen
        .of(context)
        .size
        .height;
    double widthScreen = MediaQuery  //To find width of screen
        .of(context)
        .size
        .width;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<  //Mainly for snackbar
        ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey, //Scaffold Key
      drawer: MyDrawer(), // Drawer
      body: ListView(
        children: <Widget>[
          Container(
            color: Color(0xFF536DFE),
            child: Row(
              children: <Widget>[
                Padding(  //This is for the drawer
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
          Container(  //This is for the rounded background
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
                  Padding(  //The word Inventory on the rounded background
                    padding: EdgeInsets.only(top: 30.00),
                    child: Text(
                      "Inventory",
                      style: TextStyle(
                          fontSize: 32.00,
                          color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                Padding(  // For the search bar where items can be searched
                  padding: EdgeInsets.only(left: 30.0),
                  child: SizedBox(
                    child: TextFormField(
                      controller: search,
                      textAlign: TextAlign.center,
                    ),
                    width: widthScreen*(0.5),
                  ),
                ),
                Container(
                  width: 30.0,
                ),
                RaisedButton( // Search Button
                  color: Color(0xFF536DFE),
                  child: Text('Search', style: TextStyle(color: Colors.white),),
                  onPressed: (){  //Checks the list for what you searched
                    for(int i = 0; i<lists.length; i++){
                      if(lists[i][0].toString().toLowerCase().contains(search.text.toLowerCase())){  // So that 'blan' gives 'Blanket' (pattern)
                        searchDialog(context, i);  //Open Dialog Box with item name and no of items
                      }
                    }
                  },
                )
              ],
            )
          ),
          Padding(  //This is for the list of all items and their quantities
            padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: FutureBuilder(
                future: dbRefUser.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();
                    Map<dynamic, dynamic> values = snapshot.data.value;  //Map of the data received
                    print(values);
                    values.forEach((key, values) {
                      lists.add([key,values]); // Taking important stuff and converting to list (May change it to use Map by default to save time)
                    });
                    print(lists);
                    return new ListView.builder(
                        shrinkWrap: true,
                        itemCount: lists.length,
                        physics: ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Color(0xFF536DFE),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: ListTile(
                                    title: Text(lists[index][0], textScaleFactor: 1.1,style: TextStyle(color: Colors.white),),  //Item Name
                                    subtitle: Text(lists[index][1].toString(), style: TextStyle(color: Colors.white),),  //Quantity
                                  )
                                ),
                              ],
                            ),
                          );
                        });
                  }
                  return Container(  //If data still fetching, show circle progress bar
                    height: heightScreen*0.2,
                    width: widthScreen*0.4,
                    child: CircularProgressIndicator(),
                  );
                }),
          )
        ],
      )
      );
  }


  searchDialog(BuildContext context, int position) {  //This is for the dialog to show searched item (One at a time though)
    Widget cancelButton = FlatButton(
      child: Text(
        "Dismiss",
        style: TextStyle(color: Color(0xFF536DFE)),
      ),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "${lists[position][0]}",
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.00)
      ),
      content: Text(
        "${lists[position][1].toString()}",
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}