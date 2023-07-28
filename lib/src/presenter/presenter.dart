part of bolter;

/// [Presenter] is an abstract class that provides a base for implementing custom presenter classes.
/// It includes methods for managing state, performing actions, and handling the lifecycle of the presenter.
abstract class Presenter<P extends Presenter<P>> {
  late final itSelf = this as P;

  late final _bolter = _context.bolter;
  late BuildContext _context;

  var _disposed = false;
  var _processingState = <Function, bool>{};

  /// Returns the current [BuildContext] for the presenter.
  BuildContext get context => _context;
  bool get disposed => _disposed;

  bool processing(Function methodSignature) {
    final processing = _processingState[methodSignature];
    return processing ?? false;
  }

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
    void Function(T result)? onResult,
    void Function(Object e)? onError,
    void Function()? afterAction,
    Function? methodSignature,
  }) async {
    if (beforeAction != null) {
      _runAndShakeIfNotDisposed(beforeAction);
    }
    if (action == null) return;
    _runAndShakeIfNotDisposed(
      () => _setProcessingState(methodSignature, true),
    );
    try {
      late T result;
      if (action is Future<T> Function()) {
        result = await action();
      } else if (action is T Function()) {
        result = action();
      }
      if (onResult != null) {
        _runAndShakeIfNotDisposed(() => onResult(result));
      }
    } catch (e) {
      if (onError == null) throw e;
      _runAndShakeIfNotDisposed(() => onError(e));
    }
    _runAndShakeIfNotDisposed(
      () => _setProcessingState(methodSignature, false),
    );
    if (afterAction != null) {
      _runAndShakeIfNotDisposed(afterAction);
    }
  }

  void _setProcessingState(Function? methodSignature, bool value) {
    if (methodSignature != null) {
      _processingState[methodSignature] = value;
    }
  }

  void _runAndShakeIfNotDisposed([Function? action]) {
    if (_disposed) return;
    action?.call();
    _bolter.shake();
  }
}
