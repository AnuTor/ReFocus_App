import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/routes.dart';
import './screens/auth_screen.dart';
import './screens/tabs_screen.dart';
import './screens/splash_screen.dart';
import './screens/path_screen.dart';
import './screens/activity_screen.dart';
import './screens/survey_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: initialization,
        builder: (ctx, appSnapshot) {
          return ChangeNotifierProvider(
            create: (ctx) => Routes(),
            child: MaterialApp(
              title: 'Refocus App',
              theme: ThemeData(
                fontFamily: 'Poppins',
                brightness: Brightness.light,
                primarySwatch: Colors.lightBlue,
                appBarTheme: const AppBarTheme(
                  foregroundColor: Colors.white,
                ),
                textTheme: const TextTheme(
                  headline5: TextStyle(
                    fontSize: 22,
                    //fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                  headline6: TextStyle(fontSize: 16),
                  bodyText1: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white,
                ),
              ),
              home: appSnapshot.connectionState != ConnectionState.done
                  ? const SplashScreen()
                  : StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, userSnapshot) {
                        if (userSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SplashScreen();
                        }
                        if (userSnapshot.hasData) {
                          return const TabsScreen();
                        }
                        return const AuthScreen();
                      }),
              routes: {
                PathScreen.routeName: (ctx) => const PathScreen(),
                ActivityScreen.routeName: (ctx) => const ActivityScreen(),
                SurveyScreen.routeName: (ctx) => const SurveyScreen(),
              },
              onUnknownRoute: (settings) {
                return MaterialPageRoute(
                  builder: (ctx) => const SplashScreen(),
                );
              },
            ),
          );
        });
  }
}
