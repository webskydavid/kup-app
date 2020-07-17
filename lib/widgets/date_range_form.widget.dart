import 'package:flutter/material.dart';
import 'package:kup_app/services/generator.service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class DateRangeFormWidget extends StatefulWidget {
  const DateRangeFormWidget({
    Key key,
  }) : super(key: key);

  @override
  _DateRangeFormWidgetState createState() => _DateRangeFormWidgetState();
}

class _DateRangeFormWidgetState extends State<DateRangeFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ReactiveModel<GeneratorService> generatorService = RM.get<GeneratorService>();

  _validate(value) {
    if (value == '') {
      return 'Pole nie może być puste!';
    }
    if (DateTime.tryParse(value) == null) {
      return "Zły format daty!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          WhenRebuilderOr<GeneratorService>(
            observe: () => RM.get<GeneratorService>(),
            initState: (_, m) => m.setState((s) => s.currentDateRange()),
            builder: (context, model) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: model.state.startDate,
                      validator: (value) => _validate(value),
                      decoration: InputDecoration(
                        labelText: 'Data od',
                      ),
                      onSaved: (newValue) {
                        model.setState(
                          (s) => s.setStartDate = newValue,
                          filterTags: ['change_date'],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: model.state.endDate,
                      validator: (value) => _validate(value),
                      decoration: InputDecoration(
                        labelText: 'Data do',
                      ),
                      onSaved: (newValue) {
                        model.setState(
                          (s) => s.setEndDate = newValue,
                          filterTags: ['change_date'],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          WhenRebuilderOr<GeneratorService>(
            tag: 'generate',
            observe: () => RM.get<GeneratorService>(),
            onWaiting: () {
              return OutlineButton(
                borderSide: BorderSide(
                  color: Colors.grey[400],
                ),
                hoverColor: Colors.grey[50],
                textColor: Colors.grey[500],
                padding: EdgeInsets.all(20),
                onPressed: null,
                child: Text('Generowanie KUPY, poczekaj!'),
              );
            },
            builder: (context, model) {
              return OutlineButton(
                borderSide: BorderSide(
                  color: Colors.green[400],
                ),
                hoverColor: Colors.green[50],
                textColor: Colors.green[500],
                padding: EdgeInsets.all(20),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    generatorService.setState(
                      (s) => s.run(),
                      filterTags: ['generate'],
                    );
                  }
                },
                child: Text('Generuj KUP!'),
              );
            },
          ),
        ],
      ),
    );
  }
}
