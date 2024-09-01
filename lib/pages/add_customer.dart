import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mrz/models/retail.dart';

import 'package:mrz/widgets/retails.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../models/shared.dart';
import 'hompage.dart';

class AddCustomer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddCustomerState();
  }
}

class _AddCustomerState extends State<AddCustomer> {
  bool _isManual = false;
  bool _isLoading = false;
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
  String pCountryCode = '';
  String eCountryCode = '';
  String retailOutletId = '';
  bool expand = false;
  var genders = ['Sex', 'Male', 'Female'];
  bool isParsed = false;
  MRZController? controller;
  final GlobalKey<FormState> _form = new GlobalKey<FormState>();
  /* void loadFromCard() {
    if (result != null) {
      surnameController.text = result.surnames;
      givenNameController.text = result.givenNames;
      print("DOB" + result.birthDate.toString());
      setState(() {
        _isManual = true;
      });
      dobController.text = result.birthDate.toString().split(" ")[0];
      if (result.sex.toString().split('.')[1][0].toUpperCase() == 'M')
        genderValue = 'Male';
      if (result.sex.toString().split('.')[1][0].toUpperCase() == 'F')
        genderValue = 'Female';
    }
  }*/

  @override
  void dispose() {
    controller?.stopPreview();
    super.dispose();
  }

