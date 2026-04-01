import 'package:base_app/presentation/landing/view_model/landing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingCubit extends Cubit<LandingState> {
  LandingCubit() : super(const LandingInitial());

  void initialize() {
    emit(const LandingLoaded());
  }
}
