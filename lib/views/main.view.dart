import 'package:flutter/material.dart';
import 'package:kup_app/services/services.dart';
import 'package:kup_app/widgets/widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MainView extends StatelessWidget {
  MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleWidget(color: Colors.black),
                SizedBox(height: 12.0),
                SelectRepositoryDirectory(),
                SizedBox(height: 12.0),
                DateRangeFormWidget(),
              ],
            ),
            WhenRebuilderOr<GeneratorService>(
              observe: () => RM.get<GeneratorService>(),
              builder: (context, model) => Column(
                children: [
                  FlatButton.icon(
                    onPressed: () {
                      model.state.goToDirectory();
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text('Pliki aplikacji'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
