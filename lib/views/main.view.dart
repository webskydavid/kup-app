import 'package:flutter/material.dart';
import 'package:kup_app/widgets/date_range_form.widget.dart';
import 'package:kup_app/widgets/select_repository.widget.dart';
import 'package:kup_app/widgets/title.widget.dart';

class MainView extends StatelessWidget {
  MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleWidget(color: Colors.black),
            SizedBox(
              height: 15.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Ścieżka do repozytoriów:',
                  style: TextStyle(color: Colors.grey),
                ),
                SelectRepositoryDirectory(),
                SizedBox(
                  height: 12.0,
                ),
                DateRangeFormWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
