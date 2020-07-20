import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final Color color;
  TitleWidget({Key key, @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'KUP',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
        Text(
          'app',
          style: TextStyle(
            color: color,
            fontSize: 30.0,
            fontWeight: FontWeight.w100,
          ),
        ),
        Text(
          'ka',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 30.0,
          ),
        ),
      ],
    );
  }
}
