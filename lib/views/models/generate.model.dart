import 'dart:io';

import 'package:csv/csv.dart';
import 'package:kup_app/views/models/main.model.dart';
import 'package:stacked/stacked.dart';

class GenerateModelView extends BaseViewModel {
  String startDate = '2020-07-01';
  String endDate = '2020-07-31';
  MainViewModel mainViewModel;
  List<List<dynamic>> commitList = [];

  set setStartDate(value) {
    startDate = value;
  }

  set setEndDate(value) {
    endDate = value;
  }

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

    //await generateListFromCSV();
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
