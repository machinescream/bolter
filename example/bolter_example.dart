import 'package:bolter/bolter.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class State extends Equatable {
  var value = 0;

  @override
  List<Object> get props => [value];
}

void main() {
  final bolter = Bolter(State());
  bolter.stream((state) => state.value).stream.listen((event) {
    print(event);
  });
  bolter.state.value++;
  bolter.shake();
  bolter.state.value++;
  bolter.shake();
}
