import 'package:flutter/material.dart';
import 'package:kup_app/services/generator.service.dart';
import 'package:kup_app/services/main.service.dart';

import 'package:kup_app/views/main.view.dart';
import 'package:kup_app/views/splashscreen.view.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  RM.debugWidgetsRebuild = true;
  RM.debugPrintActiveRM = true;
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
        inject: [
          Inject<MainService>.future(() => MainService().init()),
          Inject<GeneratorService>.future(() async {
            final mainService = await RM.get<MainService>().stateAsync;
            var gs = GeneratorService(mainService);
            await gs.init();
            return gs;
          }, initialValue: GeneratorService(null)),
        ],
        builder: (BuildContext _) {
          return WhenRebuilderOr<MainService>(
            observe: () => RM.get<MainService>(),
            onWaiting: () => SplashscreenPage(),
            builder: (context, model) {
              return MainView();
            },
          );
        },
      ),
    );
  }
}
