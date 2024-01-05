import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouterNotifierProvider = Provider((ref) {
  return GoRouterNotifier();
});

class GoRouterNotifier extends ChangeNotifier {
  GoRouterNotifier();
}
