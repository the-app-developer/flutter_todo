import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/social_login.dart';
import 'package:todo_app/ui/archive/archive_screen.dart';
import 'package:todo_app/ui/dashboard/dashboard_screen.dart';
import 'package:todo_app/ui/favourite/favourite_screen.dart';
import 'package:todo_app/ui/wlecome/welcome_screen.dart';
import 'package:todo_app/utils/routes.dart';

import 'core/task_notifier.dart';
import 'theme/app_theme.dart';
import 'ui/launch/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (!kIsWeb) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FacebookAuth.i.webInitialize(
      appId: SocialLogin.fbAppID,
      cookie: true,
      xfbml: true,
      version: "v9.0",
    );
  }
  runApp(ChangeNotifierProvider(
    create: (context) => TaskNotifier(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home: const SplashScreen(),
      routes: {
        MyRoutes.splashRoute: (context) => const SplashScreen(),
        MyRoutes.welcomeRoute: (context) => const WelomeScreen(),
        MyRoutes.homeRoute: (context) => const DashboradScreen(),
        MyRoutes.archiveRoute: (context) => const ArchiveScreen(),
        MyRoutes.favouriteRoute: (context) => const FavouriteScreen(),
      },
    );
  }
}
