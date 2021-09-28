import 'package:bolter/bolter.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class User extends Equatable {
  String _name = "Victor";
  int _age = 7;
  double _icq = 0.2;
  final List<User> _friends = <User>[];

  String get name => _name;

  int get age => _age;

  double get icq => _icq;

  List<User> get friends => _friends;

  @override
  List<Object?> get props => [_name];
}

void main() {
  final bolter = Bolter();

  test("bolter tests", () async {
    final notifications = <Type, Object>{};
    final user = User();

    final nameSub = bolter.stream(() {
      return user.name;
    }).listen((event) {
      notifications[String] = event;
    });

    final ageSub = bolter.stream(() {
      return user.age;
    }).listen((event) {
      notifications[int] = event;
    });

    final icqSub = bolter.stream(() {
      return user.icq;
    }).listen((event) {
      notifications[double] = event;
    });

    final friendsSub = bolter.stream(() {
      return user.friends;
    }).listen((event) {
      notifications[List] = event;
    });

    // sync freeze for notifications waiting
    user._name = "Oleg";
    bolter.shake();
    user._age = 666;
    bolter.shake();
    user._icq = 3422.11;
    bolter.shake();
    user._friends.add(User().._name = "Kolya");
    bolter.shake();

    await Future.delayed(const Duration(milliseconds: 10));
    expect(notifications.length, 4);

    nameSub.cancel();
    ageSub.cancel();
    icqSub.cancel();
    friendsSub.cancel();
  });
}
