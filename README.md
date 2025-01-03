# NetworkChangeManager

`NetworkChangeManager` is a Dart utility designed to monitor and manage network connectivity changes in Flutter applications. It uses the [`connectivity_plus`](https://pub.dev/packages/connectivity_plus) package to detect network states and provides a clean interface for handling network changes effectively.

## Features

- **Check Initial Network State:** Quickly determine the network state when the app starts.
- **Listen for Network Changes:** Subscribe to connectivity changes and execute callbacks when the state changes.
- **Resource Cleanup:** Dispose of resources to avoid memory leaks.

## Installation

1. Add the `connectivity_plus` package to your project:

   ```yaml
   dependencies:
     connectivity_plus: ^x.x.x
   ```

2. Run the command to fetch the package:

   ```bash
   flutter pub get
   ```

## Usage

### Import the Package

```dart
import 'network_change_manager.dart';
```

### Check Initial Network State

Use `checkNetworkFirstTime` to determine the network state when the app starts:

```dart
final networkManager = NetworkChangeManager.instance;

void checkInitialState() async {
  final result = await networkManager.checkNetworkFirstTime();
  print(result == NetworkResult.on ? "Network is ON" : "Network is OFF");
}
```

### Listen for Network Changes

Use `handleNetworkChange` to subscribe to network state changes:

```dart
void listenForNetworkChanges() {
  networkManager.handleNetworkChange((result) {
    if (result == NetworkResult.on) {
      print("Network connected");
    } else {
      print("Network disconnected");
    }
  });
}
```

### Dispose Resources

When the listener is no longer needed, call the `dispose` method to clean up:

```dart
@override
void dispose() {
  networkManager.dispose();
  super.dispose();
}
```

## Classes and Methods

### `INetworkChangeManager`

An abstract class defining the interface for network management:

- `Future<NetworkResult> checkNetworkFirstTime()`
- `void handleNetworkChange(NetworkCallBack onChange)`
- `void dispose()`

### `NetworkChangeManager`

A concrete implementation of `INetworkChangeManager` with a singleton pattern for efficiency:

- `checkNetworkFirstTime`: Checks the current network state.
- `handleNetworkChange`: Listens for connectivity changes.
- `dispose`: Cancels subscriptions.

### `NetworkResult` (Enum)

Represents the possible network states:

- `on`: Network is connected.
- `off`: No network connection.

## Example

```dart
void main() {
  final networkManager = NetworkChangeManager.instance;

  networkManager.handleNetworkChange((result) {
    print(result == NetworkResult.on ? "Online" : "Offline");
  });

  networkManager.checkNetworkFirstTime().then((result) {
    print(result == NetworkResult.on ? "Initial: Online" : "Initial: Offline");
  });
}
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

