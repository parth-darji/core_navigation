import 'package:flutter/widgets.dart';
import 'package:core_navigation/src/domain/app_navigator.dart';

/// Concrete implementation of [AppNavigator] wrapping Flutter's native [NavigatorState].
class FlutterAppNavigatorImpl implements AppNavigator {
  final GlobalKey<NavigatorState> navigatorKey;

  FlutterAppNavigatorImpl(this.navigatorKey);

  NavigatorState? get _state => navigatorKey.currentState;

  @override
  Future<T?> navigateTo<T extends Object?>(String routeName,
      {Map<String, dynamic>? arguments}) {
    return _state!.pushNamed<T>(routeName, arguments: arguments);
  }

  @override
  void replaceWith(String routeName, {Map<String, dynamic>? arguments}) {
    _state!.pushReplacementNamed(routeName, arguments: arguments);
  }

  @override
  void clearStackAndNavigateTo(String routeName,
      {Map<String, dynamic>? arguments}) {
    _state!.pushNamedAndRemoveUntil(routeName, (route) => false,
        arguments: arguments);
  }

  @override
  void goBack<T extends Object?>([T? result]) {
    _state!.pop<T>(result);
  }

  @override
  void goBackUntil(String routeName) {
    _state!.popUntil(ModalRoute.withName(routeName));
  }

  @override
  bool canGoBack() {
    return _state?.canPop() ?? false;
  }
}
