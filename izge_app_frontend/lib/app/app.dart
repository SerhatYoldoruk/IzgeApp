import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:izge_app_frontend/features/auth/presentation/pages/login_screen.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../core/accessibility/accessibility_controller.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/events/presentation/bloc/event_bloc.dart';
import '../features/events/presentation/bloc/event_event.dart';
import '../features/news/presentation/bloc/news_bloc.dart';
import '../features/news/presentation/bloc/news_event.dart';
import '../features/surveys/presentation/bloc/survey_bloc.dart';
import '../features/surveys/presentation/bloc/survey_event.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import '../features/community/presentation/bloc/community_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/presentation/pages/update_password_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class IzgeApp extends StatefulWidget {
  const IzgeApp({super.key, this.initialization});

  final Future<void>? initialization;
  static bool isTesting = false;

  @override
  State<IzgeApp> createState() => _IzgeAppState();
}

class _IzgeAppState extends State<IzgeApp> {
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        // Delay to ensure navigator is built
        Future.delayed(const Duration(milliseconds: 100), () {
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (context) => const UpdatePasswordScreen()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([ThemeController.instance, AccessibilityController.instance]),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (context) => AuthBloc()..add(AuthCheckRequested()),
            ),
            BlocProvider<EventBloc>(
              create: (context) => EventBloc()..add(EventFetchRequested()),
            ),
            BlocProvider<NewsBloc>(
              create: (context) => NewsBloc()..add(NewsFetchRequested()),
            ),
            BlocProvider<SurveyBloc>(
              create: (context) => SurveyBloc()..add(SurveyFetchRequested()),
            ),
            BlocProvider<CommunityBloc>(
              create: (context) => CommunityBloc(Supabase.instance.client),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'İzge App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeController.instance.themeMode,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr', 'TR'),
              Locale('en', 'US'),
            ],
            builder: (context, child) {
              final scale = AccessibilityController.instance.textScaleFactor;
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale),
                ),
                child: child!,
              );
            },
            home: IzgeApp.isTesting
                ? const LoginScreen()
                : SplashScreen(initialization: widget.initialization),
          ),
        );
      },
    );
  }
}

