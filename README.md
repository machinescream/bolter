Simplest mutable state manager.

![GitHub Logo](bolter.png)


## Usage

A simple usage example:

```dart
import 'package:bolter/bolter.dart';

abstract class IState {
  IUser get user;
}

class State implements IState {
  @override
  final User user;

  State(this.user);
}

abstract class IUser {
  int get id;
}

class User with EquatableMixin implements IUser {
  @override
  int id;

  User(this.id);

  @override
  List<Object> get props => [id];
}

void main() {
  // domain layer:
  final b = Bolter(State(User(1)));
  b.state.user.id = 2;
  // presentation
  final presenter = Presenter(b);
  presenter.bolter.stream((state) {
    return state.user.id;
  }).listen((event) {
    print('new id is: $event');
  });
  b.shake();
}

class Presenter {
  final Bolter<IState> bolter;
  Presenter(this.bolter);
}
```
