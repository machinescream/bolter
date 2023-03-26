import 'package:bolter/bolter.dart';

Future<void> main() async {
  final k = K();
  defaultBolter.listen(() => k.v, () {
    print(k.v);
  });
  defaultBolter.runAndUpdate(
    action: () {
      return k.v = 20;
    },
  );
}

class K {
  int v = 0;
}
