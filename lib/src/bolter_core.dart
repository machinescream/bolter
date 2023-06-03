import 'dart:async';
import 'package:equatable/equatable.dart';

bool kProfileBolterPerformanceLogging = false;
final defaultBolter = Bolter();

typedef BolterNotification = void Function();
typedef Getter<T> = T Function();

class Bolter {
  final _listeners = <BolterNotification, Getter>{};
  final _hashCache = <BolterNotification, int>{};

  /// Registers a [getter] and a [notification] to be notified when the result of calling the getter changes
  @override
  void listen<T>(Getter<T> getter, BolterNotification notification) {
    _listeners[notification] = getter;
    _hashCache[notification] = ComparableWrapper(getter()).hashCode;
  }

  /// Notifies all registered listeners of changes
  @override
  void shake() {
    if (kProfileBolterPerformanceLogging) {
      final now = DateTime.now().millisecondsSinceEpoch;
      _notifyListeners();
      print(
          'All notifications took ${DateTime.now().millisecondsSinceEpoch - now} milliseconds');
      return;
    }
    _notifyListeners();
  }

  /// Runs an [action] and notifies the relevant listeners of any changes that occur
  @override
  FutureOr<void> runAndUpdate<T>({
    void Function()? beforeAction,
    required FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
  }) {
    if (beforeAction != null) {
      beforeAction();
      shake();
    }

    void after() {
      if (afterAction != null) {
        afterAction();
        shake();
      }
    }

    if (action == null) return null;
    void handleError(Object e) {
      if (onError == null) throw e;
      onError(e);
      shake();
    }

    if (action is Future<T> Function()) {
      return action()
          .then((_) => shake(), onError: handleError)
          .whenComplete(after);
    } else {
      try {
        action();
        shake();
      } catch (e) {
        handleError(e);
      }
      after();
    }
  }

  /// Removes a listener from the registered listeners.
  @override
  void stopListen(BolterNotification notification) {
    final removedGetter = _listeners.remove(notification);
    final removedHash = _hashCache.remove(notification);
    if (removedGetter == null || removedHash == null) {
      throw Exception('no listener in listeners, or getter in cache');
    }
  }

  /// Clears all registered listeners.
  @override
  void clear() {
    _listeners.clear();
    _hashCache.clear();
  }

  void _notifyListeners() {
    _listeners.forEach((listener, _) {
      final hash = ComparableWrapper(_listeners[listener]!.call()).hashCode;
      if (hash != _hashCache[listener]) {
        listener();
        _hashCache[listener] = hash;
      }
    });
  }
}

class ComparableWrapper<V> extends Equatable {
  final V _value;

  const ComparableWrapper(this._value);

  @override
  List<V> get props => [_value];
}
