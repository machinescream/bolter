# Introducing Bolter State Manager 🚀

Welcome to **Bolter**, a **powerful**, **simple**, and **memory-efficient** state management solution for Flutter. With Bolter's **zero-boilerplate** approach, you can craft high-performance applications that feature clean, maintainable code. What's more, you no longer need to manually manage the transition from one presenter to another - Bolter automatically handles state updates across your entire application!

## 🌟 Features

- 🚀 **High Performance**: Bolter ensures your app runs smoothly and efficiently, delivering exceptional performance.
- 💡 **Zero Boilerplate**: Manage your app's state with minimal code. Say goodbye to complexity and reduce your development time.
- 🧠 **Memory and Computation Efficiency**: Bolter employs hashcode calculations instead of copy and object comparisons, promoting efficiency and avoiding unnecessary widget rebuilds.
- 🔄 **Automatic Updates**: With Bolter, state transitions from one presenter to another are managed automatically across the entire app.
- 💎 **Simplicity**: Easy to understand and integrate, Bolter simplifies your state management tasks.
- 🎯 **Scoped State**: Manage state for specific sections of your app, gaining fine-grained control over updates and rendering. Bolter updates only the relevant parts of the widget tree, preventing unnecessary rebuilds.
- 🔧 **Flexible**: Bolter is compatible with various app architectures, allowing you to choose the approach that best suits your needs.

## 📚 Getting Started in Minutes

Embark on your Bolter journey with these simple steps:

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

With just a few lines of code, Bolter is ready to efficiently manage your app's state. Now you can enjoy automatic updates without the need for manually switching from one presenter to another!

## 🚀 Performance demo
![ezgif-2-578482560a.webp](https://drive.google.com/uc?id=1KeoVrDXl_TiZR1Te_26DsInDzgIfdD6p)

## 📈 Elevate Your App's Performance Today!

Why wait? Experience the simplicity and efficiency of Bolter and give your app the performance boost it deserves. With **zero boilerplate**, **memory efficiency**, and **automatic state updates**, Bolter is at the core of state-of-the-art Flutter applications. Start using Bolter now and witness the difference!

For any questions, suggestions, or feedback, please feel free to reach out to us on GitHub. Happy coding!