import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  Color color = Colors.white;
  TitleWidget({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tjfie(color: color),
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

class Tjfie extends StatelessWidget {
  const Tjfie({
    Key key,
    @required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'KUP',
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 30.0,
      ),
    );
  }
}
