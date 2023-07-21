import 'dart:async';

import 'package:bolter/bolter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyPresenter extends Presenter<MyPresenter> {
  MyPresenter() {
    print('presenter created');
  }

  void incr() {
    perform(action: () => i++);
  }

  var i = 0;

  @override
  void init() {
    super.init();
    print('init');
  }

  @override
  FutureOr<void> onLayout() {
    print('onLayout');
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.height;
    print('parent builded');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PresenterProvider(
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
        presenter: () => MyPresenter(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final presenter = context.presenter<MyPresenter>();

  void _incrementCounter() {
    presenter.incr();
  }

  @override
  Widget build(BuildContext context) {
    return BolterBuilder<int>(
        getter: () => presenter.i,
        builder: (context, val) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$val',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        });
  }
}
