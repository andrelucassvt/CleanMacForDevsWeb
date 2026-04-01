import 'package:base_app/common/styles/app_theme.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_router.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/locale/view_model/locale_cubit.dart';
import 'package:base_app/presentation/locale/view_model/locale_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCubit = AppInjector.inject.get<LocaleCubit>();
    return BlocProvider.value(
      value: localeCubit,
      child: BlocBuilder<LocaleCubit, LocaleState>(
        bloc: localeCubit,
        builder: (context, state) {
          final locale = (state as LocaleChanged).locale;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: MaterialApp.router(
              locale: locale,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: appRouter,
            ),
          );
        },
      ),
    );
  }
}
