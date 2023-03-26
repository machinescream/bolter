# Bolter

This repository a listener-notification mechanism for monitoring changes in values.

## Features

- Listen to changes in values by providing a `Getter` function and a `BolterNotification` function.
- Notify listeners only when the result of calling the `Getter` function has changed.
- Optionally notify listeners either globally or for a specific `BolterNotification` based on whether an `exactNotification` was provided.
## Usage

To use the `Bolter`, you need to create an instance of the `Bolter` class and call its methods as needed.
```dart
final bolter = Bolter();

bolter.listen(
() => myValue,
() => print('Value has changed!'),
);

bolter.shake();

bolter.runAndUpdate(
action: () => doSomething(),
afterAction: () => print('Action is complete!'),
);

bolter.stopListen(() => print('Value has changed!'));

bolter.clear();
```

## Performance

The performance of the `_SyncBolter` class is generally acceptable for a moderate number of listeners. The code caches the hash code of the result of calling the `Getter` functions, which helps to avoid unnecessary calls and improve performance. However, if the number of listeners becomes very large, or the `Getter` functions are expensive to compute, the performance may become an issue and additional optimizations may be necessary. The code includes a `kProfileBolterPerformanceLogging` flag, which can be used to log the time taken for notifying all listeners and assist with profiling the performance of the code.

## Contributing

Contributions are welcome! If you find a bug or have an idea for a new feature, please open an issue or submit a pull request.
