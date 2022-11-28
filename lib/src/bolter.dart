import 'dart:async';
import 'package:equatable/equatable.dart';

bool kProfileBolterPerformanceLogging = false;
BolterInterface defaultBolter = _SyncBolter();

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

class _SyncBolter implements BolterInterface {
  final _listeners = <BolterNotification>[];
  final _getters = <BolterNotification, Getter>{};
  final _hashCache = <BolterNotification, int>{};

  @override
  void listen<T>(Getter<T> getter, BolterNotification notification) {
    _listeners.add(notification);
    _getters[notification] = getter;
    _hashCache[notification] = ComparableWrapper(getter()).hashCode;
  }

  @override
  void shake() {
    if (kProfileBolterPerformanceLogging) {
      final now = DateTime.now().millisecondsSinceEpoch;
      _shakeAll();
      print('All notifications took ${DateTime.now().millisecondsSinceEpoch - now} milliseconds');
      return;
    }
    _shakeAll();
  }

  void _notify(BolterNotification listener) {
    final newHashCode = ComparableWrapper(_getters[listener]!.call()).hashCode;
    if (newHashCode != _hashCache[listener]) {
      listener();
      _hashCache[listener] = newHashCode;
    }
  }

  void _shakeAll() {
    for (final listener in _listeners) {
      _notify(listener);
    }
  }

  @override
  FutureOr<void> runAndUpdate<T>({
    void Function()? beforeAction,
    required FutureOr<T> Function()? action,
    void Function()? afterAction,
    void Function(Object e)? onError,
    BolterNotification? exactNotification,
  }) {
    final shakeAction = exactNotification == null ? shake : () => _notify(exactNotification);

    if (beforeAction != null) {
      beforeAction();
      shakeAction();
    }

    void error(Object e) {
      if (onError != null) {
        onError(e);
        shakeAction();
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

  @override
  void stopListen(void Function() notification) {
    final status = _listeners.remove(notification);
    final removedGetter = _getters.remove(notification);
    final removedHash = _hashCache.remove(notification);
    if (!status || removedGetter == null || removedHash == null) {
      throw Exception('no listener in listeners, or getter in cache');
    }
  }

  @override
  void clear() {
    _listeners.clear();
    _getters.clear();
    _hashCache.clear();
  }
}

class ComparableWrapper<V> extends Equatable {
  final V _value;

  const ComparableWrapper(this._value);

  @override
  List<V> get props => [_value];
}
