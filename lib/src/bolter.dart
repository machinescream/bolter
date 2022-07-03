import 'dart:async';
import 'package:bolter/bolter.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

var kProfileBolterPerformanceLogging = false;
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
  final _gettersCache = <BolterNotification, Getter>{};
  final _hashCache = <BolterNotification, int>{};

  @override
  void listen<T>(Getter<T> getter, BolterNotification notification) {
    _listeners.add(notification);
    _gettersCache[notification] = getter;
    _hashCache[notification] = ComparableWrapper(getter()).hashCode;
    if (kProfileBolterPerformanceLogging) {
      print('After adding new listener');
      print('listeners count: ${_listeners.length}');
      print('gettersCache count: ${_gettersCache.length}');
      print('hashCache count: ${_hashCache.length}');
    }
  }

  @override
  void shake() {
    if (kProfileBolterPerformanceLogging) {
      final now = DateTime.now().millisecondsSinceEpoch;
      _shakeAll();
      print('All notifications took ${DateTime.now().millisecondsSinceEpoch - now} milliseconds');
    } else {
      _shakeAll();
    }
  }

  void _notify(BolterNotification listener) {
    final newHashCode = ComparableWrapper(_gettersCache[listener]!.call()).hashCode;
    if (newHashCode != _hashCache[listener]) {
      listener();
      _hashCache[listener] = newHashCode;
    }
  }

  void _shakeExactListener(BolterNotification listener, bool shakingAll) {
    if (!shakingAll && kProfileBolterPerformanceLogging) {
      final now = DateTime.now().millisecondsSinceEpoch;
      _notify(listener);
      print('Exact notification took ${DateTime.now().millisecondsSinceEpoch - now} '
          'milliseconds');
    } else {
      _notify(listener);
    }
  }

  void _shakeAll() {
    for (final listener in _listeners) {
      _shakeExactListener(listener, true);
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
    var shakeAction =
        exactNotification == null ? shake : () => _shakeExactListener(exactNotification, false);

    if (beforeAction != null) {
      beforeAction();
      shakeAction();
    }
    if (action != null) {
      try {
        final actionToCheck = action();
        if (actionToCheck is Future<T>) {
          return actionToCheck.then((_) {
            shakeAction();
          });
        } else {
          shakeAction();
        }
      } catch (e) {
        if (onError != null) {
          onError(e);
          shakeAction();
        }
        rethrow;
      }
    }
    if (afterAction != null) {
      afterAction();
      shakeAction();
    }
  }

  @override
  void stopListen(void Function() notification) {
    final status = _listeners.remove(notification);
    final removedGetter = _gettersCache.remove(notification);
    final removedHash = _hashCache.remove(notification);
    if (kProfileBolterPerformanceLogging) {
      print('After removing existing listener');
      print('listeners count: ${_listeners.length}');
      print('gettersCache count: ${_gettersCache.length}');
      print('_hashCache count: ${_hashCache.length}');
    }
    if (!status || removedGetter == null || removedHash == null) {
      throw Exception('no listener in listeners, or getter in cache');
    }
  }

  @override
  void clear() {
    if (kProfileBolterPerformanceLogging) {
      print('bolter cleared');
    }
    _listeners.clear();
    _gettersCache.clear();
    _hashCache.clear();
  }
}

@Deprecated('use defaultBolter instead')
class Bolter {
  final _bolter = StreamController<void>.broadcast();

  ValueStream<V> stream<V>(
    V Function() getter, {
    bool distinct = true,
  }) {
    return ValueStream(
      _bolter.stream.map(
        (_) {
          return getter();
        },
      ),
      getter,
      distinctValues: distinct,
    );
  }

  void shake() {
    _bolter.sink.add(null);
  }

  bool get isDisposed {
    return _bolter.isClosed;
  }

  void dispose() {
    _bolter.close();
  }
}

class ComparableWrapper<V> extends Equatable {
  final V _value;

  const ComparableWrapper(this._value);

  @override
  List<V> get props => [_value];
}

@Deprecated('listen by callback by passing addListener to defaultBolter')
class ValueStream<T> extends Stream<T> {
  final Stream<T> _stream;
  final bool distinctValues;
  T Function() _lastVal;
  int lastKnownHashcode = -1;

  ValueStream(
    this._stream,
    this._lastVal, {
    this.distinctValues = true,
  }) : lastKnownHashcode = ComparableWrapper(_lastVal()).hashCode;

  factory ValueStream.shrine(
    Iterable<Stream> streams,
    T Function() getter, {
    bool distinctValues = true,
  }) {
    return ValueStream(
      const Stream.empty().mergeAll(streams).map((e) => getter()),
      getter,
      distinctValues: distinctValues,
    );
  }

