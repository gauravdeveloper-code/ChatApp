import 'package:chat_app/Common/Widgets/Loader.dart';
import 'package:chat_app/ErrorPage.dart';
import 'package:chat_app/Features/Auth/Controller/Auth_Controller.dart';
import 'package:chat_app/Features/Auth/Screens/Login_Screen.dart';
import 'package:chat_app/Features/Screens/Moblie_Screen.dart';
import 'package:chat_app/Router.dart';
import 'package:chat_app/Widgets/Constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      home: ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null) {
              return const LoginScreen();
            }
            return const MobileScreen();
          },
          error: (err, trace) {
            return ErrorPage(
              error: err.toString(),
            );
          },
          loading: () => const Loader()),
      onGenerateRoute: (settings) => generateRoute(settings),
    );
  }
}
