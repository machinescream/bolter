import 'package:bolter/bolter.dart';
import 'package:equatable/equatable.dart';

class State extends Equatable {
  var _value = 0;

  int get value => _value;

  set value(value) {
    _value = value;
  }

  @override
  List<Object> get props => [_value];
}

void main() {
  final bolter = Bolter(State());
  bolter.stream((state) => state.value).stream.listen((event) {
    print(event);
  });
  bolter.state.value = 1;
  bolter.shake();
  bolter.state.value = 2;
  bolter.shake();
}
