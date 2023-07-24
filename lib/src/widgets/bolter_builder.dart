part of bolter;

class _BolterBuilderElement<T> extends StatelessElement {
  final T Function() getter;
  _BolterBuilderElement(super.widget, this.getter);

  late final _bolter = bolter;

  @override
  bool get debugDoingBuild => false;

  @override
  void deactivate() {
    _bolter.stopListen(_notification);
    super.deactivate();
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    _bolter.listen(getter, _notification);
  }

  void _notification() {
    markNeedsBuild();
  }
}

class BolterBuilder<T> extends StatelessWidget {
  final T Function() getter;
  final Widget Function(BuildContext context, T value) builder;

  const BolterBuilder({
    super.key,
    required this.getter,
    required this.builder,
  });

  @override
  StatelessElement createElement() {
    return _BolterBuilderElement(this, getter);
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, getter());
  }
}
