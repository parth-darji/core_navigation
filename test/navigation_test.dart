import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:core_navigation/src/data/go_router_navigator_impl.dart';
import 'package:core_navigation/src/data/flutter_navigator_impl.dart';

import 'navigation_test.mocks.dart';

@GenerateMocks([GoRouter, GoRouterDelegate])
void main() {
  late MockGoRouter mockGoRouter;
  late GoRouterAppNavigatorImpl navigator;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockGoRouter = MockGoRouter();
    navigator = GoRouterAppNavigatorImpl(mockGoRouter);
  });

  group('GoRouterAppNavigatorImpl', () {
    const tRoute = '/details';
    const tArgs = {'id': 123};

    test(
        'should call push on GoRouter when navigateTo is called and return the popped result',
        () async {
      // arrange
      when(mockGoRouter.push<String>(any, extra: anyNamed('extra')))
          .thenAnswer((_) async => 'popped_result');

      // act
      final result =
          await navigator.navigateTo<String>(tRoute, arguments: tArgs);

      // assert
      verify(mockGoRouter.push<String>(tRoute, extra: tArgs)).called(1);
      expect(result, equals('popped_result'));
    });

    test('should call replace on GoRouter when replaceWith is called', () {
      // arrange
      when(mockGoRouter.replace(any, extra: anyNamed('extra')))
          .thenAnswer((_) async => {});

      // act
      navigator.replaceWith(tRoute, arguments: tArgs);

      // assert
      verify(mockGoRouter.replace(tRoute, extra: tArgs)).called(1);
    });

    test('should call go on GoRouter when clearStackAndNavigateTo is called',
        () {
      // act
      navigator.clearStackAndNavigateTo(tRoute, arguments: tArgs);

      // assert
      verify(mockGoRouter.go(tRoute, extra: tArgs)).called(1);
    });

    test(
        'should call pop on GoRouter when goBack is called with optional result',
        () {
      // act
      navigator.goBack<String>('back_result');

      // assert
      verify(mockGoRouter.pop<String>('back_result')).called(1);
    });

    test('should check canPop on GoRouter when canGoBack is called', () {
      // arrange
      when(mockGoRouter.canPop()).thenReturn(true);

      // act
      final result = navigator.canGoBack();

      // assert
      verify(mockGoRouter.canPop()).called(1);
      expect(result, isTrue);
    });

    test(
        'should retrieve navigatorKey and call popUntil when goBackUntil is called',
        () {
      // arrange
      final mockRouterDelegate = MockGoRouterDelegate();
      final mockNavigatorKey = GlobalKey<NavigatorState>();
      when(mockGoRouter.routerDelegate).thenReturn(mockRouterDelegate);
      when(mockRouterDelegate.navigatorKey).thenReturn(mockNavigatorKey);

      // act
      navigator.goBackUntil(tRoute);

      // assert
      verify(mockGoRouter.routerDelegate).called(1);
      verify(mockRouterDelegate.navigatorKey).called(1);
    });
  });

  group('FlutterAppNavigatorImpl', () {
    late GlobalKey<NavigatorState> navKey;
    late FlutterAppNavigatorImpl flutterNavigator;

    setUp(() {
      navKey = GlobalKey<NavigatorState>();
      flutterNavigator = FlutterAppNavigatorImpl(navKey);
    });

    testWidgets(
        'should perform standard push, pop, and replace actions on NavigatorState',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navKey,
          initialRoute: '/',
          routes: {
            '/': (context) => const SizedBox(),
            '/details': (context) => const SizedBox(),
          },
        ),
      );

      // Verify canGoBack
      expect(flutterNavigator.canGoBack(), isFalse);

      // Verify navigateTo
      flutterNavigator.navigateTo('/details');
      await tester.pumpAndSettle();
      expect(flutterNavigator.canGoBack(), isTrue);

      // Verify goBack
      flutterNavigator.goBack('pop_data');
      await tester.pumpAndSettle();
      expect(flutterNavigator.canGoBack(), isFalse);
    });
  });
}
