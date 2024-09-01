import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mrz/auth/login_page.dart';
import 'package:mrz/models/shared.dart';
import 'package:mrz/pages/create_passenger.dart';
import 'package:mrz/pages/update_facility.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uni_links/uni_links.dart';

import '../models/customer.dart';
import '../widgets/customer_card.dart';
import 'add_customer.dart';

late bool authenticated;

class HomePage extends StatefulWidget {
  myModel model;
  HomePage(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _HomePageState(model);
  }
}

class _HomePageState extends State<HomePage> {
  myModel model;
  _HomePageState(this.model);

  bool _isSpecific = false;
  @override
  void initState() {
    _handleIncomingLinks();
    if (model.authenticated == false) {
      Future(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage(model)));
      });
    } else {
      model.foundPassengers = model.customers;
      model.loadCountries();
    }
    super.initState();
  }

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  StreamSubscription? _sub;
  void _handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        print('got uri: $uri');
        String code = uri.toString().split("v=")[1];
        print('is future working');
        Future(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => CreateAccount(model, code))));
        });
        setState(() {
          _latestUri = uri;
          _err = null;
        });
      }, onError: (Object err) {
        if (!mounted) return;
        print('got err: $err');
        setState(() {
          _latestUri = null;
          if (err is FormatException) {
            _err = err;
          } else {
            _err = null;
          }
        });
      });
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Customer> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      if (_isSpecific == false) {
        results = model.customers;
      } else {
        results = model.customers
            .where((user) =>
                user.retailOutletId == model.authenticatedUser.retailOutlet.id)
            .toList();
      }
    } else {
      if (_isSpecific == false) {
        // if the search field is empty or only contains white-space, we'll display all users
        results = model.customers
            .where((user) =>
                user.familyName
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                user.givenName
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                user.email.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();
      } else {
        results = model.customers
            .where((user) =>
                user.retailOutletId == model.authenticatedUser.retailOutlet.id)
            .toList();
        results = results
            .where((user) =>
                user.familyName
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                user.givenName
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                user.email.toLowerCase().contains(enteredKeyword.toLowerCase()))
            .toList();

        // we use the toLowerCase() method to make it case-insensitive
      }

      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      model.foundPassengers = results;
    });
  }

  void _runSelector(bool _isSpecific) {
    List<Customer> results = [];
    if (_isSpecific == false) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = model.customers;
    } else {
      results = model.customers
          .where((user) =>
              user.retailOutletId == model.authenticatedUser.retailOutlet.id)
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      model.foundPassengers = results;
    });
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the App?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return model.authenticated == true
        ? WillPopScope(
            onWillPop: showExitPopup, //call function on back button press
            child: Material(
                child: Scaffold(
                    drawer: SafeArea(
                      child: Drawer(
                        child: Column(
                          // Changed this to a Column from a ListView
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: CircleAvatar(
                                          radius: size.height / 15,
                                          child: Icon(
                                            Icons.person,
                                            size: size.height / 13,
                                          ))),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      model.authenticatedUser.userName
                                          .toString(),
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      model.authenticatedUser.email.toString(),
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 10, left: 20),
                                    child: Text(
                                      "Options",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )
                                ],
                              ),
                              decoration:
                                  BoxDecoration(color: Colors.lightBlue),
                              height: size.height / 3.75,
                            ),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateFacility(model)));
                                },
                                title: Row(
                                  children: <Widget>[
                                    Icon(Icons.local_convenience_store_sharp),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text('Update Facility'),
                                    )
                                  ],
                                )),
                            Expanded(
                                child:
                                    Container()), // Add this to force the bottom items to the lowest point
                            Column(
                              children: <Widget>[
                                ListTile(
                                  title: Row(
                                    children: <Widget>[
                                      Icon(Icons.logout),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Text('Log Out'),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (ctxt) => new AlertDialog(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              title: Text("Confirm Logout"),
                                              content: Text(
                                                  'Are you sure you want to logout'),
                                              actions: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop('dialog');
                                                      model
                                                          .logout()
                                                          .then((value) {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: ((context) =>
                                                                    LoginPage(
                                                                        model))));
                                                        setState(() {
                                                          authenticated = false;
                                                        });
                                                      });
                                                    },
                                                    child: Text('Yes')),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.white),
                                                    onPressed: () {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop('dialog');
                                                    },
                                                    child: Text(
                                                      'Discard',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ))
                                              ],
                                            ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => AddCustomer())))),
                    appBar: AppBar(
                      title: Text('Passengers Data'),
                    ),
                    body: SafeArea(
                        child: Container(
                            child: SingleChildScrollView(
                                child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isSpecific = false;
                                    });
                                    _runSelector(_isSpecific);
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        "All Facilities",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: _isSpecific == false
                                                ? Colors.white
                                                : Colors.lightBlue),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(),
                                          color: _isSpecific == false
                                              ? Colors.lightBlue
                                              : Colors.white)),
                                ),
                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSpecific = true;
                                      });
                                      _runSelector(_isSpecific);
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(12),
                                        child: Text("Current Facility",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: _isSpecific == true
                                                    ? Colors.white
                                                    : Colors.lightBlue)),
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            color: _isSpecific == true
                                                ? Colors.lightBlue
                                                : Colors.white)))
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              onChanged: (value) => _runFilter(value),
                              decoration: const InputDecoration(
                                  labelText: 'Search by name or email',
                                  suffixIcon: Icon(Icons.search)),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        /* Text(
                      'Passengers Data',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                          for (int i = 0; i < model.customers.length; i++)
                            CustomerCard(
                                model,
                                model.customers[i].familyName,
                                model.customers[i].givenName,
                                model.customers[i].gender,
                                model.customers[i].phoneNumber,
                                i),*/
                        for (int index = 0;
                            index < model.foundPassengers.length;
                            index++)
                          CustomerCard(
                              model,
                              model.foundPassengers[index].familyName,
                              model.foundPassengers[index].givenName,
                              model.foundPassengers[index].gender,
                              model.foundPassengers[index].phoneNumber,
                              index),
                      ],
                    )))))))
        : SafeArea(
            child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
