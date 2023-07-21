part of bolter;

class _PresenterProviderElement<P extends Presenter<P>> extends InheritedElement {
  final P presenter;
  _PresenterProviderElement(super.widget, this.presenter);

  @override
  void deactivate() {
    presenter.dispose();
    super.deactivate();
  }

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    presenter._context = this;
    presenter.init();
  }
}

class PresenterProvider<P extends Presenter<P>> extends InheritedWidget {
  final P Function() presenter;

  PresenterProvider({
    super.key,
    required child,
    required this.presenter,
  }) : super(child: child);

  @override
  InheritedElement createElement() {
    return _PresenterProviderElement(this, presenter());
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static P of<P extends Presenter<P>>(BuildContext context) {
    return (context
        .getElementForInheritedWidgetOfExactType<PresenterProvider<P>>()! as _PresenterProviderElement<P>).presenter;
  }
}

extension PresenterProviderExtension on BuildContext {
  P presenter<P extends Presenter<P>>() => PresenterProvider.of<P>(this);
}
