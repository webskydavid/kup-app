import 'package:flutter/material.dart';
import 'package:kup_app/widgets/title.widget.dart';

class SplashscreenPage extends StatelessWidget {
  const SplashscreenPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ScriptDownloaderWidget(),
    );
  }
}

class ScriptDownloaderWidget extends StatelessWidget {
  const ScriptDownloaderWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            height: 200.0,
            width: 200.0,
            image: AssetImage('lib/icon/poop-512.png'),
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: [
              TitleWidget(color: Colors.brown[100]),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: 200.0,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: Colors.brown,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[400]),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
