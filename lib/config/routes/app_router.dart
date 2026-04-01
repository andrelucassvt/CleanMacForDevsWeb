import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/presentation/landing/view/landing_view.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.landing,
  routes: [
    GoRoute(
      path: AppRoutes.landing,
      builder: (context, state) => const LandingView(),
    ),
  ],
);
