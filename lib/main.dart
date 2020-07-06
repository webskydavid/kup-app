import 'package:flutter/material.dart';
import 'package:kup_app/providers/main.provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'pages/main.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Injector(
          inject: [Inject(() => MainProvider())],
          builder: (_) {
            return MainPage();
          },
        ));
  }
}