  Stream<T> get stream {
    return _stream.where(
      (event) {
        final newHashCode = ComparableWrapper(event).hashCode;
        if ((newHashCode == lastKnownHashcode) && distinctValues) {
          return false;
        }
        lastKnownHashcode = newHashCode;
        return true;
      },
    );
  }

  T get value {
    return _lastVal();
  }

  @override
  Future<bool> any(bool Function(T element) test) {
    return stream.any(test);
  }

  @override
  Stream<T> asBroadcastStream({
    void Function(StreamSubscription<T> subscription)? onListen,
    void Function(StreamSubscription<T> subscription)? onCancel,
  }) {
    return super.asBroadcastStream(
      onListen: onListen,
      onCancel: onCancel,
    );
  }

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert) {
    return stream.asyncExpand(convert);
  }

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) {
    return stream.asyncMap(convert);
  }

  @override
  ValueStream<R> cast<R>() {
    return ValueStream(
      stream.cast<R>(),
      _lastVal as R Function(),
    );
  }

  @override
  Future<bool> contains(Object? needle) {
    return stream.contains(needle);
  }

  @override
  Future<E> drain<E>([E? futureValue]) {
    return stream.drain(futureValue);
  }

  @override
  ValueStream<T> distinct([bool Function(T previous, T next)? equals]) {
    return ValueStream(
      stream.distinct(equals),
      _lastVal,
    );
  }

  @override
  ValueStream<T> handleError(Function onError, {bool Function(dynamic error)? test}) {
    return ValueStream(
      stream.handleError(onError, test: test),
      _lastVal,
    );
  }

  @override
  ValueStream<S> map<S>(S Function(T event) convert) {
    return ValueStream(stream.map(convert), () {
      return convert(_lastVal());
    });
  }

  @override
  ValueStream<T> skip(int count) {
    return ValueStream(stream.skip(count), _lastVal);
  }

  @override
  ValueStream<T> skipWhile(bool Function(T element) test) {
    return ValueStream(stream.skipWhile(test), _lastVal);
  }

  @override
  ValueStream<T> take(int count) {
    return ValueStream(stream.take(count), _lastVal);
  }

  @override
  ValueStream<T> takeWhile(bool Function(T element) test) {
    return ValueStream(stream.takeWhile(test), _lastVal);
  }

  @override
  ValueStream<T> timeout(Duration timeLimit, {void Function(EventSink<T> sink)? onTimeout}) {
    return ValueStream(stream.timeout(timeLimit, onTimeout: onTimeout), _lastVal);
  }

  @override
  ValueStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) {
    return ValueStream(stream.transform(streamTransformer), _lastVal as S Function());
  }

  @override
  ValueStream<T> where(bool Function(T event) test) {
    return ValueStream(stream.where(test), () => value);
  }

  @override
  ValueStream<S> expand<S>(Iterable<S> Function(T element) convert) {
    return ValueStream(stream.expand(convert), _lastVal as S Function());
  }

  @override
  Future<T> elementAt(int index) {
    return stream.elementAt(index);
  }

  @override
  Future<bool> every(bool Function(T element) test) {
    return stream.every(test);
  }

  @override
  Future<T> get first {
    return stream.first;
  }

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse}) {
    return stream.firstWhere(test, orElse: orElse);
  }

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine) {
    return stream.fold(initialValue, combine);
  }

  @override
  Future forEach(void Function(T element) action) {
    return stream.forEach(action);
  }

  @override
  bool get isBroadcast {
    return stream.isBroadcast;
  }

  @override
  Future<bool> get isEmpty {
    return stream.isEmpty;
  }

  @override
  Future<String> join([String separator = '']) {
    return stream.join(separator);
  }

  @override
  Future<T> get last {
    return stream.last;
  }

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse}) {
    return stream.lastWhere(test, orElse: orElse);
  }

  @override
  Future<int> get length {
    return stream.length;
  }

  @override
  Future pipe(StreamConsumer<T> streamConsumer) {
    return stream.pipe(streamConsumer);
  }

  @override
  Future<T> reduce(T Function(T previous, T element) combine) {
    return stream.reduce(combine);
  }

  @override
  Future<T> get single {
    return stream.single;
  }

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse}) {
    return stream.singleWhere(test, orElse: orElse);
  }

  @override
  Future<List<T>> toList() {
    return stream.toList();
  }

  @override
  Future<Set<T>> toSet() {
    return stream.toSet();
  }

  ValueStream<T> debounce(Duration duration) {
    return ValueStream(stream.debounce(duration), _lastVal);
  }

  @override
  StreamSubscription<T> listen(void Function(T event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
