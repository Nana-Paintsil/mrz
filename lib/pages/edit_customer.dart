import 'dart:math';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/customer.dart';
import '../models/shared.dart';
import 'hompage.dart';

class EditCustomer extends StatefulWidget {
  int index;
  myModel model;
  EditCustomer(this.index, this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditCustomerState(index, model);
  }
}

class _EditCustomerState extends State<EditCustomer> {
  int index;
  myModel model;
  _EditCustomerState(this.index, this.model);

  bool _isDeleting = false;
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('233');
  Country _selectedDialogCountry1 =
      CountryPickerUtils.getCountryByPhoneCode('233');
  TextEditingController surnameController = TextEditingController();
  TextEditingController givenNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emerNameController = TextEditingController();
  TextEditingController emerNoController = TextEditingController();
  String genderValue = 'Sex';
  bool _isLoading = false;
  String eCountryCodeValue = 'GH';

  String pCountryCodeValue = 'GH';

  var genders = ['Sex', 'Male', 'Female'];
  @override
  void initState() {
    if (model.foundPassengers[index].gender[0].toUpperCase() == "M")
      genderValue = "Male";
    if (model.foundPassengers[index].gender[0].toUpperCase() == "F")
      genderValue = "Female";
    if (model.foundPassengers[index].phoneNumberCountryCode != "")
      pCountryCodeValue = model.foundPassengers[index].phoneNumberCountryCode;
    if (model.foundPassengers[index].emergencyContactCountryCode != "")
      eCountryCodeValue =
          model.foundPassengers[index].emergencyContactCountryCode;

    _selectedDialogCountry =
        CountryPickerUtils.getCountryByIsoCode(eCountryCodeValue);
    _selectedDialogCountry1 =
        CountryPickerUtils.getCountryByIsoCode(pCountryCodeValue);
    surnameController.text = model.foundPassengers[index].familyName;
    givenNameController.text = model.foundPassengers[index].givenName;
    emailController.text = model.foundPassengers[index].email;
    dobController.text = model.foundPassengers[index].dateOfBirth;
    phoneNumberController.text = model.foundPassengers[index].phoneNumber;
    emerNameController.text = model.foundPassengers[index].emergencyContactName;
    emerNoController.text = model.foundPassengers[index].emergencyContactNumber;

    super.initState();
  }

