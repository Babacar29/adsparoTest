import 'dart:io';

import 'package:adsparo_test/app/routes.dart';
import 'package:adsparo_test/cubits/Auth/firebaseAuthCubit.dart';
import 'package:adsparo_test/ui/screens/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/Auth/authCubit.dart';
import '../cubits/Auth/deleteUserCubit.dart';
import '../cubits/Auth/registerTokenCubit.dart';
import '../cubits/Auth/updateUserCubit.dart';
import '../cubits/getAllUsersDataCubit.dart';
import '../cubits/languageCubit.dart';
import '../cubits/languageJsonCubit.dart';
import '../data/repositories/Auth/authLocalDataSource.dart';
import '../data/repositories/GetAllUsers/getAllUsersRepository.dart';
import '../data/repositories/LanguageJson/languageJsonRepository.dart';
import '../data/repositories/Auth/authRepository.dart';
import '../data/repositories/language/languageRepository.dart';
import '../utils/uiUtils.dart';


Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesServices.init();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp();

  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MultiBlocProvider(providers: [
    BlocProvider<LanguageJsonCubit>(create: (_) => LanguageJsonCubit(LanguageJsonRepository())),
    BlocProvider<LanguageCubit>(create: (context) => LanguageCubit(LanguageRepository())),
    BlocProvider<AuthCubit>(create: (_) => AuthCubit(AuthRepository())),
    BlocProvider<RegisterTokenCubit>(create: (_) => RegisterTokenCubit(AuthRepository())),
    BlocProvider<UpdateUserCubit>(create: (_) => UpdateUserCubit(AuthRepository())),
    BlocProvider<DeleteUserCubit>(create: (_) => DeleteUserCubit(AuthRepository())),
    BlocProvider<GetAllUsersCubit>(create: (_) => GetAllUsersCubit(GetAllUsersRepository(), SharedPreferencesServices())),
    BlocProvider<FirebaseAuthCubit>(create: (_) => FirebaseAuthCubit(AuthRepository(), SharedPreferencesServices())),

  ], child: const MyApp()));
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: UiUtils.rootNavigatorKey,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splash,
        home: const Splash(),
        onGenerateRoute: Routes.onGenerateRouted,
        builder: (context, widget) {
          return widget!;
        }
      );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
