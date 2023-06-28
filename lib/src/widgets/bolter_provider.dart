part of bolter;

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
