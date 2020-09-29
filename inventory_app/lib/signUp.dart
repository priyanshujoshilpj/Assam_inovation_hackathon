import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import 'package:inventoryapp/login.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUp> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailIdController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: <Widget>[
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
                      "Sign Up",
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
            padding: EdgeInsets.only(top: 50.00, left: 20.00,right: 20.00),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: userNameController,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter Username';
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFF536DFE))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))
                    ),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: emailIdController,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter Email ID';
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Email ID',
                        hintText: 'Enter your Email ID',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFF536DFE))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))
                    ),
                  ),
                  Container(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: true,
                    validator: (String value){
                      if(value.isEmpty){
                        return 'Enter Password';
                      }
                      else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF536DFE))
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Color(0xFF536DFE)
                          )
                        )
                    ),
                  ),
                  Container(
                    height: 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Go Back', style: TextStyle(color: Colors.white),),
                        color: Color(0xFF536DFE),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => LoginScreen()
                          ));
                        },
                      ),
                      Container(
                        width: widthScreen*0.5
                      ),
                      RaisedButton(
                        child: Text('Submit', style: TextStyle(color: Colors.white),),
                        color: Color(0xFF536DFE),
                        onPressed: (){
                          final dbRefUser = FirebaseDatabase.instance.reference().child("User");
                          dbRefUser.once().then((DataSnapshot snapshot) {
                            print('Data : ${snapshot.value}');
                            print(snapshot.value.toString().contains(emailIdController.text));
                            if(!snapshot.value.toString().contains(emailIdController.text)){
                              dbRefUser.child("${userNameController.text}").set(
                                  {
                                    'Email' : emailIdController.text,
                                    'Password' : passwordController.text,
                                    'Username' : userNameController.text
                                  }
                              );
                              showSnackBar('Account Created !');
                            }
                            else{
                              showSnackBar('Account with the same email ID exists');
                            }
                            Timer(Duration(seconds: 3), () {
                              Navigator.pop(context);
                            });
                          }
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          )
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