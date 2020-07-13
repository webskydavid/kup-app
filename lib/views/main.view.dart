import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:kup_app/services/generator.service.dart';
import 'package:kup_app/widgets/title.widget.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MainView extends StatelessWidget {
  MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                _buildSelectRepositoryButton(),
                SizedBox(
                  height: 12.0,
                ),
                GenerateCSVWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row _buildSelectRepositoryButton() {
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
                filterTags: ['test'],
              );
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
        WhenRebuilderOr<GeneratorService>(
          tag: 'test',
          observe: () => RM.get<GeneratorService>(),
          onWaiting: () => Text('foweijhfewjfoejfoej'),
          onIdle: () => Text('Idle'),
          onError: (error) => Text('Error'),
          builder: (context, ReactiveModel<GeneratorService> model) =>
              Expanded(child: Text(model.state.repositoryDirectory)),
        ),
      ],
    );
  }
}

class GenerateCSVWidget extends StatelessWidget {
  GenerateCSVWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateRangeFormWidget();
  }
}

class DateRangeFormWidget extends StatefulWidget {
  const DateRangeFormWidget({
    Key key,
  }) : super(key: key);

  @override
  _DateRangeFormWidgetState createState() => _DateRangeFormWidgetState();
}

class _DateRangeFormWidgetState extends State<DateRangeFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _validate(value) {
    if (value == '') {
      return 'Empty field!';
    }
    if (DateTime.tryParse(value) == null) {
      return "Wrong date format!";
    }
  }

  @override
  Widget build(BuildContext context) {
    ReactiveModel<GeneratorService> generatorService =
        RM.get<GeneratorService>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: generatorService.state.startDate,
                  validator: (value) => _validate(value),
                  decoration: InputDecoration(
                    labelText: 'Start date',
                  ),
                  onSaved: (newValue) {
                    generatorService.setState((s) => s.setStartDate = newValue);
                  },
                ),
              ),
              SizedBox(
                width: 30.0,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: generatorService.state.endDate,
                  validator: (value) => _validate(value),
                  decoration: InputDecoration(
                    labelText: 'End date',
                  ),
                  onSaved: (newValue) {
                    generatorService.setState((s) => s.setEndDate = newValue);
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          OutlineButton(
            borderSide: BorderSide(
              color: Colors.green[400],
            ),
            hoverColor: Colors.green[50],
            textColor: Colors.green[500],
            padding: EdgeInsets.all(20),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                generatorService.setState((s) => s.run(), filterTags: ['run']);
              }
            },
            child: Text('Run script!'),
          ),
        ],
      ),
    );
  }
}
