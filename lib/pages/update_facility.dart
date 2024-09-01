import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mrz/models/shared.dart';
import 'package:mrz/pages/hompage.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/retail.dart';
import '../widgets/retails.dart';

class UpdateFacility extends StatefulWidget {
  myModel model;
  UpdateFacility(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateFacilityState(model);
  }
}

String retailOutletId = '';

class _UpdateFacilityState extends State<UpdateFacility> {
  myModel model;
  _UpdateFacilityState(this.model);
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState

    retailOutletId = model.authenticatedUser.retailOutlet.id;

    model.loadOutlets(model.authenticatedUser.token).then((value) {
      if (value == true) {
        setState(() {
          _isLoading = false;
        });
      } else {
        showDialog(
            context: context,
            builder: (ctxt) => new AlertDialog(
                  titlePadding: EdgeInsets.only(left: 7, top: 10),
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        Text("Connectivity Error"),
                        SizedBox(width: 7)
                      ]),
                  content: Text('Could not retrieve current facilities!'),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue),
                      onPressed: () {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    )
                  ],
                ));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return _isLoading == true
        ? SafeArea(
            child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: const Center(
                  child: CircularProgressIndicator(),
                )))
        : Scaffold(
            appBar: AppBar(title: Text("Update Facility")),
            body: Container(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Column(children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Select Facility",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                          width: size.width,
                          child: DropdownButtonFormField(
                              decoration:
                                  InputDecoration(border: OutlineInputBorder()),
                              alignment: Alignment.bottomCenter,
                              value: model.retailOutlets
                                  .firstWhere(
                                      (element) => element.id == retailOutletId)
                                  .shortName,
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              items: model.retailOutlets
                                  .map((RetailOutlet retailOutlet) {
                                return DropdownMenuItem(
                                    value: retailOutlet.shortName,
                                    child: OutletCard(retailOutlet));
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  retailOutletId = model.retailOutlets
                                      .firstWhere((element) =>
                                          element.shortName ==
                                          newValue.toString())
                                      .id;
                                  print(model.retailOutlets
                                      .firstWhere((element) =>
                                          element.id == retailOutletId)
                                      .shortName);
                                });
                              }))),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          child: _isLoading == true
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                )
                              : Text('Save'),
                          onPressed: () {
                            model.updateOutlet(retailOutletId).then((value) {
                              showDialog(
                                  context: context,
                                  builder: (ctxt) => new AlertDialog(
                                        titlePadding:
                                            EdgeInsets.only(left: 7, top: 10),
                                        title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(
                                                Icons.info_sharp,
                                                color: Colors.blue,
                                              ),
                                              Text("Information"),
                                              SizedBox(width: 7)
                                            ]),
                                        content: Text(
                                            'Facility Successfully Updated'),
                                        actions: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.lightBlue),
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          HomePage(model))));
                                            },
                                            child: Text('OK'),
                                          )
                                        ],
                                      ));
                            });
                          })),
                ]))));
  }
}
