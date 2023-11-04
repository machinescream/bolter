import 'package:bolter/bolter.dart';
import 'package:flutter/cupertino.dart';

mixin PresenterMixin<P extends Presenter<P>> on Widget{
  P presenter(BuildContext context) => PresenterProvider.of<P>(context);
}