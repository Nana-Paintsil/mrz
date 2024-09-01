import 'package:flutter/material.dart';
import 'package:mrz/pages/edit_customer.dart';

import '../models/shared.dart';

class CustomerCard extends StatelessWidget {
  myModel model;
  final String surname;
  final String givenNames;
  final String sex;
  final String phoneNumber;

  final int index;
  CustomerCard(this.model, this.surname, this.givenNames, this.sex,
      this.phoneNumber, this.index);

  @override
  Widget build(BuildContext context) {
    print(givenNames);
    final CustomerCardContent = new Container(
      margin: new EdgeInsets.all(17.0),
      constraints: new BoxConstraints.expand(),
      child: new Container(
        height: 4.0,
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Text('Name:',
                            style: new TextStyle(
                              fontSize: 17,
                            )),
                      ],
                    ),
                    new Container(height: 5.0),
                    new Text(surname + " " + givenNames,
                        style: new TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Phone Number:',
                        style: new TextStyle(
                          fontSize: 17,
                        )),
                    SizedBox(
                      width: 8,
                    ),
                    new Text(phoneNumber,
                        style: new TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              children: [
                new Text('Sex:',
                    style: new TextStyle(
                      fontSize: 17,
                    )),
                SizedBox(
                  width: 6,
                ),
                new Text(sex,
                    style: new TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
              ],
            )
          ],
        ),
      ),
    );

    final CustomerCard = Material(
        color: Colors.lightBlue.shade300,
        child: InkWell(
            highlightColor: Colors.cyan.shade50,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => EditCustomer(index, model)))),
            child: Container(
              child: CustomerCardContent,
              height: 160.0,
              decoration: new BoxDecoration(
                backgroundBlendMode: BlendMode.colorBurn,
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(8.0),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: new Offset(0.0, 10.0),
                  ),
                ],
              ),
            )));

    return new Container(
      height: 160.0,
      margin: EdgeInsets.only(left: 17, right: 17, top: 12, bottom: 0),
      child: new Column(
        children: <Widget>[
          CustomerCard,
        ],
      ),
    );
  }
}
