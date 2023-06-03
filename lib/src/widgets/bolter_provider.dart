import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bolter/src/bolter_core.dart';

part '../presenter/presenter.dart';
part '../presenter/presenter_provider.dart';
part 'bolter_builder.dart';

class BolterProvider extends InheritedWidget {
  final Bolter _bolter;

  const BolterProvider(
    this._bolter, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

extension BolterExtension on BuildContext {
  Bolter get bolter =>
      dependOnInheritedWidgetOfExactType<BolterProvider>()?._bolter ??
      defaultBolter;
}
