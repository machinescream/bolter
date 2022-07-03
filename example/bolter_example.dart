import 'package:bolter/bolter.dart';

Future<void> main() async {
  final b = Bolter();
  var t = 5;
  b.stream(() => t).listen((event) {
    print(event);
  });
  for (var p = 0; p < 5; p++) {
    await Future.delayed(const Duration(seconds: 1));
    b.shake();
    t += 5;
  }

  final sb = defaultBolter;

  var st = 5;

  sb.listen(() => st, (){
    print("sync: $st");
  });

  for (var p = 0; p < 5; p++) {
    await Future.delayed(const Duration(seconds: 1));
    sb.shake();
    st += 5;
  }

}