  Widget _buildDialogItem(Country country) => Container(
        padding: EdgeInsets.all(5),
        child: Text("+${country.phoneCode}"),
      );
  Widget _buildDialogItem2(Country country) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CircleAvatar(
            radius: 12,
            child: country.isoCode.length == 2
                ? SvgPicture.asset(
                    'assets/flags/${country.isoCode.toLowerCase()}.svg',
                  )
                : Container()),
        SizedBox(width: 8.0),
        if (country.name.length > 16)
          Text(country.name.toString().substring(0, 16) + '...')
        else
          Text(country.name),
        SizedBox(width: 8.0),
        Text("+${country.phoneCode}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<myModel>(builder: (context, child, model) {
      var size = MediaQuery.of(context).size;

      return _isDeleting == true
          ? Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Center(child: CircularProgressIndicator()),
            )
          : SafeArea(
              child: Scaffold(
                  appBar: AppBar(actions: [
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctxt) => new AlertDialog(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  title: Text("Confirm Delete"),
                                  content:
                                      Text('Are you sure you want to delete'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          setState(() {
                                            _isDeleting = true;
                                          });

                                          model.deleteCustomer(index).then(
                                              (value) => model
                                                      .loadCustomers()
                                                      .then((value) {
                                                    setState(() {
                                                      _isDeleting = false;
                                                    });
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HomePage(
                                                                    model)));
                                                  }));
                                        },
                                        child: Text('Yes')),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: Text(
                                          'Discard',
                                          style: TextStyle(color: Colors.black),
                                        ))
                                  ],
                                ));
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: size.width / 12,
                    )
                  ], title: Text('Customer Details')),
                  body: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: TextFormField(
                                  controller: givenNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Given Name(s)',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: TextFormField(
                                  controller: surnameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Surname',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: size.width / 2,
                                        child: TextField(
                                          controller: dobController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'DOB (MM/DD/YY)',
                                          ),
                                        ),
                                      ),
                                      Container(
                                          width: size.width * 1 / 3,
                                          height: 57,
                                          child: DropdownButtonFormField(
                                              alignment: Alignment.center,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder()),
                                              value: genderValue,
                                              icon: Icon(Icons
                                                  .keyboard_arrow_down_rounded),
                                              items:
                                                  genders.map((String gender) {
                                                return DropdownMenuItem(
                                                    value: gender,
                                                    child: Text(gender));
                                              }).toList(),
                                              onChanged: (String? neValue) {
                                                setState(() {
                                                  genderValue =
                                                      neValue.toString();
                                                });
                                              }))
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Card(
                                          child: Column(children: <Widget>[
                                        Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color: Colors.white54),
                                            width: size.width / 3.8,
                                            child: ListTile(
                                              onTap: () => showDialog(
                                                context: context,
                                                builder: (context) => Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          primaryColor:
                                                              Colors.pink),
                                                  child: CountryPickerDialog(
                                                    titlePadding:
                                                        EdgeInsets.all(8.0),
                                                    searchCursorColor:
                                                        Colors.pinkAccent,
                                                    searchInputDecoration:
                                                        InputDecoration(
                                                            hintText:
                                                                'Search...'),
                                                    isSearchable: true,
                                                    itemFilter: (c) => model
                                                        .countryCodes
                                                        .contains(c.isoCode),
                                                    title: Text(
                                                        'Select your phone code'),
                                                    onValuePicked:
                                                        (Country country) =>
                                                            setState(() {
                                                      _selectedDialogCountry1 =
                                                          country;
                                                      pCountryCodeValue =
                                                          country.isoCode;
                                                    }),
                                                    itemBuilder:
                                                        _buildDialogItem2,
                                                    priorityList: [
                                                      CountryPickerUtils
                                                          .getCountryByIsoCode(
                                                              'GH'),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              title: _buildDialogItem(
                                                  _selectedDialogCountry1),
                                            )),
                                      ])),
                                      Container(
                                        width: size.width / 2,
                                        child: TextField(
                                          controller: phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            MaskedInputFormatter(
                                                '(###) ###-####')
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Phone Number',
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Emergency Contact Details',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: emerNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                      child: Column(children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: Colors.white54),
                                        width: size.width / 3.8,
                                        child: ListTile(
                                          onTap: () => showDialog(
                                            context: context,
                                            builder: (context) => Theme(
                                              data: Theme.of(context).copyWith(
                                                  primaryColor: Colors.pink),
                                              child: CountryPickerDialog(
                                                titlePadding:
                                                    EdgeInsets.all(8.0),
                                                searchCursorColor:
                                                    Colors.pinkAccent,
                                                searchInputDecoration:
                                                    InputDecoration(
                                                        hintText: 'Search...'),
                                                isSearchable: true,
                                                itemFilter: (c) => model
                                                    .countryCodes
                                                    .contains(c.isoCode),
                                                title: Text(
                                                    'Select your phone code'),
                                                onValuePicked:
                                                    (Country country) =>
                                                        setState(() {
                                                  _selectedDialogCountry =
                                                      country;
                                                  eCountryCodeValue =
                                                      country.isoCode;
                                                }),
                                                itemBuilder: _buildDialogItem2,
                                                priorityList: [
                                                  CountryPickerUtils
                                                      .getCountryByIsoCode(
                                                          'GH'),
                                                ],
                                              ),
                                            ),
                                          ),
                                          title: _buildDialogItem(
                                              _selectedDialogCountry),
                                        )),
                                  ])),
                                  Container(
                                    width: size.width / 2,
                                    child: TextFormField(
                                      controller: emerNoController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        MaskedInputFormatter('(###) ###-####')
                                      ],
                                      decoration: const InputDecoration(
                                        labelText: 'No. in case of emergency',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
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
                                    : Text('Update Passenger Details'),
                                onPressed: () {
                                  if (surnameController.text == "" ||
                                      givenNameController.text == "" ||
                                      emerNoController.text.length != 14 ||
                                      emerNameController.text == "" ||
                                      dobController.text == "" ||
                                      phoneNumberController.text.length != 14) {
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
                                                    Text("Error"),
                                                    SizedBox(width: 7)
                                                  ]),
                                              content: Text(
                                                  'Please Fill Necessary Details Correctly'),
                                              actions: [
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.lightBlue),
                                                  onPressed: () {
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                  child: Text('OK'),
                                                )
                                              ],
                                            ));
                                  } else {
                                    print(pCountryCodeValue);
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    model.neCustomer.id =
                                        model.foundPassengers[index].id;
                                    model.neCustomer.version =
                                        model.foundPassengers[index].version;
                                    model.neCustomer.familyName =
                                        surnameController.text;
                                    model.neCustomer.givenName =
                                        givenNameController.text;
                                    model.neCustomer.dateOfBirth =
                                        dobController.text;
                                    model.neCustomer.phoneNumberCountryCode =
                                        pCountryCodeValue;
                                    model.neCustomer.emergencyContactName =
                                        emerNameController.text;
                                    model.neCustomer
                                            .emergencyContactCountryCode =
                                        eCountryCodeValue;
                                    model.neCustomer.emergencyContactNumber =
                                        emerNoController.text;
                                    model.neCustomer.email =
                                        emailController.text;
                                    model.neCustomer.phoneNumber =
                                        phoneNumberController.text;
                                    model.neCustomer.gender = genderValue;
                                    model
                                        .updateCustomer(index, model.neCustomer)
                                        .then((value) =>
                                            model.loadCustomers().then((value) {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage(model)));
                                            }));
                                  }
                                },
                              )),
                        ],
                      ))));
    });
  }
}
