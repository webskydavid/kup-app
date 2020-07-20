import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:kup_app/services/services.dart';
import 'package:kup_app/views/views.dart';

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
            return GeneratorService(mainService)..init();
          }, initialValue: GeneratorService(null)),
        ],
        builder: (BuildContext _) {
          return WhenRebuilderOr<GeneratorService>(
            observe: () => RM.get<GeneratorService>(),
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
