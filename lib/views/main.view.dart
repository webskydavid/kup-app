import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as fc;
import 'package:kup_app/views/models/generate.model.dart';
import 'package:kup_app/views/models/main.model.dart';
import 'package:kup_app/widgets/commit_list.widget.dart';
import 'package:kup_app/widgets/title.widget.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class MainView extends ViewModelWidget<MainViewModel> {
  const MainView({Key key}) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, MainViewModel model) {
    Logger().i(model.shell);
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
                GenerateCSVWidget(),
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
        Expanded(child: Text(model.repositoryDirectory))
      ],
    );
  }
}

class GenerateCSVWidget extends ViewModelWidget<MainViewModel> {
  GenerateCSVWidget({
    Key key,
  }) : super(key: key, reactive: true);

  @override
  Widget build(BuildContext context, MainViewModel mainViewModel) {
    Logger().i(context);
    return DateRangeFormWidget();
    // return ViewModelBuilder<GenerateModelView>.reactive(
    //   viewModelBuilder: () => GenerateModelView(),
    //   builder: (context, model, child) {
    //     return Column(
    //       children: [
    //         SizedBox(
    //           height: 50.0,
    //         ),
    //         DateRangeFormWidget(),
    //       ],
    //     );
    //   },
    // );
  }
}

class WrapperWidget extends StatelessWidget {
  const WrapperWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('fewfew');
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
      return 'Empty field';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GenerateModelView>.reactive(
      viewModelBuilder: () => GenerateModelView(),
      builder: (context, model, child) {
        Logger().w(model);
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: model.startDate,
                      validator: (value) => _validate(value),
                      //onChanged: (value) => model.setStartDate(value),
                      decoration: InputDecoration(
                        labelText: 'Start date',
                      ),
                      onSaved: (newValue) {
                        model.setStartDate = newValue;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: model.endDate,
                      validator: (value) => _validate(value),
                      //onChanged: (value) => model.setEndDate(value),
                      decoration: InputDecoration(
                        labelText: 'End date',
                      ),
                      onSaved: (newValue) {
                        model.setEndDate = newValue;
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
                    Logger().wtf(model.startDate);
                    model.run();
                  }
                },
                child: Text('Run script!'),
              ),
            ],
          ),
        );
      },
    );
  }
}
