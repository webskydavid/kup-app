import 'package:flutter/material.dart';
import 'package:kup_app/views/models/generate.model.dart';
import 'package:stacked/stacked.dart';

class CommitListWidget extends ViewModelWidget<GenerateModelView> {
  CommitListWidget({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, GenerateModelView model) {
    List<List<dynamic>> list = model.commitList;
    return list.length > 0
        ? SingleChildScrollView(
            child: buildDataTable(list),
            scrollDirection: Axis.vertical,
          )
        : Text('Hir listen!');
  }

  DataTable buildDataTable(List<List> list) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Name',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Age',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'Role',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ],
      rows: List.generate(
        10,
        (i) => DataRow(
          cells: List.generate(
            6,
            (y) {
              print(list[i][y]);
              return DataCell(Text('fwefe'));
            },
          ),
        ),
      ),
    );
  }
}
