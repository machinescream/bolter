part of bolter;

/// [Presenter] is an abstract class that provides a base for implementing custom presenter classes.
/// It includes methods for managing state, performing actions, and handling the lifecycle of the presenter.
abstract class Presenter<P extends Presenter<P>> {
  late final itSelf = this as P;

  late final _bolter = _context.bolter;
  late BuildContext _context;

  var _disposed = false;
  var _processing = false;

  /// Returns the current [BuildContext] for the presenter.
  BuildContext get context => _context;

  bool get disposed => _disposed;
  bool get processing => _processing;

  /// Called when the layout phase of the frame is complete.
  /// This method can be overridden to perform additional actions.
  @protected
  FutureOr<void> onLayout() {}

  /// Called when the presenter is first created.
  /// This method can be overridden to perform additional initialization.
  @protected
  void init() {}

  /// Called when the presenter is being disposed.
  /// This method should be overridden to release any resources held by the presenter.
  @protected
  @mustCallSuper
  void dispose() {
    _disposed = true;
  }

  /// Runs the given [action] and updates the state of the presenter.
  /// It can handle optional [beforeAction], [afterAction], and [onError] callbacks.
  /// Optionally, it can also provide an [exactNotification] callback to notify only a specific listener.
  ///
  /// Returns a [FutureOr] that completes when the action has been performed and the state has been updated.
  /// Runs an [action] and notifies the relevant listeners of any changes that occur
  FutureOr<void> perform<T>({
    void Function()? beforeAction,
    FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
  }) async {
    if (beforeAction != null) {
      _shakeAndRunIfNotDisposed(beforeAction);
    }
    if (action == null) return;
    _shakeAndRunIfNotDisposed(() => _processing = true);
    try {
      await action();
    } catch (e) {
      if (onError == null) throw e;
      if (!_disposed) onError(e);
    }
    _shakeAndRunIfNotDisposed(() => _processing = false);
    if (afterAction != null) {
      _shakeAndRunIfNotDisposed(afterAction);
    }
  }

  void _shakeAndRunIfNotDisposed([Function? action]) {
    if (_disposed) return;
    action?.call();
    _bolter.shake();
  }
}
