import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:kup_app/services/services.dart';

class SelectRepositoryDirectory extends StatelessWidget {
  const SelectRepositoryDirectory({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ścieżka do repozytoriów:',
          style: TextStyle(color: Colors.grey),
        ),
        Row(
          children: [
            OutlineButton.icon(
              borderSide: BorderSide(color: Colors.blue[400]),
              hoverColor: Colors.blue[50],
              textColor: Colors.blue[700],
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              onPressed: () async {
                var paths = await fc.showOpenPanel(
                  canSelectDirectories: true,
                  allowsMultipleSelection: false,
                );
                if (!paths.canceled) {
                  RM.get<GeneratorService>().setState(
                    (s) => s.setRepositoryDirectory(paths.paths[0]),
                    filterTags: ['select_repo'],
                  );
                }
              },
              icon: Icon(Icons.folder_open),
              label: Text(
                'Wybierz folder',
                style: TextStyle(fontSize: 10.0),
              ),
            ),
            SizedBox(width: 10.0),
            WhenRebuilderOr<GeneratorService>(
              tag: 'select_repo',
              observe: () => RM.get<GeneratorService>(),
              onWaiting: () => Expanded(child: LinearProgressIndicator()),
              builder: (context, ReactiveModel<GeneratorService> model) =>
                  Expanded(child: Text(model.state.repositoryDirectory)),
            ),
          ],
        ),
      ],
    );
  }
}
