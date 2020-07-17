import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:kup_app/services/main.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratorService {
  MainService mainService;
  SharedPreferences shared;
  String repositoryDirectory = '';
  String startDate = '';
  String endDate = '';
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
    bool outputExists =
        await Directory('${mainService.scriptDirectory}/output').exists();
    if (outputExists) {
      await mainService.shell.run('rm -R output');
    }

    await mainService.shell.run('''
      #!/bin/bash
      #./cleanup.sh
      ./collectGitChangesList.sh "$repositoryDirectory" "$startDate" "$endDate"
      ./sortGitChangesList.sh
      ./aggregateGitChanges.sh
      ./generateKUPreportData.sh
      ./outputToPdf.sh "$startDate" "$endDate"
    ''');

    Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      String path = '${mainService.scriptDirectory}/output';
      if (Directory(path).existsSync() &&
          Directory(path).listSync().length != 0) {
        await mainService.shell.run('open ./output');
        timer.cancel();
      }
    });
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

  currentDateRange() {
    DateTime currentDate = DateTime.now();

    int firstDay = 1;
    int lastDay = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    startDate =
        '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${firstDay.toString().padLeft(2, '0')}';
    endDate =
        '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${lastDay.toString().padLeft(2, '0')}';
  }
}
