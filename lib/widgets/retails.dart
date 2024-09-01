import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mrz/models/retail.dart';
import '../models/country.dart';

class OutletCard extends StatelessWidget {
  RetailOutlet _retailOutlet;
  OutletCard(this._retailOutlet);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // TODO: imp

    return Container(
        width: size.width / 1.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_retailOutlet.shortName),
          ],
        ));
  }
}
