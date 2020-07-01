import 'dart:io' as io;

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
  String home = io.Platform.environment['HOME'];
  String currentPath = '';
  List<CustomPath> paths = [];

  @override
  void initState() {
    super.initState();
    currentPath = home;
    _loadPath();
  }

  _loadPath() {
    List<io.FileSystemEntity> pathList =
        io.Directory('$currentPath').listSync(followLinks: true);

    var p = pathList.where((e) {
      CustomPath customPath = CustomPath.customPath(e.path);
      return customPath.isDirectory;
    });
    paths = p.map<CustomPath>(
      (e) {
        return CustomPath.customPath(e.path);
      },
    ).toList();
  }

  String _getPrevPath() {
    List splited = currentPath.split('/');
    var withoutLastValue = splited.getRange(0, splited.length - 1);
    return withoutLastValue.join('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OutlineButton(onPressed: () {}, child: Text('Select repository')),
          OutlineButton(onPressed: () {}, child: Text('Select KUP script')),
          home != currentPath
              ? OutlineButton(
                  onPressed: () {
                    setState(() {
                      currentPath = _getPrevPath();
                      _loadPath();
                    });
                  },
                  child: Text('< Back'),
                )
              : Text(''),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all()),
            height: 300.0,
            width: 300.0,
            child: ListView.builder(
              itemCount: paths.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentPath = paths[i].path;
                      _loadPath();
                    });
                  },
                  child: Text(paths[i].name),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(currentPath),
          ),
          OutlineButton(onPressed: () {}, child: Text('Select directory'))
        ],
      ),
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
