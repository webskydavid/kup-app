import 'dart:io' as io;
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String repositoryPath = '';
  String kupScriptPath = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(io.Directory.current);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Repository path:',
              style: TextStyle(color: Colors.grey),
            ),
            _buildSelectRepositoryButton(),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Kup-Script path:',
              style: TextStyle(color: Colors.grey),
            ),
            _buildSelectKupScriptButton(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton.icon(
              textColor: Colors.green[700],
              padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
              onPressed: () {},
              icon: Icon(Icons.autorenew),
              label: Text('Generate list'),
            ),
            Container(
              child: Table(
                children: [
                  TableRow(children: [
                    Text('fwfe'),
                    Text('fewfe'),
                  ])
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _buildSelectKupScriptButton() {
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

            setState(() {
              kupScriptPath = paths.paths[0];
            });
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
          kupScriptPath,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
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

            setState(() {
              repositoryPath = paths.paths[0];
            });
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

class CustomPath {
  String path;
  String name;
  bool isDirectory;

  CustomPath(this.path, this.name, this.isDirectory);

  static bool isPathDirectory(p) {
    return !io.File(p).existsSync();
  }

  static String pathName(p) {
    return p.split('/').last;
  }

  static customPath(String newPath) {
    return CustomPath(newPath, pathName(newPath), isPathDirectory(newPath));
  }
}
