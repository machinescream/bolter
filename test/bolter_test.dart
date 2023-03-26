import 'dart:async';
import 'package:bolter/src/bolter.dart';
import 'package:test/test.dart';

void main() {
  group('Bolter', () {
    late Bolter bolter;

    setUp(() {
      bolter = Bolter();
    });

    test('should add listener and notify it on shake', () {
      int count = 0;
      final getter = () => count;
      final listener = () => count++;

      bolter.listen(getter, listener);
      bolter.shake();

      expect(count, 1);
    });

    test('should remove listener on stopListen', () {
      int count = 0;
      final getter = () => count;
      final listener = () => count++;

      bolter.listen(getter, listener);
      bolter.stopListen(listener);
      bolter.shake();

      expect(count, 0);
    });

    test('should clear all listeners on clear', () {
      int count1 = 0;
      int count2 = 0;
      final getter1 = () => count1;
      final getter2 = () => count2;
      final listener1 = () => count1++;
      final listener2 = () => count2++;

      bolter.listen(getter1, listener1);
      bolter.listen(getter2, listener2);
      bolter.clear();
      bolter.shake();

      expect(count1, 0);
      expect(count2, 0);
    });

    test('should run action and update on runAndUpdate', () async {
      int count = 0;
      final getter = () => count;
      final listener = () => count++;
      final action = () async => await Future.delayed(Duration(milliseconds: 100), () => count++);

      bolter.listen(getter, listener);
      await bolter.runAndUpdate(action: action);

      expect(count, 2);
    });
  });
}

