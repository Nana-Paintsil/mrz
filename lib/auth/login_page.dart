import 'dart:async';

import 'package:flutter/material.dart';

import 'package:mrz/pages/hompage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:mrz/models/shared.dart';

import '../models/nospace.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({Key? key}) : super(key: key);
  myModel model;
  LoginPage(this.model);
  @override
  State<LoginPage> createState() => _LoginPageState(model);
}

class _LoginPageState extends State<LoginPage> {
  myModel model;
  _LoginPageState(this.model);
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _autoLogin = true;

  StreamSubscription? _sub;
  @override
  void initState() {
    // TODO: implement initState
    model.autoLogin().then((value) {
      if (value == false) {
        setState(() {
          _autoLogin = false;
        });
      }
      if (value == true && model.retailOutlets.length < 2) {
        setState(() {
          _autoLogin = false;
        });
      }
      if (value == true && model.retailOutlets.length > 2) {
        model.loadCustomers().then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomePage(model)));
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<myModel>(builder: (context, child, model) {
      var size = MediaQuery.of(context).size;
      return _autoLogin == true
          ? SafeArea(
              child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  )))
          : SafeArea(
              child: Scaffold(
                  body: Container(
                      padding: EdgeInsets.all(size.width / 12),
                      child: ListView(
                        children: <Widget>[
                          Center(
                            child: Image.asset(
                              'assets/logo/bus-ticketing-logo2.png',
                              scale: size.width / 200,
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 40),
                              )),
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                'Enter your credentials to get started',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18),
                              )),
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                'Email',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20),
                              )),
                          Container(
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  nameController.text = val.trim();
                                  nameController.selection = TextSelection(
                                      baseOffset: nameController.text.length,
                                      extentOffset: nameController.text.length);
                                });
                              },
                              textInputAction: TextInputAction.next,
                              controller: nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: const Text(
                                'Password',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20),
                              )),
                          Container(
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              controller: passwordController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextButton(
                            onPressed: () {
                              //forgot password screen
                            },
                            child: const Text(
                              'Forgot Password',
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              height: 50,
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: ElevatedButton(
                                child: _isLoading
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ))
                                    : Text('Login'),
                                onPressed: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await model
                                      .authenticate(nameController.text,
                                          passwordController.text)
                                      .then((value) async {
                                    print("AGETR LOGIN VALUe " +
                                        value.toString());
                                    if (value == true) {
                                      await model
                                          .loadCustomers()
                                          .then((value) async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage(model)));
                                      });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (ctxt) => new AlertDialog(
                                                titlePadding: EdgeInsets.only(
                                                    left: 7, top: 10),
                                                title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                      Text(
                                                          "Authentication Error"),
                                                      SizedBox(width: 7)
                                                    ]),
                                                content: Text(
                                                    'Invalid Email or Password!'),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .lightBlue),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop('dialog');
                                                    },
                                                    child: Text('OK'),
                                                  )
                                                ],
                                              ));
                                    }
                                  });
                                },
                              )),
                          SizedBox(
                            height: size.height / 4,
                          )
                          /*  Row(
                  children: <Widget>[
                    const Text('Does not have account?'),
                    TextButton(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //signup screen
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),*/
                        ],
                      ))));
    });
  }
}
