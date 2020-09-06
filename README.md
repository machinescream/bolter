Simplest mutable state manager.

## Usage

A simple usage example:

```dart
import 'package:bolter/bolter.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class State extends Equatable {
  var _value = 0;
  int get value => _value;
  
  void incr() => _value++;

  @override
  List<Object> get props => [value];
}

void main() {
  final bolter = Bolter(State());
  bolter.stream((state) => state.value).listen((event) {
    print(event);
  });
  bolter.state.incr();
  bolter.shake();
  bolter.state.incr();
  bolter.shake();
}
```
