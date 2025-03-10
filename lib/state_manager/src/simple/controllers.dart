// ignore: prefer_mixin
import 'package:flutter/widgets.dart';

import '../../../instance/src/lifecycle.dart';
import '../../../june.dart';
import 'list_notifier.dart';

// ignore: prefer_mixin
abstract class JuneState extends ListNotifier with JuneLifeCycleMixin {
  /// Rebuilds `JuneBuilder` each time you call `update()`;
  /// Can take a List of [ids], that will only update the matching
  /// `JuneBuilder( id: )`,
  /// [ids] can be reused among `JuneBuilders` like group tags.
  /// The update will only notify the Widgets, if [condition] is true.
  void setState([List<Object>? ids, bool condition = true]) {
    if (!condition) {
      return;
    }
    if (ids == null) {
      refresh();
    } else {
      for (final id in ids) {
        refreshGroup(id);
      }
    }
  }
}

/// this mixin allow to fetch data when the scroll is at the bottom or on the
/// top
mixin DragMixin on JuneLifeCycleMixin {
  final ScrollController scroll = ScrollController();

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(_listener);
  }

  bool _canFetchBottom = true;

  bool _canFetchTop = true;

  void _listener() {
    if (scroll.position.atEdge) {
      _checkIfCanLoadMore();
    }
  }

  Future<void> _checkIfCanLoadMore() async {
    if (scroll.position.pixels == 0) {
      if (!_canFetchTop) return;
      _canFetchTop = false;
      await onTopScroll();
      _canFetchTop = true;
    } else {
      if (!_canFetchBottom) return;
      _canFetchBottom = false;
      await onEndScroll();
      _canFetchBottom = true;
    }
  }

  /// this method is called when the scroll is at the bottom
  Future<void> onEndScroll();

  /// this method is called when the scroll is at the top
  Future<void> onTopScroll();

  @override
  void onClose() {
    scroll.removeListener(_listener);
    super.onClose();
  }
}

/// A clean controller to be used with only Rx variables
// abstract class RxController with JuneLifeCycleMixin {}

/// A controller with super lifecycles (including native lifecycles)
abstract class FullLifeCycleController extends JuneState
    with
        // ignore: prefer_mixin
        WidgetsBindingObserver {}

mixin FullLifeCycleMixin on FullLifeCycleController {
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    obscure(Engine.instance)!.addObserver(this);
  }

  @mustCallSuper
  @override
  void onClose() {
    obscure(Engine.instance)!.removeObserver(this);
    super.onClose();
  }

  @mustCallSuper
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
      case AppLifecycleState.hidden:
        onHidden();
        break;
    }
  }

  void onResumed() {}

  void onPaused() {}

  void onInactive() {}

  void onDetached() {}

  void onHidden() {}
}
