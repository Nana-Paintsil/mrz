import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mrz/pages/hompage.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/shared.dart';
import '../models/creator.dart';

class CreateAccount extends StatefulWidget {
  myModel model;
  String code;
  CreateAccount(this.model, this.code);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreateAccountState(model, code);
  }
}

bool _isLoading = false;
TextEditingController surnameController = TextEditingController();
TextEditingController givenNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
Country _selectedDialogCountry =
    CountryPickerUtils.getCountryByPhoneCode('233');
TextEditingController phoneNumberController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPassController = TextEditingController();
String pCountryCode = '';
final GlobalKey<FormState> _form1 = new GlobalKey<FormState>();
final TextEditingController _pass = TextEditingController();
final TextEditingController _confirmPass = TextEditingController();

String password = '';

class _CreateAccountState extends State<CreateAccount> {
  myModel model;
  String code;
  _CreateAccountState(this.model, this.code);
  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem2,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('GH'),
            ],
          ),
        ),
      );
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
    var size = MediaQuery.of(context).size;
    // TODO: implement build

    model.loadCountries();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.lightBlue, title: Text('Add New User')),
            body: Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
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
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
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
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Form(
                              key: _form1,
                              child: Column(children: <Widget>[
                                TextFormField(
                                  onSaved: (val) {
                                    emailController.text = val.toString();
                                  },
                                  onChanged: (val) {
                                    setState(() {
                                      emailController.text = val.trim();
                                      emailController.selection = TextSelection(
                                          baseOffset:
                                              emailController.text.length,
                                          extentOffset:
                                              emailController.text.length);
                                    });
                                  },
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: emailController,
                                  validator: (email) {
                                    final bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(email.toString());
                                    if (!emailValid) return 'Enter valid email';
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    textInputAction: TextInputAction.next,
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                    ),
                                    controller: _pass,
                                    validator: (val) {
                                      if (val!.isEmpty) return 'Empty';
                                      return null;
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                    textInputAction: TextInputAction.next,
                                    obscureText: true,
                                    onSaved: (val) {
                                      password = val.toString();
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Confirm Password',
                                    ),
                                    controller: _confirmPass,
                                    validator: (val) {
                                      if (val!.isEmpty) return 'Empty';
                                      if (val != _pass.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    }),
                              ])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              titlePadding: EdgeInsets.all(8.0),
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
                                                pCountryCode = country.isoCode;
                                              }),
                                              itemBuilder: _buildDialogItem2,
                                              priorityList: [
                                                CountryPickerUtils
                                                    .getCountryByIsoCode('GH'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        title: _buildDialogItem(
                                            _selectedDialogCountry),
                                      )),
                                ])),
                                Container(
                                  width: size.width / 1.7,
                                  child: TextField(
                                    textInputAction: TextInputAction.done,
                                    controller: phoneNumberController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      MaskedInputFormatter('(###) ###-####')
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
                        )
                      ],
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue),
                          child: _isLoading == true
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text('Save'),
                          onPressed: () {
                            if (surnameController.text == "" ||
                                givenNameController.text == "" ||
                                emailController.text == "" ||
                                phoneNumberController.text == "" ||
                                !_form1.currentState!.validate()) {
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
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.lightBlue),
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

                            setState(() {
                              _isLoading = true;
                            });
                            _form1.currentState!.save();
                            Creator _newCreator = Creator(
                                givenNameController.text,
                                surnameController.text,
                                emailController.text,
                                emailController.text,
                                password,
                                pCountryCode,
                                phoneNumberController.text,
                                code);

                            model.createUser(_newCreator).then((value) {
                              if (value == true) {
                                model
                                    .authenticate(
                                        _newCreator.email, _newCreator.password)
                                    .then((value) {
                                  print('done with authentication');
                                  model.loadCustomers().then((value) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HomePage(model)));
                                  });
                                });
                              }
                              if (value == false) {
                                showDialog(
                                    context: context,
                                    builder: (ctxt) => new AlertDialog(
                                          titlePadding:
                                              EdgeInsets.only(left: 7, top: 10),
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
                                              'Error Occured Creating the Account'),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.lightBlue),
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
                          },
                        )),
                  ],
                ))));
  }
}
