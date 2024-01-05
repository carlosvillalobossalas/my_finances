import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_finances/config/constants/environment.dart';
import 'package:my_finances/config/router/app_router.dart';
import 'package:my_finances/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBuxr7UogTEYxWxMJZAycLWhhfEzaL9RaI",
    projectId: "myapp-af039",
    messagingSenderId: "624780649148",
    appId: "1:624780649148:web:5d25120939252fabbba6b9",
  ));
  await Environment.initEnvironment();

  runApp(const ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: colors.primary));
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      title: '',
      theme: AppTheme(selectedColor: 0).getTheme(),
    );
  }
}
