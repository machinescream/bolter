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

  void incSync() {
    perform(
      action: () => i++,
      methodSignature: incSync,
    );
  }

  void incAsync() {
    perform(
      action: () async {
        await Future.delayed(const Duration(milliseconds: 1000));
        i++;
      },
      methodSignature: incAsync,
    );
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

  @override
  Widget build(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BolterBuilder<bool>(
                  getter: () => presenter.processing(presenter.incAsync),
                  builder: (_, val) => Text(val.toString()),
                ),
                BolterBuilder<int>(
                    getter: () => presenter.i,
                    builder: (context, val) {
                      return Text(
                        '$val',
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    }),
              ],
            ),
          ),
          floatingActionButton: BolterBuilder(
            getter: () => presenter.processing(presenter.incAsync),
            builder: (context, value) {
              return FloatingActionButton(
                onPressed: value ? null : presenter.incAsync,
                child: const Icon(Icons.add),
              );
            }
          ),
        );
  }
}
