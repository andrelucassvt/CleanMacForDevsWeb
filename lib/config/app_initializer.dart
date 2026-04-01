import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:verify_local_purchase/verify_local_purchase.dart';

class AppInitializer {
  static Future<void> initialize(AppFlavor flavor) async {
    // Inicializações comuns que são sempre necessárias
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    VerifyLocalPurchase.initialize(
      appleConfig: AppleConfig(
        bundleId: 'xxxxx',
        issuerId: 'xxxxx',
        keyId: 'xxxxx',
        privateKey: 'xxxxx', // AppBytes.decryptPrivateKey(),
      ),
      googlePlayConfig: GooglePlayConfig(
        packageName: 'xxxxx',
        serviceAccountJson: 'xxxxx', // AppBytes.decrypt(),
      ),
    );

    // Setup das dependências com o flavor específico
    await AppInjector.setupDependencies(flavor: flavor);
  }
}
