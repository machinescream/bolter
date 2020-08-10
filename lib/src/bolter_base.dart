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

class ValueStream<T> {
  final Stream<T> stream;
  T _lastVal;

  ValueStream(this.stream, this._lastVal) {
    stream.map((T val) => _lastVal = val);
  }

  T get value => _lastVal;
}
