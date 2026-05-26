import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../core/localization/language_controller.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/events/presentation/bloc/event_bloc.dart';
import '../features/events/presentation/bloc/event_event.dart';
import '../features/news/presentation/bloc/news_bloc.dart';
import '../features/news/presentation/bloc/news_event.dart';
import '../features/surveys/presentation/bloc/survey_bloc.dart';
import '../features/surveys/presentation/bloc/survey_event.dart';
import '../features/auth/presentation/pages/splash_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IzgeApp extends StatelessWidget {
  const IzgeApp({super.key, this.initialization});

  final Future<void>? initialization;
  static bool isTesting = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        ThemeController.instance,
        LanguageController.instance,
      ]),
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
          ],
          child: MaterialApp(
            title: 'İzge App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeController.instance.themeMode,
            home: IzgeApp.isTesting
                ? const LoginScreen()
                : SplashScreen(initialization: initialization),
          ),
        );
      },
    );
  }
}

