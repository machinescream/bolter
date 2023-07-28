# Introducing Bolter State Manager 🚀

Welcome to **Bolter**, a **robust**, **easy-to-use**, and **memory-efficient** state management solution for Flutter. Bolter's **zero-boilerplate** approach empowers you to build high-performance applications with clean, maintainable code. Bolter streamlines your app's UI updates, making them global yet precisely targeted, and eliminating manual presenter transitions.

## 🌟 Features

- 🚀 **Superior Performance**: Bolter ensures your app runs smoothly and efficiently, delivering outstanding performance.
- 💡 **Zero Boilerplate**: With Bolter, you manage your app's state with minimal code, reducing complexity and accelerating development time.
- 🎁 **Method Signature State Tracking**: Pass method signatures to track their execution state. This feature reduces boilerplate, enhances readability and allows to manage the asynchronous state of your application.
- 🧠 **Memory and Computation Efficiency**: Bolter uses hashcode calculations instead of copy and object comparisons, enhancing efficiency and minimizing unnecessary widget rebuilds.
- 🔄 **Automatic and Precise UI Updates**: Bolter simplifies UI updates, making them globally available and pinpointing updates where necessary. No more manual transitions!
- 💎 **Simplicity**: Bolter is intuitive to understand and straightforward to integrate, simplifying your state management tasks.
- 🎯 **Scoped State**: With Bolter, manage state for specific parts of your app, enabling precise control over updates and rendering. Bolter updates only the relevant parts of the widget tree, avoiding unnecessary rebuilds.
- 🔧 **Flexible**: Bolter is compatible with various app architectures, providing the flexibility to choose the approach that suits your needs best.

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
    perform(
      action: () => _counter++,
      methodSignature: incrementCounter,
    );
  }
}
```

4. Inject your presenter classes using `PresenterProvider`:

```dart
PresenterProvider<CounterPresenter>(
  presenter: () => CounterPresenter(),
  child: MyHomePage(),
)
```

5. Access the presenter and manage state within your widgets using the extension method:

```dart
final presenter = context.presenter<CounterPresenter>();
```

6. Use `BolterBuilder` to rebuild widgets in response to state changes and manage the asynchronous state of methods. For instance, you can use it to disable a button while a method is being executed:

```dart
BolterBuilder<bool>(
  getter: () => presenter.processing(presenter.incrementCounter),
  builder: (context, isProcessing) => RaisedButton(
    onPressed: isProcessing ? null : presenter.incrementCounter,
    child: Text(isProcessing ? 'Processing...' : 'Increment'),
  ),
)
```

With these simple steps, Bolter is primed to efficiently manage your app's state, offering automatic, globally available, yet precise UI updates. 

## 🚀 Performance Demo
![ezgif-2-578482560a.webp](https://drive.google.com/uc?id=1KeoVrDXl_TiZR1Te_26DsInDzgIfdD6p)

## 📈 Elevate Your App's Performance Today!

Embrace the simplicity and efficiency of Bolter. With **zero boilerplate**, **memory efficiency**, **automatic, precise UI updates**, and **method signature state tracking**, Bolter is the heart of modern Flutter applications. Start using Bolter now and experience the difference!

For any questions, suggestions, or feedback, please feel free to reach out to us on GitHub. Happy coding!