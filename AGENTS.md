# AGENTS.md

## Sobre Este Projeto

**Nome**: Clean Mac for Devs — Landing Page  
**Pacote Flutter**: `base_app`  
**Descrição**: Web app (landing page) do app macOS "Clean Mac for Devs" — ferramenta que ajuda desenvolvedores a liberar espaço em disco removendo artefatos de build e caches de projetos Flutter, Xcode, Node.js, Python, Rust, Android, React Native e React.  
**Flutter SDK**: ^3.35.0 | **Dart SDK**: ^3.9.0  
**Plataformas**: Web (deploy principal), Android, iOS  
**iOS target**: 14.0 | **Android**: `flutter.minSdkVersion`  
**Flavors**: `development`, `staging`, `production`

---

## Estrutura do Projeto

```
lib/
├── app.dart                          # Widget raiz — MaterialApp.router
├── bootstrap.dart                    # Bootstrap e AppBlocObserver
├── main_development.dart             # Entry point — flavor Development
├── main_staging.dart                 # Entry point — flavor Staging
├── main_production.dart              # Entry point — flavor Production
├── common/
│   ├── services/
│   │   ├── storage_service.dart      # Interface StorageService
│   │   ├── shared_preferences_service.dart  # Implementação SharedPreferences
│   │   └── http/
│   │       ├── http_service.dart     # Interface HttpService
│   │       └── dio_http_service.dart # Implementação Dio
│   ├── styles/app_theme.dart         # Temas light e dark
│   ├── utils/extensions.dart         # Extensions de BuildContext
│   └── widgets/
│       └── language_toggle_button.dart  # Botão PT/EN
├── config/
│   ├── app_initializer.dart          # Inicialização: WidgetsFlutterBinding + DI
│   ├── error/result_pattern.dart     # Result<T> (Ok / Error)
│   ├── inject/app_injector.dart      # GetIt — AppInjector
│   ├── network/
│   │   ├── dio_client.dart           # Configuração Dio
│   │   ├── auth_interceptor.dart     # Interceptor de autorização
│   │   └── error_interceptor.dart    # Interceptor de erros HTTP
│   └── routes/
│       ├── app_router.dart           # GoRouter
│       └── app_routes.dart           # Constantes de rotas
├── l10n/
│   ├── l10n.dart                     # Extension context.l10n
│   ├── arb/app_en.arb + app_pt.arb  # Strings EN e PT
│   └── gen/                          # Código gerado
└── presentation/
    ├── landing/
    │   ├── view/landing_view.dart
    │   ├── view_model/landing_cubit.dart + landing_state.dart
    │   └── widgets/
    │       ├── hero_section.dart + technologies_section.dart
    │       ├── screenshots_section.dart + what_is_removed_section.dart
    │       └── footer_section.dart
    └── locale/view_model/
        ├── locale_cubit.dart
        └── locale_state.dart
```

---

## Arquitetura: Clean Architecture — Flutter

### Regras Mandatórias

**Camadas e dependências:**
- `presentation` usa `domain`; `data` implementa `domain`; `domain` é puro Dart
- Imports SEMPRE absolutos: `package:base_app/...` — NUNCA relativos

**Views:**
- Sempre `StatefulWidget` com Cubit obtido do `AppInjector`
- Sempre envolver conteúdo principal com `SafeArea`
- Nunca criar `Widget _buildXxx()` nem classes privadas de widget na View — extrair para `widgets/` (reutilizável) ou `content/` (auxiliar específico); dialog/bottomSheet são exceção
- Chamar `_cubit.close()` no `dispose()`

**Cubits:**
- Método async: emitir `Loading` → chamar repository → usar `result.when()`
- Nunca receber `BuildContext`; navegação sempre na View

**Repositories:**
- Sempre envolver em `try/catch` e retornar `Result.error(...)` — nunca relançar exceção

**DI (AppInjector):**
- Cubits → `registerFactory`
- Services, Repositories, DataSources → `registerLazySingleton`

**Textos na UI:**
- SEMPRE `context.l10n.<chave>` — zero strings hardcoded visíveis ao usuário
- Adicionar chaves em `app_en.arb` E `app_pt.arb`

**States:**
- Sempre `sealed class` com `@immutable` e `const`

---

## Convenções de Nomenclatura

- **Arquivos**: `snake_case` → `landing_view.dart`
- **Classes**: `PascalCase` → `LandingCubit`, `HeroSection`
- **Variáveis/Métodos**: `camelCase` → `_cubit`, `initialize()`
- **Rotas**: constantes em `AppRoutes` → `AppRoutes.landing`
- **States**: `<Feature>Initial`, `<Feature>Loading`, `<Feature>Loaded`, `<Feature>Error`
- **Widgets de seção**: sufixo `Section` → `HeroSection`, `TechnologiesSection`

---

## Skills

| Skill | Quando usar |
|---|---|
| `configure-di` | Registrar/modificar dependências no AppInjector |
| `configure-navigation` | Adicionar rotas ou modificar GoRouter |
| `custom-paint` | Desenhar formas, gráficos ou animações 2D com CustomPaint |
| `flutter-animating-apps` | Animações, transições ou efeitos visuais |
| `flutter-isolates` | Tarefas CPU-intensivas ou que travam a UI |
| `guideline-apple` | Auditoria para submissão na App Store |
| `implement-admob` | Integrar anúncios Google AdMob |
| `implement-auth-token-flow` | Autenticação com Bearer token, login, logout |
| `implement-data` | Models, DataSources, RepositoryImpl |
| `implement-domain` | Entities e Repository Interfaces |
| `implement-firebase-notifications` | Push notifications via FCM |
| `implement-in-app-purchase` | Compras in-app, assinaturas, paywall |
| `implement-view` | Criar ou modificar Views (telas) |
| `implement-view-model` | Criar ou modificar Cubits e States |
| `implement-widget` | Widgets reutilizáveis em `widgets/` ou `common/widgets/` |
| `skill-creator` | Criar ou melhorar skills do projeto |
