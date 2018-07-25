import 'package:flutter/material.dart';

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final flutterWebviewPlugin = new FlutterWebviewPlugin();

main() async {
  final server = new Jaguar();
  server.addApi(new FlutterAssetServer());
  await server.serve();

  server.log.onRecord.listen((r) => print(r));

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/second': (context) => SecondScreen()
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _showButton = true;

  @override
  Widget build(BuildContext context) {
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      RegExp regExp = new RegExp(r".*flutter.showButton");

      setState(() {
        _showButton = regExp.firstMatch(url) != null;
      });
    });

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: _showButton ? new FloatingActionButton(
        onPressed: () {
          flutterWebviewPlugin.launch('http://localhost:8080/', rect: new Rect.fromLTWH(
              0.0,
              0.0,
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height-100));
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ) : null,
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to the first screen by popping the current route
            // off the stack
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}