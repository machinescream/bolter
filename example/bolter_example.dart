import 'dart:async';

import 'package:bolter/bolter.dart';

void main() {
  int v = 0;
  defaultBolter.listen(() => v, () {
    print(v);
  });
  defaultBolter.runAndUpdate(action: () => v = 20);
}

final list = <int>[1, 2];
//race simulation
//websocket simulation
void raceSimulation() {
  Timer.periodic(Duration(milliseconds: 100), (timer) async {
    list.add(list.length);
  });
  Timer.periodic(Duration(milliseconds: 200), (timer) async {
    print(list.length);
    final lb = list.length;
    list.forEach((element) {
      // print(element);
    });
    await Future.delayed(Duration(milliseconds: 150));
    print(lb == list.length);
  });
}
