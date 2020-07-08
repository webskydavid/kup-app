import 'package:flutter/material.dart';
import 'package:kup_app/views/main.view.dart';
import 'package:kup_app/views/splashscreen.view.dart';
import 'package:stacked/stacked.dart';

import 'views/models/main.model.dart';

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
        onModelReady: (model) async => await model.init(),
        builder: (context, model, child) {
          return model.isBusy ? SplashscreenPage() : MainView();
        },
      ),
    );
  }
}

// Injector(
//           inject: [
//             Inject(() => MainProvider()),
//           ],
//           builder: (_) {
//             return WhenRebuilderOr<MainProvider>(
//               initState: (_, m) => m.setState((s) async => await s.init()),
//               observe: () => RM.get<MainProvider>(),
//               builder: (_, model) => MainPage(),
//               onWaiting: () => SplashscreenPage(),
//             );
//           },
//         ));
