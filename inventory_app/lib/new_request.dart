import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/currentUserProfileData.dart';
import 'package:inventoryapp/requests.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class NewRequests extends StatefulWidget {

  NewRequests();
  @override
  NewRequestsState createState() => NewRequestsState();
}

class NewRequestsState extends State<NewRequests> {

  NewRequestsState();
  TextEditingController quantity = TextEditingController();
  TextEditingController address = TextEditingController();
  final dbRefUser = FirebaseDatabase.instance.reference().child("Inventory").child("User");
  List<dynamic> lists = [];
  final List<DropdownMenuItem> items = [];
  String selectedItem;
  bool enableQuantity = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
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
                    icon: Icon(Icons.arrow_back_ios, size: 20,),
                    iconSize: 32,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Requests()
                      ));
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
                      "Send New Request",
                      style: TextStyle(
                          fontSize: 28.00,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              )
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                child: FutureBuilder(
                  future: dbRefUser.once(),
                  builder: (
                      BuildContext context,
                      AsyncSnapshot<DataSnapshot> snapshot) {
                    if(snapshot.hasData){
                      print('Data : ${snapshot.data.value}');
                      items.clear();
                      Map<dynamic, dynamic> values = snapshot.data.value;
                      values.forEach((key, values) {
                        items.add(
                            DropdownMenuItem(
                              child: Text(key.toString()),
                              value: key,
                            )
                        );
                      });
                      return SearchableDropdown.single(
                        items: items,
                        value: selectedItem,
                        hint: "Select One",
                        searchHint: "Select One",

                        onChanged: (value) {
                          setState(() {
                            selectedItem = value;
                            enableQuantity = true;
                          });
                        },
                        isCaseSensitiveSearch: false,
                        isExpanded: true,
                      );
                    }
                    return Container(
                      height: heightScreen*0.2,
                      width: widthScreen*0.4,
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: quantity,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Enter Quantity';
                    }
                    else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Quantity',
                      hintText: 'Enter desired quantity',
                      enabled: enableQuantity,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Color(0xFF536DFE)
                        )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color(0xFF536DFE)
                          ))
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: address,
                  validator: (String value){
                    if(value.isEmpty){
                      return 'Enter address';
                    }
                    else{
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Address',
                      hintText: 'Enter your address',
                      enabled: enableQuantity,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color(0xFF536DFE)
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Color(0xFF536DFE)
                          ))
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40.00, left: 30.0, right: 30.0),
                child: RaisedButton(
                  color: Color(0xFF536DFE),
                  onPressed: () {
                    sendRequest();
                  },
                  child: Text('Send Request', style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void sendRequest(){
    final dbRefReq = FirebaseDatabase.instance.reference().child("Requests").child("${currentUserData.UserName}");
    dbRefReq.once().then((DataSnapshot snapshot) {
      print('Value : ${snapshot.value}');
      int number = 0;
      Map<dynamic, dynamic> values = snapshot.value;
      print(values);
      try{
        values.forEach((key, value) {
          print(key.toString().split(" ").last);
          int temp = int.parse(key.toString().split(" ").last);
          if(temp > number){
            number = temp;
          }
          print("x $number");
        });
      }
      catch(error){
        print(error);
      }
        dbRefReq.child("Request ${number+1}").set(
            {
              'Item' : selectedItem,
              'Quantity' : quantity.text,
              'Status' : "Pending",
              'Address' : address.text
            }
        );
        showSnackBar('Request Sent !');
  });}
  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}