# Bolter - Dart State Management Solution

Bolter is an innovative state management library for Flutter, tailored for speed and efficiency. It leverages mutable variables alongside their hashcodes to intelligently determine when UI updates are necessary, ensuring a fast and responsive user experience.

## Features

- **Efficient State Management**: Bolter uses mutable variables and hashcode comparison to reduce unnecessary UI rebuilds, updating only when required.

- **State Listener Optimization**: Register state listeners with ease. Bolter ensures only relevant widgets are updated, minimizing performance overhead.

- **Lifecycle Management**: Bolter automatically manages listener lifecycle, attaching and detaching them in sync with widget lifecycle events.

- **Presenter Pattern Integration**: The library employs a presenter pattern, cleanly separating business logic from UI, resulting in more maintainable code.

- **Async Operation Handling**: Bolter's `perform` method seamlessly handles asynchronous operations, updating state and notifying listeners upon completion, while also managing loading states and errors.

- **Disposed State Check**: The `perform` method includes a check for the disposed state of the presenter, preventing state updates on widgets that are no longer in the widget tree, thus avoiding memory leaks and unnecessary operations.

- **Performance Logging**: For debugging, Bolter can log the performance of state updates, aiding in identifying bottlenecks.

- **Boilerplate Reduction**: By simplifying state management, Bolter allows developers to write more concise and readable code.

## Example Usage

```dart
class MyPresenter extends Presenter<MyPresenter> {
  int _counter = 0;

  int get counter => _counter;

  void incrementSync() {
    perform(action: () => _counter++);
  }

  void incrementAsync() {
    perform(
      action: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        _counter++;
      },
      methodSignature: incrementAsync, // Optional: use for identifying the method in processing checks.
    );
  }

  @override
  void dispose() {
    // Custom disposal logic can go here.
    super.dispose();
  }
}

class CounterWidget extends StatelessWidget with PresenterMixin<MyPresenter> {
  @override
  Widget build(BuildContext context) {
    final myPresenter = presenter(context);

    return Column(
      children: [
        BolterBuilder<int>(
          getter: () => myPresenter.counter,
          builder: (context, counter) => Text('Counter: $counter'),
        ),
        ElevatedButton(
          onPressed: myPresenter.incrementSync,
          child: Text('Increment Sync'),
        ),
        ElevatedButton(
          onPressed: () {
            if (!myPresenter.processing(myPresenter.incrementAsync)) {
              myPresenter.incrementAsync();
            }
          },
          child: Text('Increment Async'),
        ),
      ],
    );
  }
}
```

In this example, `MyPresenter` provides synchronous and asynchronous methods to increment a counter, demonstrating the use of the `perform` method. It also illustrates how to check if an async operation is currently processing before invoking it again.

## Getting Started

To use Bolter in your Flutter application, add it to your project as a dependency. Then, explore the documentation and examples to integrate Bolter into your app effectively.

## Contribution

We welcome contributions! If you've identified an improvement or want to contribute code, please submit an issue or a pull request.
