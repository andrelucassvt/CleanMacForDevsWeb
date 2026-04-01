import 'package:flutter/foundation.dart';

@immutable
sealed class LandingState {
  const LandingState();
}

class LandingInitial extends LandingState {
  const LandingInitial();
}

class LandingLoaded extends LandingState {
  const LandingLoaded();
}
