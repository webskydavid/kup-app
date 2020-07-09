import 'dart:io';

import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:kup_app/views/models/main.model.dart';
import 'package:stacked/stacked.dart';

class GenerateModelView extends BaseViewModel {
  MainViewModel mainViewModel;
  List<List<dynamic>> commitList = [];

  init(model) {
    mainViewModel = model;
  }

  void run() async {
    print('runMainScript()');
    await mainViewModel.shell.run('''
      #!/bin/bash
      #./cleanup.sh
      ./collectGitChangesList.sh "${mainViewModel.repositoryDirectory}" "2020-07-01" "2020-07-31"
      ./sortGitChangesList.sh
      ./aggregateGitChanges.sh
      ./generateKUPreportData.sh
    ''');

    await generateListFromCSV();
    notifyListeners();
  }

  Future<void> generateListFromCSV() async {
    String path = '${mainViewModel.scriptDirectory}/kupReportData.csv';
    commitList = CsvToListConverter().convert(
      await File(path).readAsString(),
      fieldDelimiter: ',',
      textDelimiter: '"',
      eol: '\n',
    );
  }
}
