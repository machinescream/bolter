import 'dart:async';
import 'package:flutter/material.dart';
import 'bolter_core.dart';

part 'presenter/presenter.dart';
part 'presenter/presenter_provider.dart';
part 'bolter_builder.dart';

class BolterProvider extends InheritedWidget {
  final BolterInterface _bolter;

  const BolterProvider(
    this._bolter, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

extension BolterExtension on BuildContext {
  BolterInterface get bolter =>
      dependOnInheritedWidgetOfExactType<BolterProvider>()?._bolter ??
      defaultBolter;
}
