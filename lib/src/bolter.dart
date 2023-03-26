import 'dart:async';
import 'package:equatable/equatable.dart';

bool kProfileBolterPerformanceLogging = false;
BolterInterface defaultBolter = Bolter();

typedef BolterNotification = void Function();
typedef Getter<T> = T Function();

abstract class BolterInterface {
  void listen<T>(Getter<T> getter, BolterNotification notification);

  void shake();

  void stopListen(void Function() notification);

  void clear();

  FutureOr<void> runAndUpdate<T>({
    void Function()? beforeAction,
    required FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
    BolterNotification? exactNotification,
  });
}

class Bolter implements BolterInterface {
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
      _notifyAllListeners();
      print('All notifications took ${DateTime.now().millisecondsSinceEpoch - now} milliseconds');
      return;
    }
    _notifyAllListeners();
  }

  void _notifyListener(BolterNotification listener) {
    final newHashCode = ComparableWrapper(_listeners[listener]!.call()).hashCode;
    if (newHashCode != _hashCache[listener]) {
      listener();
      _hashCache[listener] = newHashCode;
    }
  }

  void _notifyAllListeners() {
    _listeners.forEach((listener, _) => _notifyListener(listener));
  }

  /// Runs an [action] and notifies the relevant listeners of any changes that occur
  @override
  FutureOr<void> runAndUpdate<T>({
    void Function()? beforeAction,
    required FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
    BolterNotification? exactNotification,
  }) {
    final shakeAction = exactNotification == null ? shake : () => _notifyListener(exactNotification);

    if (beforeAction != null) {
      beforeAction();
      shakeAction();
    }

    void error(Object e) {
      if (onError != null) {
        onError(e);
        shakeAction();
      } else {
        throw e;
      }
    }

    void after() {
      if (afterAction != null) {
        afterAction();
        shakeAction();
      }
    }

    if (action != null) {
      if (action is Future<T> Function()) {
        return action()
            .then(
              (_) => shakeAction(),
              onError: error,
            )
            .whenComplete(after);
      } else {
        try {
          action();
          shakeAction();
        } catch (e) {
          error(e);
        }
        after();
      }
    }
  }

  /// Removes a listener from the registered listeners.
  @override
  void stopListen(void Function() notification) {
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
}

class ComparableWrapper<V> extends Equatable {
  final V _value;

  const ComparableWrapper(this._value);

  @override
  List<V> get props => [_value];
}
