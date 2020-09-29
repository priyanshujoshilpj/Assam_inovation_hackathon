import 'package:flutter/material.dart';
import 'package:inventoryapp/admin/inventory.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class AddInventory extends StatefulWidget {

  AddInventory();
  @override
  AddInventoryState createState() => AddInventoryState();
}

class AddInventoryState extends State<AddInventory> {
  String dropdownValue = 'Admin Inventory';
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController enterOrigin = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<
      ScaffoldState>();
  TextEditingController delquantity = TextEditingController();
  final List<DropdownMenuItem> items = [];
  final List<DropdownMenuItem> itemsAdmin = [];
  String selectedItem;
  bool enableQuantity = false;
  bool origin = true;
  final dbRefInventory = FirebaseDatabase.instance.reference().child("Inventory");
  final dbRefTracking = FirebaseDatabase.instance.reference().child("Tracking");
  AddInventoryState();

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
                          builder: (context) => InventoryScreen()
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
                      "Add/Delete Items",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32.00,
                          color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              'Add Item',
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down_circle, color: Color(0xFF536DFE)),
              onChanged: (String newValue){
                setState(() {
                  dropdownValue = newValue;
                  print(dropdownValue);
                  if(newValue == 'User Inventory'){
                    origin = false;
                  }
                  else{
                    origin = true;
                  }
                });
              },
              items: <String>['Admin Inventory', 'User Inventory'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ),
          Form(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: name,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter Item Name';
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'Enter item name',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF536DFE))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))
                    ),
                  ),
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
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF536DFE))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))
                    ),
                  ),
                ),
                Visibility(
                  visible: origin,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: enterOrigin,
                      decoration: InputDecoration(
                          labelText: 'Origin',
                          hintText: 'Enter origin of item',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color(0xFF536DFE))
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.00, left: 30.0, right: 30.0),
            child: RaisedButton(
              onPressed: () {
                addItems(dropdownValue, name.text, int.parse(quantity.text));
              },
              child: Text('Add Item', style: TextStyle(color: Colors.white),),
              color: Color(0xFF536DFE),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'Delete Item',
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
              child: FutureBuilder(
                future: dbRefInventory.once(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<DataSnapshot> snapshot) {
                  if(snapshot.hasData){
                    print('Data : ${snapshot.data.value}');
                    itemsAdmin.clear();
                    Map<dynamic, dynamic> values = snapshot.data.value;
                    Map<dynamic,dynamic> user = values['User'];
                    Map<dynamic,dynamic> admin = values['Admin'];
                    user.forEach((key, values) {
                      itemsAdmin.add(
                          DropdownMenuItem(
                            child: Text(key.toString()),
                            value: key,
                          )
                      );
                    });
                    admin.forEach((key, values) {
                      itemsAdmin.add(
                          DropdownMenuItem(
                            child: Text(key.toString()),
                            value: key,
                          )
                      );
                    });
                    return SearchableDropdown.single(
                      items: itemsAdmin,
                      value: selectedItem,
                      hint: "Choose One",
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
            padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: delquantity,
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
                    borderSide: BorderSide(color: Color(0xFF536DFE))
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40.00, left: 30.0, right: 30.0),
            child: RaisedButton(
              onPressed: () {
                delItem(selectedItem, int.parse(delquantity.text));
              },
              child: Text('Delete Item', style: TextStyle(color: Colors.white),),
              color: Color(0xFF536DFE),
            ),
          )
        ],
      ),
    );
  }

  void addItems(String dropdownValue, String itemName, int quantity){
    if(dropdownValue == 'Admin Inventory'){
      dbRefInventory.child("Admin").once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        if(values[itemName] != null){
          dbRefInventory.child("Admin").update({
            itemName: values[itemName]+quantity
          });
        }
        else{
          values[itemName] = quantity;
          dbRefInventory.child("Admin").set(values);
        }
      });
      dbRefTracking.once().then((DataSnapshot snapshot) async{
        Map<dynamic, dynamic> origins = snapshot.value;
        int orderNumber = 1;
        origins.forEach((key, value) {
          if(orderNumber < int.parse(key.toString().split(" ")[1])){
            orderNumber = int.parse(key.toString().split(" ")[1]);
          }
        });
        dbRefTracking.child("Order ${orderNumber+1}").set(
          {
            'Item' : itemName,
            'Origin' : enterOrigin.text
          }
        );
      });
    }
    else{
      dbRefInventory.child("User").once().then((DataSnapshot snapshot) { //For tracking
        Map<dynamic, dynamic> values = snapshot.value;
        if(values[itemName] != null){
          dbRefInventory.child("User").update({
            itemName: values[itemName]+quantity
          });
        }
        else{
          values[itemName] = quantity;
          dbRefInventory.child("User").set(values);
          print(values);
        }
      });
    }
    showSnackBar("Item successfully added");
  }

  void delItem(String selectedItem, int quantity){
    print(selectedItem);
    dbRefInventory.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      Map<dynamic,dynamic> user = values['User'];
      Map<dynamic,dynamic> admin = values['Admin'];
      if(admin[selectedItem] != null){
        if(admin[selectedItem] > quantity){
          dbRefInventory.child('Admin').update({
            selectedItem: admin[selectedItem]-quantity
          });
        }
        else{
          dbRefInventory.child('Admin').child(selectedItem).remove();
        }
      }
      else{
        if(user[selectedItem] > quantity){ //Removing selected quantity
          dbRefInventory.child('User').update({
            selectedItem: user[selectedItem]-quantity
          });
        }
        else{ //If less quantity, item gets removed
          dbRefInventory.child('User').child(selectedItem).remove();
        }
      }
    });
    showSnackBar("Item successfully removed");
  }

  void showSnackBar(String message) { // For the snackbar
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}