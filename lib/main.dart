import 'package:flutter/material.dart';
import 'package:kup_app/pages/splashscreen.page.dart';
import 'package:kup_app/providers/main.provider.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
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
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<MainProvider>(
            create: (context) => MainProvider(),
          )
        ],
        child: ViewModelBuilder<MainProvider>.reactive(
          viewModelBuilder: () => MainProvider(),
          onModelReady: (model) => model.init(),
          staticChild: MainPage(),
          builder: (context, model, child) {
            print(model.busy);
            return model.busy ? SplashscreenPage() : child;
          },
        ),
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
