import 'dart:async';

import 'package:base_app/common/widgets/language_toggle_button.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/presentation/landing/view_model/landing_cubit.dart';
import 'package:base_app/presentation/landing/view_model/landing_state.dart';
import 'package:base_app/presentation/landing/widgets/footer_section.dart';
import 'package:base_app/presentation/landing/widgets/hero_section.dart';
import 'package:base_app/presentation/landing/widgets/screenshots_section.dart';
import 'package:base_app/presentation/landing/widgets/technologies_section.dart';
import 'package:base_app/presentation/landing/widgets/what_is_removed_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final LandingCubit _cubit = AppInjector.inject.get<LandingCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LandingCubit, LandingState>(
            bloc: _cubit,
            builder: (context, state) {
              return const Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        HeroSection(),
                        TechnologiesSection(),
                        ScreenshotsSection(),
                        WhatIsRemovedSection(),
                        FooterSection(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: LanguageToggleButton(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    super.dispose();
  }
}
