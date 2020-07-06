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

class MainProvider {
  String workingDirectory = '';
  Shell shell;
  Client http = Client();

  void init() async {
    workingDirectory = await getWorkingDirectory();
    shell = Shell(workingDirectory: workingDirectory);

    getKupScript();
    unzipAndSave();
  }

  void getKupScript() async {
    Response res = await http.get(
      VALUES.gitRepositoryUrl + VALUES.commit,
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );
    File file = File('$workingDirectory/script.zip');
    await file.writeAsBytes(res.bodyBytes);
  }

  void unzipAndSave() async {
    try {
      if (await zipFileExists() && await scriptFolderNotExists()) {
        Uint8List zip =
            File('$workingDirectory/${VALUES.zipFileName}').readAsBytesSync();
        Archive files = ZipDecoder().decodeBytes(zip);
        String stringToReplace = files[0].name;
        Directory('$workingDirectory/${VALUES.kupScriptDirectory}')
            .createSync();

        files.forEach((element) async {
          String fileName =
              element.name.replaceFirst(RegExp(stringToReplace), '');
          if (element.isFile) {
            List<int> data = element.content as List<int>;
            File file = File(
                '$workingDirectory/${VALUES.kupScriptDirectory}/$fileName');
            file.createSync(recursive: true);
            file.writeAsBytesSync(data);
            //await changePermission(fileName);
          } else {
            Directory(
                    '$workingDirectory/${VALUES.kupScriptDirectory}/$fileName')
                .createSync();
          }
        });
      }
    } catch (e) {
      throw ErrorHint(e.toString());
    }
  }

  Future<bool> zipFileExists() async {
    return !(await File('$workingDirectory/${VALUES.zipFileName}').exists());
  }

  Future<bool> scriptFolderNotExists() async {
    return await Directory('$workingDirectory/${VALUES.kupScriptDirectory}')
        .exists();
  }

  Future<void> changePermission(String fileName) async {
    return await shell.run(
        'chmod 755 $workingDirectory/${VALUES.kupScriptDirectory}/$fileName');
  }

  Future<String> getWorkingDirectory() async {
    // TODO: remove delay
    await Future.delayed(Duration(milliseconds: 2000));
    return (await getApplicationSupportDirectory()).path;
  }
}