  void onControllerCreated(MRZController controller) {
    this.controller = controller;
    controller.onParsed = (result) async {
      if (isParsed) {
        return;
      }
      isParsed = true;
      surnameController.text = result.surnames;
      givenNameController.text = result.givenNames;
      print("DOB" + result.birthDate.toString());
      setState(() {
        _isManual = true;
      });
      dobController.text = result.birthDate.toString().split(" ")[0];
      if (result.sex.toString().split('.')[1][0].toUpperCase() == 'M')
        genderValue = 'Male';
      if (result.sex.toString().split('.')[1][0].toUpperCase() == 'F')
        genderValue = 'Female';
      Navigator.pop(context);
    };
    controller.onError = (error) => print(error);

    controller.startPreview();
  }

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
  Widget readZone(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<PermissionStatus>(
      future: Permission.camera.request(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == PermissionStatus.granted) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Camera'),
            ),
            body: MRZScanner(
              withOverlay: true,
              onControllerCreated: onControllerCreated,
            ),
          );
        }
        if (snapshot.data == PermissionStatus.permanentlyDenied) {
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          openAppSettings();
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Awaiting for permissions'),
                ),
                Text('Current status: ${snapshot.data?.toString()}'),
              ],
            ),
          ),
        );
      },
    );
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

  List<DropdownMenuItem<String>> _addDividersAfterItems(
      List<RetailOutlet> items) {
    print("items leng " + items.length.toString());

    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item.shortName,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.shortName,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(
                thickness: 2,
              ),
            ),
        ],
      );
    }
    return _menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<myModel>(builder: (context, child, model) {
      var size = MediaQuery.of(context).size;

      return WillPopScope(
          onWillPop: () async {
            if (surnameController.text != "" ||
                surnameController.text != "" ||
                givenNameController.text != "" ||
                emailController.text != "" ||
                dobController.text != "" ||
                phoneNumberController.text != "" ||
                emerNameController.text != "" ||
                emerNoController.text != "") {
              showDialog(
                  context: context,
                  builder: (ctxt) => new AlertDialog(
                        icon: Icon(
                          Icons.info,
                          color: Colors.red,
                        ),
                        title: Text("Confirm Return"),
                        content: Text(
                            'Do you want to go back without saving passenger details?'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(model)));
                              },
                              child: Text('Yes')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Discard',
                                style: TextStyle(color: Colors.black),
                              ))
                        ],
                      ));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomePage(model)));
              return false;
            }

            return false;
          },
          child: SafeArea(
              child: Scaffold(
                  appBar: AppBar(title: Text('Add Passenger')),
                  body: Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Selected Facility",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                      width: size.width / 1.5,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          border:
                                              Border.all(color: Colors.grey)),
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        model.authenticatedUser.retailOutlet
                                            .shortName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      )))),
                          _isManual == false
                              ? Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Scan Customer Details',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Material(
                                              color: Colors.lightGreen,
                                              child: Padding(
                                                  padding: EdgeInsets.all(7),
                                                  child: InkWell(
                                                    highlightColor: Colors.grey,
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: ((context) =>
                                                                  readZone(
                                                                      context))));
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .center_focus_weak_outlined,
                                                      size: 35,
                                                    ),
                                                  ))))
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      child: TextFormField(
                                        controller: givenNameController,
                                        textInputAction: TextInputAction.next,
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
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 0),
                                      child: TextFormField(
                                        controller: surnameController,
                                        textInputAction: TextInputAction.next,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: size.width / 2,
                                              child: TextField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                inputFormatters: [
                                                  MaskedInputFormatter(
                                                      '####-##-##')
                                                ],
                                                controller: dobController,
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'DOB (YYYY-MM-DD)',
                                                ),
                                              ),
                                            ),
                                            Container(
                                                width: size.width * 1 / 3,
                                                height: 57,
                                                child: DropdownButtonFormField(
                                                    alignment: Alignment.center,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder()),
                                                    value: genderValue,
                                                    icon: Icon(Icons
                                                        .keyboard_arrow_down_rounded),
                                                    items: genders
                                                        .map((String gender) {
                                                      return DropdownMenuItem(
                                                          value: gender,
                                                          child: Text(gender));
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        genderValue =
                                                            newValue.toString();
                                                      });
                                                    }))
                                          ],
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                          _isManual == false
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.blue,
                                          ),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          _isManual = true;
                                        });
                                      },
                                      child: Text(
                                        'Manually Enter Details',
                                      )))
                              : SizedBox(),
                          Column(
                            children: [
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
                                                      pCountryCode =
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
                                          textInputAction: TextInputAction.next,
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
                                  child: Form(
                                      key: _form,
                                      child: Column(children: <Widget>[
                                        TextFormField(
                                          onChanged: (val) {
                                            setState(() {
                                              emailController.text = val.trim();
                                              emailController.selection =
                                                  TextSelection(
                                                      baseOffset:
                                                          emailController
                                                              .text.length,
                                                      extentOffset:
                                                          emailController
                                                              .text.length);
                                            });
                                          },
                                          textInputAction: TextInputAction.next,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: emailController,
                                          validator: (email) {
                                            final bool emailValid = RegExp(
                                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(email.toString());
                                            if (!emailValid)
                                              return 'Enter valid email';
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Email',
                                          ),
                                        ),
                                      ]))),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                          _isManual == false
                              ? SizedBox()
                              : Container(
                                  padding: const EdgeInsets.all(10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.blue,
                                          ),
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.blue),
                                      onPressed: () {
                                        setState(() {
                                          _isManual = false;
                                        });
                                      },
                                      child: Text(
                                        'Scan Details from Card',
                                      ))),
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
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: size.width / 3.8,
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
                                                  eCountryCode =
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
                                      textInputAction: TextInputAction.done,
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
                                      emerNoController.text.length != 14 ||
                                      emerNameController.text == "" ||
                                      dobController.text == "" ||
                                      phoneNumberController.text.length != 14 ||
                                      !_form.currentState!.validate()) {
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
                                    _form.currentState!.save();
                                    model.newCustomer.familyName =
                                        surnameController.text;
                                    model.newCustomer.givenName =
                                        givenNameController.text;
                                    model.newCustomer.dateOfBirth =
                                        dobController.text;
                                    model.newCustomer.phoneNumberCountryCode =
                                        pCountryCode;
                                    model.newCustomer.emergencyContactName =
                                        emerNameController.text;
                                    model.newCustomer
                                            .emergencyContactCountryCode =
                                        eCountryCode;
                                    model.newCustomer.emergencyContactNumber =
                                        emerNoController.text;
                                    model.newCustomer.email =
                                        emailController.text;
                                    model.newCustomer.phoneNumber =
                                        phoneNumberController.text;
                                    model.newCustomer.retailOutletId =
                                        model.authenticatedUser.retailOutlet.id;
                                    if (genderValue == 'Sex')
                                      model.newCustomer.gender = "NA";
                                    else
                                      model.newCustomer.gender = genderValue;
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    model.addCustomer().then((value) {
                                      if (value == true)
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
                                      if (value == false) {
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
                                                      'Couldn\' add passenger to database'),
                                                  actions: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .lightBlue),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('OK'),
                                                    )
                                                  ],
                                                ));
                                      }
                                    });
                                  }
                                },
                              )),
                        ],
                      )))));
    });
  }
}
