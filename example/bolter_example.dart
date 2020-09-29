import 'dart:collection';

import 'package:bolter/bolter.dart';

class State {
  final l = [];
}

abstract class IUser {
  int get id;
}

class User with EquatableMixin implements IUser {
  @override
  final int id;

  User(this.id);

  @override
  List<Object> get props => [id];
}

void main() async {
  final l1 = [User(1), User(2)];
  final l2 = [User(1), User(2), User(3)];

  final t1 = UnmodifiableListView<IUser>(l1);
  final t2 = UnmodifiableListView<IUser>(l2);
  print(ComparableWrapper(t1).hashCode);
  print(ComparableWrapper(t2).hashCode);

  final b = Bolter(State());
  b.stream((state) => state.l).map((event) => event.length > 2).listen((event) {
    print(event);
  });
  b.state.l.add(1);
  b.shake();
}
