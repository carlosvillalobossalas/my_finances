import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_finances/config/router/app_router_notifier.dart';
import 'package:my_finances/csv/presentation/screens/csv_screen.dart';
import 'package:my_finances/entities/presentation/screens/add_entity_screen.dart';
import 'package:my_finances/home_screen.dart';
import 'package:my_finances/tags/presentation/screens/add_tag_screen.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: goRouterNotifier,
    routes: <RouteBase>[
      // GoRoute(
      //   path: '/splash',
      //   // name: LoginScreen.name,
      //   builder: (context, state) {
      //     return const CheckAuthStatusScreen();
      //   },
      // ),
      // GoRoute(
      //   path: '/login',
      //   // name: LoginScreen.name,
      //   builder: (context, state) {
      //     return const LoginScreen();
      //   },
      // ),
      GoRoute(
        path: '/csv',
        // name: LoginScreen.name,
        builder: (context, state) {
          return const CsvScreen();
        },
      ),
      GoRoute(
        path: '/',
        // name: LoginScreen.name,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/add/tag',
        // name: LoginScreen.name,
        builder: (context, state) {
          return const AddTagScreen();
        },
      ),
      GoRoute(
        path: '/add/entity',
        // name: LoginScreen.name,
        builder: (context, state) {
          return const AddEntityScreen();
        },
      ),
      //
    ],
    redirect: (context, state) {
      return null;
    },
  );
});
