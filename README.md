# Introducing Bolter State Manager 🚀

Discover **Bolter**, the **powerful**, **simple**, and **memory-efficient** state management solution for Flutter.
Bolter's **zero-boilerplate** approach empowers you to create high-performance applications with clean, maintainable code.

## 🌟 Features

- 🚀 **High Performance**: Designed for top-notch performance, Bolter ensures your app runs smoothly and efficiently.
- 💡 **Zero Boilerplate**: Manage your app's state with minimal code, reducing complexity and development time.
- 🧠 **Memory and Computation Efficiency**: Bolter leverages hashcode calculations instead of copy and object comparisons, making it highly efficient and preventing unnecessary widget rebuilds.
- 💎 **Simplicity**: Bolter is easy to understand and integrate into your existing Flutter projects, making state management a breeze.
- 🎯 **Scoped State**: Easily manage state for specific sections of your app, providing fine-grained control over updates and rendering. Bolter updates only the parts of the widget tree that need to be updated, preventing unnecessary rebuilds.
- 🔧 **Flexible**: Bolter works well with various app architectures, giving you the freedom to choose the best approach for your needs.

## 📚 Getting Started in Minutes

Jump into Bolter with these simple steps::

1. Add the `bolter` package to your `pubspec.yaml` file:

```yaml
dependencies:
  bolter:
```

2. Import the `bolter` package in your Dart files:

```dart
import 'package:bolter/bolter.dart';
```

3. Define your custom presenter classes that extend `Presenter`:
```dart
class CounterPresenter extends Presenter<CounterPresenter> {
  int _counter = 0;

  int get counter => _counter;

  void incrementCounter() {
    perform(action: () => _counter++);
  }
}
```

4. Inject your presenter classes using `PresenterProvider`:

```dart
PresenterProvider<CounterPresenter>(
  presenter: CounterPresenter(),
  child: MyHomePage(),
)
```

5. Access the presenter and manage state within your widgets using the extension method:

```dart
final presenter = context.presenter<CounterPresenter>();
```

6. Use `BolterBuilder` to rebuild widgets in response to state changes:

```dart
BolterBuilder<int>(
  getter: () => presenter.counter,
  builder: (context, counter) => Text(
    '$counter',
    style: Theme.of(context).textTheme.headline4,
  ),
)
```
And that's it! With just a few lines of code, you can now manage your app's state using Bolter's powerful and efficient state management system.

## 🚀 Performance demo
![ezgif-2-578482560a.webp](https://drive.google.com/uc?id=1KeoVrDXl_TiZR1Te_26DsInDzgIfdD6p)

## 📈 Elevate Your App's Performance Today!

Why wait? Experience the simplicity and efficiency of Bolter and give your app the performance boost it deserves,
with **zero boilerplate** and **memory efficiency** at its core. Start using Bolter now and witness the difference!

For any questions, suggestions, or feedback, please feel free to reach out to us on GitHub or Twitter. Happy coding! 🚀
