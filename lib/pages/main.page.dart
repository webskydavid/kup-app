import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:kup_app/providers/main.provider.dart';
import 'package:process_run/shell.dart' as shell;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http/http.dart' as http;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            WhenRebuilder(
              initState: (context, model) {
                model.setState((s) => s.init());
              },
              observe: () => RM.get<MainProvider>(),
              onData: (MainProvider data) {
                print('StateBuilder');
                return Text(data.workingDirectory);
              },
              onError: (e) {
                print(e);
                return Text('error');
              },
              onWaiting: () => LinearProgressIndicator(),
              onIdle: () => Text('onIdle'),
            ),
            Text(
              'Repository path:',
              style: TextStyle(color: Colors.grey),
            ),
            _buildSelectRepositoryButton(),
            SizedBox(
              height: 6.0,
            ),
            SizedBox(
              height: 6.0,
            ),
            OutlineButton.icon(
              textColor: Colors.green[700],
              padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
              onPressed: repositoryPath != '' ? () async {} : null,
              icon: Icon(Icons.autorenew),
              label: Text('Generate list'),
            ),
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
            if (!paths.canceled) {
              setState(() {
                repositoryPath = paths.paths[0];
              });
            }
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
        Text(
          repositoryPath,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
