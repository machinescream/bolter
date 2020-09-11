import 'dart:async';

import 'package:equatable/equatable.dart';

typedef Mapper<V, S> = V Function(S state);

class Bolter<S> {
  final S state;

  Bolter(this.state);

  final _bolter = StreamController<S>.broadcast();

  ValueStream<V> stream<V>(Mapper<V, S> mapper) =>
      ValueStream(_bolter.stream.map(mapper), mapper(state));

  void shake<V>({Mapper<V, S> change}) {
    change?.call(state);
    _bolter.sink.add(state);
  }

  void dispose() {
    _bolter.close();
  }
}

class ComparableWrapper<V> extends Equatable {
  final V _value;

  const ComparableWrapper(this._value);

  @override
  List<Object> get props => [_value];
}

class ValueStream<T> implements Stream<T> {
  final Stream<T> _stream;
  T _lastVal;
  Object _error;
  int lastKnownHashcode;

  ValueStream(this._stream, this._lastVal) {
    _stream.handleError((error) {
      _error = error;
    });
  }

  Stream<T> get stream => _stream.map((event) {
        final newHashCode = ComparableWrapper(event).hashCode;
        if (newHashCode == lastKnownHashcode) {
          return null;
        }
        lastKnownHashcode = newHashCode;
        _lastVal = event;
        return event;
      }).where((event) => event != null);

  T get value => _lastVal;

  Object get error => _error;

  @override
  Future<bool> any(bool Function(T element) test) => stream.any(test);

  @override
  ValueStream<T> asBroadcastStream(
          {void Function(StreamSubscription<T> subscription) onListen,
          void Function(StreamSubscription<T> subscription) onCancel}) =>
      this;

  @override
  Stream<E> asyncExpand<E>(Stream<E> Function(T event) convert) =>
      stream.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      stream.asyncMap(convert);

  @override
  ValueStream<R> cast<R>() => ValueStream(stream.cast<R>(), value as R);

  @override
  Future<bool> contains(Object needle) => stream.contains(needle);

  @override
  Future<E> drain<E>([E futureValue]) => stream.drain(futureValue);

  @override
  ValueStream<T> distinct([bool Function(T previous, T next) equals]) =>
      ValueStream(stream.distinct(equals), value);

  @override
  ValueStream<T> handleError(Function onError,
          {bool Function(Error error) test}) =>
      ValueStream(stream.handleError(onError, test: test), value);

  @override
  ValueStream<S> map<S>(S Function(T event) convert) =>
      ValueStream(stream.map(convert), convert(value));

  @override
  ValueStream<T> skip(int count) => ValueStream(stream.skip(count), value);

  @override
  ValueStream<T> skipWhile(bool Function(T element) test) =>
      ValueStream(stream.skipWhile(test), value);

  @override
  ValueStream<T> take(int count) => ValueStream(stream.take(count), value);

  @override
  ValueStream<T> takeWhile(bool Function(T element) test) =>
      ValueStream(stream.takeWhile(test), value);

  @override
  ValueStream<T> timeout(Duration timeLimit,
          {void Function(EventSink<T> sink) onTimeout}) =>
      ValueStream(stream.timeout(timeLimit, onTimeout: onTimeout), value);

  @override
  ValueStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      ValueStream(stream.transform(streamTransformer), value as S);

  @override
  ValueStream<T> where(bool Function(T event) test) =>
      ValueStream(stream.where(test), test(value) ? value : null);

  @override
  ValueStream<S> expand<S>(Iterable<S> Function(T element) convert) =>
      ValueStream(stream.expand(convert), value as S);

  @override
  Future<T> elementAt(int index) => stream.elementAt(index);

  @override
  Future<bool> every(bool Function(T element) test) => stream.every(test);

  @override
  Future<T> get first => stream.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function() orElse}) =>
      stream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(
          S initialValue, S Function(S previous, T element) combine) =>
      stream.fold(initialValue, combine);

  @override
  Future forEach(void Function(T element) action) => stream.forEach(action);

  @override
  bool get isBroadcast => stream.isBroadcast;

  @override
  Future<bool> get isEmpty => stream.isEmpty;

  @override
  Future<String> join([String separator = '']) => stream.join(separator);

  @override
  Future<T> get last => stream.last;

  @override
  Future<T> lastWhere(bool Function(T element) test, {T Function() orElse}) =>
      stream.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => stream.length;

  @override
  Future pipe(StreamConsumer<T> streamConsumer) => stream.pipe(streamConsumer);

  @override
  Future<T> reduce(T Function(T previous, T element) combine) =>
      stream.reduce(combine);

  @override
  Future<T> get single => stream.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function() orElse}) =>
      stream.singleWhere(test, orElse: orElse);

  @override
  Future<List<T>> toList() => stream.toList();

  @override
  Future<Set<T>> toSet() => stream.toSet();

  @override
  StreamSubscription<T> listen(void Function(T event) onData,
          {Function onError, void Function() onDone, bool cancelOnError}) =>
      stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
