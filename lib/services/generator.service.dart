import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:kup_app/services/main.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneratorService {
  String repositoryDirectory = '';
  String startDate = '';
  String endDate = '';
  List<List<dynamic>> commitList = [];
  final MainService _mainService;
  SharedPreferences _shared;

  GeneratorService(this._mainService);

  Future<void> init() async {
    _shared = await SharedPreferences.getInstance();
    _getRepositoryDirectory();
  }

  set setStartDate(value) {
    startDate = value;
  }

  set setEndDate(value) {
    endDate = value;
  }

  void run() async {
    await _removeOutputDirectory();
    await _generateKupReport();
    await _watchOutputDirectory();
  }

  Future<void> generateListFromCSV() async {
    String path = '${_mainService.kupScriptPath}/kupReportData.csv';
    commitList = CsvToListConverter().convert(
      await File(path).readAsString(),
      fieldDelimiter: ',',
      textDelimiter: '"',
      eol: '\n',
    );
  }

  Future<void> setRepositoryDirectory(String path) async {
    await _shared.setString('repositoryDirectory', path);
    repositoryDirectory = path;
  }

  void currentDateRange() {
    DateTime currentDate = DateTime.now();
    int firstDay = 1;
    int lastDay = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    startDate =
        '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${firstDay.toString().padLeft(2, '0')}';
    endDate =
        '${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${lastDay.toString().padLeft(2, '0')}';
  }

  void goToDirectory() async {
    await _mainService.shell.run('open .');
  }

  void _getRepositoryDirectory() {
    repositoryDirectory = _shared.getString('repositoryDirectory');
  }

  Future<void> _removeOutputDirectory() async {
    bool outputExists =
        await Directory('${_mainService.kupScriptPath}/output').exists();
    if (outputExists) {
      await _mainService.shell.run('rm -R output');
    }
  }

  Future<void> _watchOutputDirectory() async {
    Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      String path = '${_mainService.kupScriptPath}/output';
      if (Directory(path).existsSync() &&
          Directory(path).listSync().length != 0) {
        await _mainService.shell.run('open ./output');
        timer.cancel();
      }
    });
  }

  Future<void> _generateKupReport() async {
    await _mainService.shell.run('''
      #!/bin/bash
      #./cleanup.sh
      ./collectGitChangesList.sh "$repositoryDirectory" "$startDate" "$endDate"
      ./sortGitChangesList.sh
      ./aggregateGitChanges.sh
      ./generateKUPreportData.sh
      ./outputToPdf.sh "$startDate" "$endDate"
    ''');
  }
}
