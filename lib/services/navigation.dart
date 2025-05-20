import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static NavigatorState? of() {
    return navigatorKey.currentState;
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Route<T> route, {
    TO? result,
  }) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return Future.value(null);
    return navigator.pushReplacement(route, result: result);
  }

  static Future<T?> pushAndRemoveUntil<T extends Object?>(
    Route<T> newRoute,
    RoutePredicate predicate,
  ) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return Future.value(null);
    return navigator.pushAndRemoveUntil(newRoute, predicate);
  }

  static Future<T?> push<T extends Object?>(Route<T> route) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return Future.value(null);
    return navigator.push(route);
  }

  static void pop<T extends Object?>([T? result]) {
    navigatorKey.currentState?.pop(result);
  }
}
