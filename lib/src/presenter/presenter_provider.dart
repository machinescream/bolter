part of bolter;

class PresenterProvider<P extends Presenter<P>> extends InheritedWidget {
  final P presenter;

  PresenterProvider({
    super.key,
    required child,
    required this.presenter,
  }) : super(
          child: _PresenterProviderWidget(
            presenter: presenter,
            child: child,
          ),
        );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static P of<P extends Presenter<P>>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<PresenterProvider<P>>()!
        .presenter;
  }
}

class _PresenterProviderWidget<P extends Presenter<P>> extends StatefulWidget {
  final P presenter;
  final Widget child;

  const _PresenterProviderWidget({
    Key? key,
    required this.child,
    required this.presenter,
  }) : super(key: key);

  @override
  _PresenterProviderWidgetState<P> createState() =>
      _PresenterProviderWidgetState<P>();
}

class _PresenterProviderWidgetState<P extends Presenter<P>>
    extends State<_PresenterProviderWidget<P>> {
  late final P presenter = widget.presenter;

  @override
  void initState() {
    super.initState();
    _initializePresenter();
    presenter.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    presenter.dispose();
    super.dispose();
  }

  /// Initialize the presenter with its context and call the onLayout method at the end of the frame
  void _initializePresenter() {
    presenter._context = context;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          presenter.onLayout();
        }
      },
    );
  }
}

extension PresenterProviderExtension on BuildContext {
  P presenter<P extends Presenter<P>>() => PresenterProvider.of<P>(this);
}
