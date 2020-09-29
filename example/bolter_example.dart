import 'package:bolter/bolter.dart';

class State {
  final l = [];
}

void main() async {
  final b = Bolter(State());
  b.stream((state) => state.l).map((event) => event.length > 2).listen((event) {
    print(event);
  });
  b.state.l.add(1);
  b.shake();
}
