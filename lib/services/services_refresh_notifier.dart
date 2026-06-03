import 'package:flutter/foundation.dart';

/// Global signal to tell service lists (e.g. HomePage) that something
/// happened that requires re-querying the service data — typically a
/// cancellation or deletion performed from a card or detail page that
/// lives outside the list's widget tree.
class ServicesRefreshNotifier extends ChangeNotifier {
  ServicesRefreshNotifier._();

  static final ServicesRefreshNotifier instance = ServicesRefreshNotifier._();

  void notifyRefresh() => notifyListeners();
}
