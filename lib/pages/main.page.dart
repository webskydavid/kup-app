import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:kup_app/providers/main.provider.dart';
import 'package:kup_app/widgets/title.widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String repositoryPath = '';

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
                //ScriptDownloaderWidget(),
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Repository path:',
                  style: TextStyle(color: Colors.grey),
                ),
                _buildSelectRepositoryButton(),
                SizedBox(
                  height: 12.0,
                ),
                // StateBuilder<MainProvider>(
                //   observe: () => mainProvider,
                //   builder: (context, model) => OutlineButton.icon(
                //     textColor: Colors.green[700],
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
                //     onPressed: model.state.repositoryDirectory != ''
                //         ? () async {}
                //         : null,
                //     icon: Icon(Icons.autorenew),
                //     label: Text('Generate list'),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _buildSelectRepositoryButton() {
    return Row(
      children: [
        OutlineButton.icon(
          textColor: Colors.blue[700],
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          onPressed: () async {
            var paths = await fc.showOpenPanel(
              canSelectDirectories: true,
              allowsMultipleSelection: false,
            );
            if (!paths.canceled) {}
          },
          icon: Icon(Icons.folder_open),
          label: Text(
            'Select a folder',
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        // WhenRebuilderOr(
        //   observe: () => mainProvider,
        //   builder: (context, model) {
        //     return Text(
        //       model.state.repositoryDirectory,
        //       style: TextStyle(
        //         fontSize: 12.0,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     );
        //   },
        // ),
      ],
    );
  }
}
