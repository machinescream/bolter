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
  void listen<T>(Getter<T> getter, BolterNotification notification) {
    _listeners[notification] = getter;
    _hashCache[notification] = ComparableWrapper(getter()).hashCode;
  }

  /// Notifies all registered listeners of changes
  void shake() {
    if (kProfileBolterPerformanceLogging) {
      final now = DateTime.now().millisecondsSinceEpoch;
      _notifyListeners();
      print(
        "All notifications took ${DateTime.now().millisecondsSinceEpoch - now} milliseconds",
      );
      return;
    }
    _notifyListeners();
  }

  /// Runs an [action] and notifies the relevant listeners of any changes that occur
  FutureOr<void> perform<T>({
    void Function()? beforeAction,
    FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
  }) async {
    if (beforeAction != null) {
      beforeAction();
      shake();
    }
    if (action == null) return null;
    try {
      await action();
      shake();
    } catch (e) {
      if (onError == null) throw e;
      onError(e);
      shake();
    }
    if (afterAction != null) {
      afterAction();
      shake();
    }
  }

  /// Removes a listener from the registered listeners.
  void stopListen(BolterNotification notification) {
    final removedGetter = _listeners.remove(notification);
    final removedHash = _hashCache.remove(notification);
    if (removedGetter == null || removedHash == null) {
      throw Exception('no listener in listeners, or getter in cache');
    }
  }

  /// Clears all registered listeners.
  void clear() {
    _listeners.clear();
    _hashCache.clear();
  }

  void _notifyListeners() {
    _listeners.forEach((listener, getter) {
      final hash = ComparableWrapper(getter()).hashCode;
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
