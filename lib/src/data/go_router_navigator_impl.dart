import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:core_navigation/src/domain/app_navigator.dart';

class GoRouterAppNavigatorImpl implements AppNavigator {
  final GoRouter _router;

  GoRouterAppNavigatorImpl(this._router);

  @override
  Future<T?> navigateTo<T extends Object?>(String routeName,
      {Map<String, dynamic>? arguments}) {
    return _router.push<T>(routeName, extra: arguments);
  }

  @override
  void replaceWith(String routeName, {Map<String, dynamic>? arguments}) {
    _router.replace(routeName, extra: arguments);
  }

  @override
  void clearStackAndNavigateTo(String routeName,
      {Map<String, dynamic>? arguments}) {
    _router.go(routeName, extra: arguments);
  }

  @override
  void goBack<T extends Object?>([T? result]) {
    _router.pop<T>(result);
  }

  @override
  void goBackUntil(String routeName) {
    _router.routerDelegate.navigatorKey.currentState?.popUntil(
      ModalRoute.withName(routeName),
    );
  }

  @override
  bool canGoBack() {
    return _router.canPop();
  }
}
