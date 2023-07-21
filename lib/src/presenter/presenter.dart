part of bolter;

/// [Presenter] is an abstract class that provides a base for implementing custom presenter classes.
/// It includes methods for managing state, performing actions, and handling the lifecycle of the presenter.
abstract class Presenter<P extends Presenter<P>> {
  late final itSelf = this as P;

  late final _bolter = _context.bolter;
  late BuildContext _context;

  /// Returns the current [BuildContext] for the presenter.
  BuildContext get context => _context;

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
  void dispose() {}

  /// Runs the given [action] and updates the state of the presenter.
  /// It can handle optional [beforeAction], [afterAction], and [onError] callbacks.
  /// Optionally, it can also provide an [exactNotification] callback to notify only a specific listener.
  ///
  /// Returns a [FutureOr] that completes when the action has been performed and the state has been updated.
  FutureOr<void> perform<T>({
    FutureOr<T> Function()? beforeAction,
    FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
  }) {
    return _bolter.perform(
      beforeAction: beforeAction,
      action: action,
      afterAction: afterAction,
      onError: onError,
    );
  }
}
