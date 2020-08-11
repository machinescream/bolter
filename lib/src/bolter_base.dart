import 'dart:async';

import 'package:equatable/equatable.dart';

typedef Mapper<V, S> = V Function(S state);

class Bolter<S extends Equatable> {
  final S state;

  Bolter(this.state);

  final _bolter = StreamController<S>.broadcast();

  ValueStream<V> stream<V>(Mapper<V, S> mapper) => ValueStream(
        _Hole(_bolter.stream.map((event) => mapper(state))).stream, mapper(state));

  void shake() => _bolter.sink.add(state);
}

class _Hole<V> {
  int lastKnownHashcode;
  final Stream<V> _stream;

  _Hole(this._stream);

  Stream<V> get stream => _stream.map((event) {
    final newHashCode = _ComparableWrapper(event).hashCode;
    if (newHashCode == lastKnownHashcode) {
      return null;
    }
    lastKnownHashcode = newHashCode;
    return event;
  }).where((event) => event != null);
}

class _ComparableWrapper<V> extends Equatable {
  final V _value;

  const _ComparableWrapper(this._value);

  @override
  List<Object> get props => [_value];
}

class ValueStream<T> implements Stream<T> {
  final Stream<T> stream;
  T _lastVal;

  ValueStream(this.stream, this._lastVal) {
    stream.map((T val) => _lastVal = val);
  }

  T get value => _lastVal;

  @override
  Future<bool> any(bool Function(T element) test) => stream.any(test);

  @override
  ValueStream<T> asBroadcastStream(
      {void Function(StreamSubscription<T> subscription) onListen,
        void Function(StreamSubscription<T> subscription) onCancel}) =>
      ValueStream(stream.asBroadcastStream(onListen: onListen, onCancel: onCancel), value);

  @override
  ValueStream<E> asyncExpand<E>(Stream<E> Function(T event) convert) =>
      ValueStream<E>(stream.asyncExpand(convert), value as E);

  @override
  ValueStream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) =>
      ValueStream(stream.asyncMap(convert), convert(value));

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
  ValueStream<T> handleError(Function onError, {bool Function(Error error) test}) =>
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
  ValueStream<T> timeout(Duration timeLimit, {void Function(EventSink<T> sink) onTimeout}) =>
      ValueStream(stream.timeout(timeLimit, onTimeout: onTimeout), value);

  @override
  ValueStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      ValueStream(stream.transform(streamTransformer), value as S);

  @override
  ValueStream<T> where(bool Function(T event) test) => ValueStream(stream.where(test), value);

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
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine) =>
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
  Future<T> reduce(T Function(T previous, T element) combine) => stream.reduce(combine);

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
      stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
