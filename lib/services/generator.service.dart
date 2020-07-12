import 'dart:io';

import 'package:csv/csv.dart';
import 'package:kup_app/services/main.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratorService {
  bool isBusy = false;
  MainService mainService;
  SharedPreferences shared;
  String repositoryDirectory = '';
  String startDate = '2020-07-01';
  String endDate = '2020-07-31';
  List<List<dynamic>> commitList = [];

  GeneratorService(this.mainService);

  Future<void> init() async {
    shared = await SharedPreferences.getInstance();
    getRepositoryDirectory();
  }

  set setStartDate(value) {
    startDate = value;
  }

  set setEndDate(value) {
    endDate = value;
  }

  void run() async {
    isBusy = true;
    print('runMainScript()');
    await mainService.shell.run('''
      #!/bin/bash
      #./cleanup.sh
      ./collectGitChangesList.sh "$repositoryDirectory" "$startDate" "$endDate"
      ./sortGitChangesList.sh
      ./aggregateGitChanges.sh
      ./generateKUPreportData.sh
    ''');

    //await generateListFromCSV();
    isBusy = false;
  }

  Future<void> generateListFromCSV() async {
    String path = '${mainService.scriptDirectory}/kupReportData.csv';
    commitList = CsvToListConverter().convert(
      await File(path).readAsString(),
      fieldDelimiter: ',',
      textDelimiter: '"',
      eol: '\n',
    );
  }

  Future<void> setRepositoryDirectory(String path) async {
    print('setRepositoryDirectory()');
    await shared.setString('repositoryDirectory', path);
    repositoryDirectory = path;
    await Future.delayed(Duration(milliseconds: 1000));
  }

  void getRepositoryDirectory() {
    repositoryDirectory = shared.getString('repositoryDirectory');
  }
}
