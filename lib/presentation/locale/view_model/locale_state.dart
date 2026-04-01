import 'dart:ui';

import 'package:flutter/foundation.dart';

@immutable
sealed class LocaleState {
  const LocaleState();
}

class LocaleChanged extends LocaleState {
  const LocaleChanged(this.locale);

  final Locale locale;
}
