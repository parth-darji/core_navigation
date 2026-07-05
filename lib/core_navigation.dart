// Public API entry point of core_navigation package.

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'src/domain/app_navigator.dart';
import 'src/data/go_router_navigator_impl.dart';
import 'src/data/flutter_navigator_impl.dart';

export 'src/domain/app_navigator.dart';
export 'src/data/flutter_navigator_impl.dart';
export 'package:go_router/go_router.dart';

/// Factory class to construct the AppNavigator dependencies cleanly.
class CoreNavigationFactory {
  /// Creates a concrete implementation of [AppNavigator] wrapping [GoRouter].
  static AppNavigator create(GoRouter router) {
    return GoRouterAppNavigatorImpl(router);
  }

  /// Creates a concrete implementation of [AppNavigator] wrapping standard Flutter [NavigatorState].
  static AppNavigator native(GlobalKey<NavigatorState> navigatorKey) {
    return FlutterAppNavigatorImpl(navigatorKey);
  }
}
