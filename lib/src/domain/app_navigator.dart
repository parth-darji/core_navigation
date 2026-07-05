// Domain interface contract for application navigation.

abstract class AppNavigator {
  /// Navigates to a route and returns a Future that resolves when the route is popped.
  Future<T?> navigateTo<T extends Object?>(String routeName,
      {Map<String, dynamic>? arguments});

  /// Replaces the current route on the stack with the new one.
  void replaceWith(String routeName, {Map<String, dynamic>? arguments});

  /// Clears the entire navigation stack and navigates to the specified route.
  void clearStackAndNavigateTo(String routeName,
      {Map<String, dynamic>? arguments});

  /// Navigates back (pops) from the current route, optionally returning a result.
  void goBack<T extends Object?>([T? result]);

  /// Navigates back (pops) until the specified route name is reached.
  void goBackUntil(String routeName);

  /// Checks if the navigator can perform a pop operation.
  bool canGoBack();
}
