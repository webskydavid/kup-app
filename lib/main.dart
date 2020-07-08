import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'views/main.view.dart';
import 'views/models/main.model.dart';
import 'views/splashscreen.view.dart';

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
      home: ViewModelBuilder<MainViewModel>.reactive(
        viewModelBuilder: () => MainViewModel(),
        fireOnModelReadyOnce: true,
        onModelReady: (model) async => await model.init(),
        builder: (context, model, child) {
          return model.isBusy ? SplashscreenPage() : MainView();
        },
      ),
    );
  }
}
