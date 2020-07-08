import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:kup_app/views/models/main.model.dart';
import 'package:kup_app/widgets/title.widget.dart';
import 'package:stacked/stacked.dart';

class MainView extends ViewModelWidget<MainViewModel> {
  const MainView({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, MainViewModel model) {
    print('workingDir ${model.workingDirectory}');
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleWidget(color: Colors.black),
            SizedBox(
              height: 15.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 12.0,
                ),
                Text(
                  'Repository path:',
                  style: TextStyle(color: Colors.grey),
                ),
                _buildSelectRepositoryButton(model),
                SizedBox(
                  height: 12.0,
                ),
                // StateBuilder<MainProvider>(
                //   observe: () => mainProvider,
                //   builder: (context, model) => OutlineButton.icon(
                //     textColor: Colors.green[700],
                //     padding:
                //         EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
                //     onPressed: model.state.repositoryDirectory != ''
                //         ? () async {}
                //         : null,
                //     icon: Icon(Icons.autorenew),
                //     label: Text('Generate list'),
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _buildSelectRepositoryButton(MainViewModel model) {
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
              model.setRepositoryDirectory(paths.paths[0]);
            }
          },
          icon: Icon(Icons.folder_open),
          label: Text(
            'Select folder',
            style: TextStyle(fontSize: 10.0),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(model.repositoryDirectory)
      ],
    );
  }
}
