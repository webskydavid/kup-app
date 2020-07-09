import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';

class VALUES {
  static String gitRepositoryUrl =
      'https://api.github.com/repos/pawelpluta/kup-script/zipball/';
  static String commit = 'master';
  static String zipFileName = 'script.zip';
  static String kupScriptDirectory = 'kup-script';
  static String csvDirectory = 'csv';
}

class MainViewModel extends BaseViewModel {
  SharedPreferences shared;
  String repositoryDirectory = '';
  String workingDirectory = '';
  String scriptDirectory = '';
  Shell shell;
  Client http = Client();
  List commitList = [];

  MainViewModel();

  Future<void> init() async {
    print('init()');
    setBusy(true);
    shared = await SharedPreferences.getInstance();
    workingDirectory = await getWorkingDirectory();
    scriptDirectory = '$workingDirectory/${VALUES.kupScriptDirectory}';
    shell = Shell(workingDirectory: scriptDirectory, commandVerbose: true);
    getRepositoryDirectory();

    await createDirectory(VALUES.csvDirectory);
    await getKupScript();
    await unzipAndSave();
    setBusy(false);
  }

  Future<void> getKupScript() async {
    print('getKupScript()');
    if (!(await scriptFolderExists())) {
      Response res = await http.get(
        VALUES.gitRepositoryUrl + VALUES.commit,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );
      File file = File('$workingDirectory/script.zip');
      await file.writeAsBytes(res.bodyBytes);
    }
  }

  Future<void> unzipAndSave() async {
    print('unzipAndSave()');
    try {
      if (!(await scriptFolderExists()) && await zipFileExists()) {
        Uint8List zip =
            File('$workingDirectory/${VALUES.zipFileName}').readAsBytesSync();
        Archive files = ZipDecoder().decodeBytes(zip);
        String stringToReplace = files[0].name;
        Directory('$scriptDirectory').createSync();

        files.forEach((element) async {
          String fileName =
              element.name.replaceFirst(RegExp(stringToReplace), '');
          if (element.isFile) {
            List<int> data = element.content as List<int>;
            File file = File('$scriptDirectory/$fileName');
            file.createSync(recursive: true);
            file.writeAsBytesSync(data);
          } else {
            Directory('$scriptDirectory/$fileName').createSync();
          }
        });
        await changePermission();
      }
    } catch (e) {
      throw ErrorHint(e.toString());
    }
  }

  void setRepositoryDirectory(String path) async {
    print('setRepositoryDirectory()');
    await shared.setString('repositoryDirectory', path);
    repositoryDirectory = path;
    notifyListeners();
  }

  void getRepositoryDirectory() {
    repositoryDirectory = shared.getString('repositoryDirectory');
  }

  Future<bool> zipFileExists() async {
    print('zipFileExists()');
    return await File('$workingDirectory/${VALUES.zipFileName}').exists();
  }

  Future<bool> scriptFolderExists() async {
    print('scriptFolderExists()');
    return await Directory('$workingDirectory/${VALUES.kupScriptDirectory}')
        .exists();
  }

  Future<void> changePermission() async {
    return await shell.run('chmod -R 755 $workingDirectory');
  }

  Future<String> getWorkingDirectory() async {
    print('getWorkingDirectory()');
    // TODO: remove delay
    await Future.delayed(Duration(milliseconds: 2000));
    return (await getApplicationSupportDirectory()).path;
  }

  Future<void> createDirectory(String folder) async {
    print('createDirectory()');
    return await Directory('$workingDirectory/$folder').create();
  }
}
