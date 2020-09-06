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
  await Future.delayed(Duration(seconds: 2));
  b.shake();
  b.state.l.add(2);
  await Future.delayed(Duration(seconds: 2));
  b.shake();
  b.state.l.add(3);
  await Future.delayed(Duration(seconds: 2));
  b.shake();
  b.state.l.removeLast();
  await Future.delayed(Duration(seconds: 2));
  b.shake();
  b.state.l.removeLast();
  await Future.delayed(Duration(seconds: 2));
  b.shake();
  b.state.l.removeLast();
  await Future.delayed(Duration(seconds: 2));
  b.shake();
}
