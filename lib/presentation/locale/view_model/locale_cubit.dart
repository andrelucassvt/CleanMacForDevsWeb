import 'dart:ui';

import 'package:base_app/presentation/locale/view_model/locale_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleChanged(Locale('en')));

  void toggleLocale() {
    final current = (state as LocaleChanged).locale;
    final next = current.languageCode == 'en'
        ? const Locale('pt')
        : const Locale('en');
    emit(LocaleChanged(next));
  }
}
