import 'dart:io' as io;
import 'dart:typed_data';
import 'package:archive/archive_io.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart' as shell;
import 'package:process_run/src/user_config.dart';
import 'package:process_run/process_run.dart' as process_run;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:http/http.dart' as http;

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
      home: MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class VALUES {
  static String gitRepositoryUrl =
      'https://api.github.com/repos/pawelpluta/kup-script/zipball/';
  static String commit = 'master';
  static String zipFileName = 'script.zip';
  static String kupScriptDirectory = 'kup-script';
}

class _MainPageState extends State<MainPage> {
  bool isDownloading = false;
  String repositoryPath = '';
  String currentDir = '';

  @override
  void initState() {
    super.initState();
    path_provider.getApplicationSupportDirectory().then((value) {
      if (!io.File('${value.path}/${VALUES.zipFileName}').existsSync()) {
        _getKupScript(value.path);
      }
    });
  }

  void _isDownloading(state) {
    setState(() {
      isDownloading = state;
    });
  }

  void _getKupScript(path) async {
    _isDownloading(true);
    http.Response res = await http.get(
      VALUES.gitRepositoryUrl + VALUES.commit,
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );
    io.File file = io.File('$path/script.zip');
    await file.writeAsBytes(res.bodyBytes);
    _unzipAndSave(path);
    _isDownloading(false);
  }

  void _unzipAndSave(path) {
    Uint8List zip = io.File('$path/${VALUES.zipFileName}').readAsBytesSync();
    Archive files = ZipDecoder().decodeBytes(zip);
    var replaceStr = files[0].name;
    io.Directory('$path/${VALUES.kupScriptDirectory}').createSync();

    files.forEach((element) {
      var filename = element.name.replaceFirst(RegExp(replaceStr), '');
      if (element.isFile) {
        var data = element.content as List<int>;
        var file = io.File('$path/${VALUES.kupScriptDirectory}/${filename}');
        file.createSync(recursive: true);
        file.writeAsBytesSync(data);
      } else {
        io.Directory('$path/${VALUES.kupScriptDirectory}/${filename}')
            .createSync();
      }
    });
  }

  Future<String> _readFile(String fileName) async {
    var path = await path_provider.getApplicationSupportDirectory();
    return io.File('${path.path}/${VALUES.kupScriptDirectory}/$fileName')
        .readAsStringSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isDownloading ? Text('Downloading scripts!') : Text(''),
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
              onPressed: repositoryPath == ''
                  ? () async {
                      var s = shell.Shell();
                      //print(await _readFile('cleanup.sh'));
                      var userPaths = getUserPaths(<String, String>{});
                      // for (var path in userPaths) {
                      //   print(path);
                      // }

                      await s.run('''
                        # Display some text
                        echo Hello
                        # Display dart version
                        dart --version
                        # Display pub version
                        pub --version
                      ''');

                      s = s.pushd('example');

                      await s.run('''
# Listing directory in the example folder
dir
  ''');
                      s = s.popd();
                    }
                  : null,
              icon: Icon(Icons.autorenew),
              label: Text('Generate list'),
            ),
            Text(currentDir),
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
