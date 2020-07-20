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
}

class MainService {
  String workingDirectory = '';
  String kupScriptPath = '';
  String scriptZipFile = '';

  Shell shell;
  Client _http = Client();
  List commitList = [];

  MainService();

  Future<MainService> init() async {
    workingDirectory = await _getWorkingDirectory();
    kupScriptPath = '$workingDirectory/${VALUES.kupScriptDirectory}';
    scriptZipFile = '$workingDirectory/${VALUES.zipFileName}';

    shell = Shell(workingDirectory: kupScriptPath, commandVerbose: true);

    await _getKupScript();
    await _unzipAndSave();

    return this;
  }

  Future<void> _getKupScript() async {
    if (!(await _scriptFolderExists())) {
      Response res = await _http.get(
        VALUES.gitRepositoryUrl + VALUES.commit,
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );
      File file = File(scriptZipFile);
      await file.writeAsBytes(res.bodyBytes);
    }
  }

  Future<void> _unzipAndSave() async {
    try {
      if (!(await _scriptFolderExists()) && await _zipFileExists()) {
        Uint8List zip = File(scriptZipFile).readAsBytesSync();
        Archive files = ZipDecoder().decodeBytes(zip);
        String stringToReplace = files[0].name;
        Directory('$kupScriptPath').createSync();

        files.forEach((element) async {
          String fileName =
              element.name.replaceFirst(RegExp(stringToReplace), '');
          if (element.isFile) {
            List<int> data = element.content as List<int>;
            File file = File('$kupScriptPath/$fileName');
            file.createSync(recursive: true);
            file.writeAsBytesSync(data);
          } else {
            Directory('$kupScriptPath/$fileName').createSync();
          }
        });
        await _changePermission();
      }
    } catch (e) {
      throw ErrorHint(e.toString());
    }
  }

  Future<bool> _zipFileExists() async {
    return await File(scriptZipFile).exists();
  }

  Future<bool> _scriptFolderExists() async {
    return await Directory(kupScriptPath).exists();
  }

  Future<void> _changePermission() async {
    return await shell.run('chmod -R 755 .');
  }

  Future<String> _getWorkingDirectory() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return (await getApplicationSupportDirectory()).path;
  }
}
