import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mrz/models/shared.dart';
import 'package:mrz/pages/create_passenger.dart';
import 'package:mrz/pages/hompage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/services.dart' show PlatformException;
import './auth/login_page.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  myModel model = myModel();
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
          model.logout().then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: ((context) => CreateAccount(model, code)))));
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

  @override
  void initState() {
    _handleIncomingLinks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<myModel>(
        model: model,
        child: MaterialApp(
            theme: ThemeData(
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.lightGreen),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue.shade400)),
              appBarTheme: AppBarTheme(color: Colors.lightBlue.shade400),
              textTheme: TextTheme(
                bodyText2: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            home: HomePage(model)));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
