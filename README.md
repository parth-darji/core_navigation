# `core_navigation` Package

A decoupled, clean architecture navigation wrapper over `go_router`. It enables navigating from domain models, BLoCs, and repositories without passing `BuildContext` around, keeping the application core entirely independent of third-party routing packages.

---

## 1. Setup

### 1.1 Dependency Configuration
Add the package as a local path dependency in your main application's `pubspec.yaml`:

```yaml
dependencies:
  core_navigation:
    path: packages/core_navigation
```

### 1.2 Initialization & Dependency Injection
1. Initialize your router configuration inside the main application:
   ```dart
   final goRouter = GoRouter(
     initialLocation: '/',
     routes: [
       GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
       GoRoute(path: '/details', builder: (context, state) => const DetailsScreen()),
     ],
   );
   ```
2. Create the navigation singleton using the factory and register it inside your Service Locator (e.g. `get_it`):
   ```dart
   import 'package:core_navigation/core_navigation.dart';

   final getIt = GetIt.instance;

   void setupNavigation() {
     getIt.registerLazySingleton<AppNavigator>(
       () => CoreNavigationFactory.create(goRouter),
     );
   }
   ```
3. Attach the router to your app runner:
   ```dart
   CupertinoApp.router(
     routerConfig: goRouter,
   );
   ```

---

## 2. Usage Examples

Retrieve the navigation service via Dependency Injection:
```dart
final AppNavigator _navigator = GetIt.I<AppNavigator>();
```

### 2.1 Standard Push Navigation
```dart
_navigator.navigateTo('/details', arguments: {'id': '123'});
```

### 2.2 Push and Await Result
You can push a screen and asynchronously await a result when it is popped:
```dart
final String? selectedFilter = await _navigator.navigateTo<String>('/filters');
if (selectedFilter != null) {
  // Apply filter
}
```

### 2.3 Pop Screen
```dart
_navigator.goBack();
```

### 2.4 Pop with a Result
```dart
_navigator.goBack<String>('selected_filter_value');
```

### 2.5 Pop Until Route Name
Pops the navigation stack back until it reaches the specified route name:
```dart
_navigator.goBackUntil('/home');
```

### 2.6 Reset Stack (Authentication Transitions)
Clears the navigation stack and sets the new route as the root (e.g. redirecting to Login on token expiry):
```dart
_navigator.clearStackAndNavigateTo('/login');
```

### 2.7 Verify History Status
Checks if there are any routes to pop:
```dart
if (_navigator.canGoBack()) {
  _navigator.goBack();
}
```

---

## 3. Unit Testing (Mockito Mocking)

Because the navigation interface is fully abstract, you can easily mock it in your BLoC or ViewModel tests without needing Flutter engine binaries:

```dart
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core_navigation/core_navigation.dart';

@GenerateMocks([AppNavigator])
void main() {
  late MockAppNavigator mockNavigator;

  setUp(() {
    mockNavigator = MockAppNavigator();
  });

  test('should navigate to details when event is triggered', () {
    // act
    mockNavigator.navigateTo('/details');

    // assert
    verify(mockNavigator.navigateTo('/details')).called(1);
  });
}
```
