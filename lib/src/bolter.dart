import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

typedef Getter<V> = V Function();

class Bolter {
  final _bolter = StreamController<void>.broadcast();

  ValueStream<V> stream<V>(Getter<V> getter, {bool distinct = true}) =>
      ValueStream(_bolter.stream.map((_) => getter()), getter(), distinctValues: distinct);

  void shake() => _bolter.sink.add(null);

  bool get isDisposed => _bolter.isClosed;

  void dispose() => _bolter.close();
}

class ComparableWrapper<V> extends Equatable {
  final V _value;

  const ComparableWrapper(this._value);

  @override
  List<V> get props => [_value];
}

class ValueStream<T> implements Stream<T> {
  final Stream<T> _stream;
  final bool distinctValues;
  T _lastVal;
  int lastKnownHashcode = -1;

  ValueStream(this._stream, this._lastVal, {this.distinctValues = true});

  factory ValueStream.shrine(Iterable<Stream> streams, T Function() getter, {bool distinctValues = true}) {
    return ValueStream(const Stream.empty().mergeAll(streams).map((e) => getter()), getter(),
        distinctValues: distinctValues);
  }

  Stream<T> get stream => _stream.where((event) {
        final newHashCode = ComparableWrapper(event).hashCode;
        if ((newHashCode == lastKnownHashcode) && distinctValues) {
          return false;
        }
        lastKnownHashcode = newHashCode;
        _lastVal = event;
        return true;
      });

  T get value => _lastVal;

  @override
  Future<bool> any(bool Function(T element) test) => stream.any(test);

  @override
  ValueStream<T> asBroadcastStream(
          {void Function(StreamSubscription<T> subscription)? onListen,
          void Function(StreamSubscription<T> subscription)? onCancel}) =>
      this;

  @override
  Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert) => stream.asyncExpand(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert) => stream.asyncMap(convert);

  @override
  ValueStream<R> cast<R>() => ValueStream(stream.cast<R>(), value as R);

  @override
  Future<bool> contains(Object? needle) => stream.contains(needle);

  @override
  Future<E> drain<E>([E? futureValue]) => stream.drain(futureValue);

  @override
  ValueStream<T> distinct([bool Function(T previous, T next)? equals]) => ValueStream(stream.distinct(equals), value);

  @override
  ValueStream<T> handleError(Function onError, {bool Function(dynamic error)? test}) =>
      ValueStream(stream.handleError(onError, test: test), value);

  @override
  ValueStream<S> map<S>(S Function(T event) convert) => ValueStream(stream.map(convert), convert(value));

  @override
  ValueStream<T> skip(int count) => ValueStream(stream.skip(count), value);

  @override
  ValueStream<T> skipWhile(bool Function(T element) test) => ValueStream(stream.skipWhile(test), value);

  @override
  ValueStream<T> take(int count) => ValueStream(stream.take(count), value);

  @override
  ValueStream<T> takeWhile(bool Function(T element) test) => ValueStream(stream.takeWhile(test), value);

  @override
  ValueStream<T> timeout(Duration timeLimit, {void Function(EventSink<T> sink)? onTimeout}) =>
      ValueStream(stream.timeout(timeLimit, onTimeout: onTimeout), value);

  @override
  ValueStream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      ValueStream(stream.transform(streamTransformer), value as S);

  @override
  ValueStream<T> where(bool Function(T event) test) {
    return ValueStream(stream.where(test), value);
  }

  @override
  ValueStream<S> expand<S>(Iterable<S> Function(T element) convert) => ValueStream(stream.expand(convert), value as S);

  @override
  Future<T> elementAt(int index) => stream.elementAt(index);

  @override
  Future<bool> every(bool Function(T element) test) => stream.every(test);

  @override
  Future<T> get first => stream.first;

  @override
  Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse}) =>
      stream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine) => stream.fold(initialValue, combine);

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
  Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse}) => stream.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => stream.length;

  @override
  Future pipe(StreamConsumer<T> streamConsumer) => stream.pipe(streamConsumer);

  @override
  Future<T> reduce(T Function(T previous, T element) combine) => stream.reduce(combine);

  @override
  Future<T> get single => stream.single;

  @override
  Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse}) =>
      stream.singleWhere(test, orElse: orElse);

  @override
  Future<List<T>> toList() => stream.toList();

  @override
  Future<Set<T>> toSet() => stream.toSet();

  @override
  StreamSubscription<T> listen(void Function(T event)? onData,
          {Function? onError, void Function()? onDone, bool? cancelOnError}) =>
      stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
