import 'package:bolter/bolter.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

// ignore: must_be_immutable
class State extends Equatable {
  var value = 0;

  @override
  List<Object> get props => [value];
}

void main() {
  final bolter = Bolter(State());
  bolter
      .stream((state) => state.value)
      .debounce(Duration(seconds: 1))
      .listen((event) {
    print(event);
  });
  bolter.state.value++;
  bolter.shake();
  bolter.state.value++;
  bolter.shake();
}
