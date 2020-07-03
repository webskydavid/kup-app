import 'package:flutter/material.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                'R',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'fewfe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TableRow(
            decoration: BoxDecoration(),
            children: [
              Text('fwfe'),
              Text('fewfe'),
            ],
          )
        ],
      ),
    );
  }
}
