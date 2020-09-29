import 'package:flutter/material.dart';
import 'package:inventoryapp/admin/drawer.dart';
import 'package:firebase_database/firebase_database.dart';

class Requests extends StatefulWidget {

  Requests();
  @override
  RequestsState createState() => RequestsState();
}

class RequestsState extends State<Requests> {

  RequestsState();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    final dbRefReq = FirebaseDatabase.instance.reference().child("Requests");
    final dbRefInventory = FirebaseDatabase.instance.reference().child("Inventory");
    List<dynamic> lists = [];

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
            padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: FutureBuilder(
                future: dbRefReq.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    lists.clear();
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    print(values);
                    print(values.keys);

                    if(values == null){
                      return Container(
                        height: heightScreen*0.5,
                        child: Text("No Requests Sent Yet", textScaleFactor: 1.3, textAlign: TextAlign.center,),
                      );
                    }
                    values.forEach((key, values) {
                      print(values);
                      for(int i = 0; i<values.length; i++){
                        if(values['Request ${i+1}']['Status'] == 'Pending'){
                          lists.add([key, values['Request ${i+1}']['Item'], values['Request ${i+1}']['Quantity'],i+1, values['Request ${i+1}']['Address']]);
                        }
                      }
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
                                      title: Text(lists[index][1] + " - " + lists[index][2].toString(), style: TextStyle(color: Colors.white),),
                                      subtitle: Text('Requested by ${lists[index][0]}', style: TextStyle(color: Colors.white),),
                                      trailing: GestureDetector(
                                        child: Icon(Icons.check, color: Colors.greenAccent,),
                                        onTap: (){
                                          setState(() {
                                                dbRefInventory.once().then((DataSnapshot snapshot){
                                                  Map<dynamic, dynamic> items = snapshot.value;
                                                  int x1 = int.parse(items['User'][lists[index][1]].toString());
                                                  int x2 = int.parse(lists[index][2].toString());
                                                    if (x1 > x2) {
                                                      dbRefInventory.child( //Updates quantity in inventory
                                                          'User').update({
                                                        lists[index][1]: x1 - x2
                                                      });
                                                      dbRefReq.child( //Changes request status
                                                          lists[index][0])
                                                          .child(
                                                          'Request ${lists[index][3]}')
                                                          .update({
                                                        'Status': 'Accepted'
                                                      });
                                                      showSnackBar(
                                                          'Request has been successfully accepted');
                                                    }
                                                    else{
                                                      showSnackBar('Unable to approve request as insufficient item quantity'); //As quantity requested by user is more than available quantity
                                                    }
                                                });
                                          });
                                        },
                                      ),
                                      leading: GestureDetector(  //For rejecting requests
                                        child: Icon(Icons.close, color: Colors.redAccent,),
                                        onTap: (){
                                          setState(() {
                                            dbRefReq.child(lists[index][0]).child('Request ${lists[index][3]}').update({ //Changes status in database
                                              'Status' : 'Rejected'
                                            });
                                            showSnackBar('Request has been successfully rejected');
                                          });
                                        },
                                      )
                                    )
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 70.0, right: 70.0, bottom: 10.0),
                                  child: Text('Requested at ${lists[index][4]}', style: TextStyle(color: Colors.white),),
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return Container( //Loading
                    height: heightScreen*0.2,
                    width: widthScreen*0.4,
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
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