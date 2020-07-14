import 'package:flutter/material.dart';
import 'package:kup_app/services/generator.service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:file_chooser/file_chooser.dart' as fc;

class SelectRepositoryDirectory extends StatelessWidget {
  const SelectRepositoryDirectory({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlineButton.icon(
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
        SizedBox(
          width: 10.0,
        ),
        WhenRebuilderOr<GeneratorService>(
          tag: 'select_repo',
          observe: () => RM.get<GeneratorService>(),
          onWaiting: () => Expanded(child: LinearProgressIndicator()),
          onIdle: () => Text('Idle'),
          onError: (error) => Text('Error'),
          builder: (context, ReactiveModel<GeneratorService> model) =>
              Expanded(child: Text(model.state.repositoryDirectory)),
        ),
      ],
    );
  }
}
