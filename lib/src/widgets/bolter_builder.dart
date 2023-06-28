part of bolter;

class BolterBuilder<T> extends StatefulWidget {
  final T Function() getter;
  final Widget Function(BuildContext context, T value) builder;

  const BolterBuilder({
    super.key,
    required this.getter,
    required this.builder,
  });

  @override
  _BolterBuilderState<T> createState() => _BolterBuilderState<T>();
}

class _BolterBuilderState<T> extends State<BolterBuilder<T>> {
  late final _bolter = context.bolter;

  Getter get _getter => widget.getter;

  @override
  void initState() {
    super.initState();
    _bolter.listen(_getter, _notification);
  }

  @override
  void didUpdateWidget(BolterBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.getter != widget.getter) {
      _bolter.stopListen(_notification);
      _bolter.listen(_getter, _notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    final getter = _getter;
    return widget.builder(
      context,
      getter(),
    );
  }

  @override
  void dispose() {
    _bolter.stopListen(_notification);
    super.dispose();
  }

  void _notification() {
    setState(() {});
  }
}
