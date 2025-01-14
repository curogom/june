[![pub package](https://img.shields.io/pub/v/june.svg)](https://pub.dartlang.org/packages/june)



# June
[![Discord Server Invite](https://img.shields.io/badge/DISCORD-JOIN%20SERVER-5663F7?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/zXXHvAXCug)
[![Kakao_Talk](https://img.shields.io/badge/KakaoTalk-Join%20Room-FEE500?style=for-the-badge&logo=kakao)](https://open.kakao.com/o/gEwrffbg)

The main reason you need a state management library in Flutter is because managing state changes or sharing states from the outside is difficult with the native Flutter state management. However, many state management libraries deviate from their original purpose and end up containing much more code, attempting to control the app development pattern itself. We need a state management library that stays true to its original purpose without straying too far from the native Flutter state management.

June is a lightweight and modern state management library that focuses on providing a pattern very similar to Flutter's native state management.

## Features

- ✨ **Native Flutter State Pattern**: By adopting the native Flutter state management pattern, you can declare variables and manage them with setState, facilitating an easy transition to app-level scalability.
- 🦄 **No Widget Modification Required**: Use MaterialApp, StatelessWidget, and StatefulWidget as is, with no changes needed for enhanced state management.
- 🚀 **No State Initialization**: Simplifies Flutter app development by automatically setting up state management, eliminating manual initialization, and reducing boilerplate. This approach ensures a cleaner, more maintainable codebase and a quicker start to development.
- 🌐 **Compatibility with Various Architectures**: Maintains a simple and flexible usage, facilitating effortless integration with a wide range of architectural patterns. This approach ensures that developers can adapt it easily to their specific project requirements, promoting versatility and ease of use across diverse project scales.
## Usage
1. Declare the states.
```dart
class CounterVM extends JuneState {
  int count = 0;
}
```
2. The state management wraps the widget to be managed with JuneBuilder.(You can place it in multiple locations.)
```dart
JuneBuilder(
  () => CounterVM(),
  builder: (vm) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('${vm.count}'
      ),
    ],
  ),
)
```

3. Update the states using the setState method.
```dart
// You can call state from anywhere.
var state = June.getState(CounterVM());
state.count++;

state.setState();
```

4. That's All!



#### Example
```dart
import 'package:flutter/material.dart';
import 'package:june/june.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: JuneBuilder(
            () => CounterVM(),
            builder: (vm) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  '${vm.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: const FloatingActionButton(
          onPressed: incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

void incrementCounter() {
  // You can call state from anywhere.
  var state = June.getState(CounterVM());
  state.count++;

  state.setState();
}

class CounterVM extends JuneState {
  int count = 0;
}

```

or, you can include actions when declaring a State.
```dart
import 'package:flutter/material.dart';
import 'package:june/june.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: JuneBuilder(
                () => CounterVM(),
            builder: (vm) =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('You have pushed the button this many times:'),
                    Text(
                      '${vm.count}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                  ],
                ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // This way, you can call actions inside the model.
            June.getState(CounterVM()).incrementCounter();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class CounterVM extends JuneState {
  int count = 0;

  // You can also create actions inside the model.
  incrementCounter() {
    count++;
    setState();
  }
}
```

## Advance
### Object State Management
June offers the ability to create multiple instances of declared states as objects. This feature is extremely useful for managing different data in repetitive formats, such as feed content.

Simply add a tag to JuneBuilder and June.getState to utilize this functionality.

#### Example
```dart
import 'package:flutter/material.dart';
import 'package:june/june.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              JuneBuilder(
                    () => CounterVM(),
                builder: (vm) => Column(
                  children: [
                    const Text('Basic instance counter'),
                    Text(
                      '${vm.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              JuneBuilder(
                    () => CounterVM(),
                tag: "SomeId",
                builder: (vm) => Column(
                  children: [
                    const Text('Object instance counter created with tags'),
                    Text(
                      '${vm.count}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const Stack(
          children: <Widget>[
            Positioned(
                right: 0,
                bottom: 80,
                child: FloatingActionButton.extended(
                    onPressed: increaseBasicInstance, label: Text("Increase basic instance"))),
            Positioned(
                right: 0,
                bottom: 10,
                child: FloatingActionButton.extended(
                    onPressed: increaseObjectInstanceCreatedWithTags, label: Text("Increase object instance created with tags"))),
          ],
        ),
      ),
    );
  }
}

void increaseBasicInstance() {
  var state = June.getState(CounterVM());
  state.count++;
  state.setState();
}

void increaseObjectInstanceCreatedWithTags() {
  var state = June.getState(CounterVM(), tag: "SomeId");
  state.count++;
  state.setState();
}

class CounterVM extends JuneState {
  int count = 0;
}
```

## Acknowledgements

This project has been significantly inspired by the native state management system of Flutter, the Provider package, the GetX library, the Bloc pattern, and the state management approach in Svelte. Each of these tools and methodologies has provided substantial inspiration and direction in the development of our own state management solution. We sincerely express our gratitude to all the developers and contributors of Flutter's native state management, Provider, GetX, Bloc, and Svelte's state management. Their innovative approaches and dedication to open source have had a profound impact on shaping our library. We are deeply thankful for the insights, ideas, and principles shared by these communities, which have greatly enriched our project and the wider open source community.







