# CLAUDE.md

## Sobre Este Projeto

**Nome**: Clean Mac for Devs — Landing Page  
**Pacote Flutter**: `base_app`  
**Descrição**: Web app (landing page) do app macOS "Clean Mac for Devs" — ferramenta que ajuda desenvolvedores a liberar espaço em disco removendo artefatos de build e caches de projetos Flutter, Xcode, Node.js, Python, Rust, Android, React Native e React.  
**Flutter SDK**: ^3.35.0 | **Dart SDK**: ^3.9.0  
**Plataformas**: Web (deploy principal), Android, iOS  
**iOS target**: 14.0 | **Android**: `flutter.minSdkVersion`  
**Bundle ID**: `com.andre.cleanMacForDevsWebPage`  
**Flavors**: `development`, `staging`, `production`

---

## Estrutura do Projeto

```
lib/
├── app.dart                          # Widget raiz — MaterialApp.router com tema e localização
├── bootstrap.dart                    # Bootstrap da app e AppBlocObserver
├── main.dart                         # Entry point genérico
├── main_development.dart             # Entry point — flavor Development
├── main_staging.dart                 # Entry point — flavor Staging
├── main_production.dart              # Entry point — flavor Production
├── common/
│   ├── services/
│   │   ├── storage_service.dart      # Interface StorageService (abstração de persistência)
│   │   ├── shared_preferences_service.dart  # Implementação com SharedPreferences
│   │   └── http/
│   │       ├── http_service.dart     # Interface HttpService
│   │       └── dio_http_service.dart # Implementação com Dio
│   ├── styles/
│   │   └── app_theme.dart            # Temas light e dark (ThemeData)
│   ├── utils/
│   │   └── extensions.dart           # Extensions de BuildContext e utilitários
│   └── widgets/                      # Widgets reutilizáveis entre features
│       └── language_toggle_button.dart  # Botão de troca de idioma (PT/EN)
├── config/
│   ├── app_initializer.dart          # Inicialização: WidgetsFlutterBinding + DI
│   ├── error/
│   │   └── result_pattern.dart       # Result<T> (Ok / Error) + helpers when/whenAsync
│   ├── inject/
│   │   └── app_injector.dart         # GetIt — registro de todas as dependências
│   ├── network/
│   │   ├── dio_client.dart           # Configuração do Dio (baseUrl, timeout)
│   │   ├── auth_interceptor.dart     # Interceptor de autorização (Bearer token)
│   │   └── error_interceptor.dart    # Interceptor de erros HTTP
│   └── routes/
│       ├── app_router.dart           # GoRouter — definição de rotas
│       └── app_routes.dart           # Constantes de rotas (AppRoutes)
├── l10n/
│   ├── l10n.dart                     # Extension context.l10n para internacionalização
│   ├── arb/
│   │   ├── app_en.arb               # Strings em inglês
│   │   └── app_pt.arb               # Strings em português
│   └── gen/                          # Código gerado pelo flutter gen-l10n
└── presentation/
    ├── landing/
    │   ├── view/
    │   │   └── landing_view.dart     # Tela principal da landing page
    │   ├── view_model/
    │   │   ├── landing_cubit.dart    # LandingCubit
    │   │   └── landing_state.dart    # LandingState (sealed)
    │   └── widgets/
    │       ├── hero_section.dart          # Seção hero (título, CTA)
    │       ├── technologies_section.dart  # Seção de tecnologias suportadas
    │       ├── screenshots_section.dart   # Seção de screenshots do app
    │       ├── what_is_removed_section.dart  # Seção "o que é removido"
    │       └── footer_section.dart        # Rodapé
    └── locale/
        └── view_model/
            ├── locale_cubit.dart     # LocaleCubit — gerencia troca de idioma
            └── locale_state.dart     # LocaleState (sealed)
```

---

## Arquitetura

**Clean Architecture** com camadas `presentation` → `domain` ← `data`

- **State management**: Cubit (flutter_bloc) — sealed states com `@immutable`
- **DI**: GetIt via `AppInjector` — `registerFactory` para Cubits, `registerLazySingleton` para todo o resto
- **Navegação**: GoRouter — sempre na View/BlocListener, nunca no Cubit
- **Error handling**: `Result<T>` (Ok/Error) — repositories sempre retornam Result, nunca relançam exceções
- **i18n**: flutter_localizations + intl — acessado via `context.l10n.<chave>`, zero strings hardcoded na UI
- **Multi-flavor**: development / staging / production — entry points separados + variantes Android

**Regras críticas:**
- Imports SEMPRE absolutos: `package:base_app/...`
- Views sempre com `SafeArea` envolvendo o conteúdo principal
- Nunca crie `Widget _buildXxx()` privado dentro da View — extraia para `widgets/` ou `content/`
- Cubit async: emita Loading → chame repository → use `result.when()`

---

## Comandos Úteis

```bash
# Rodar por flavor
flutter run --flavor development -t lib/main_development.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor production -t lib/main_production.dart

# Rodar na web
flutter run -d chrome --flavor development -t lib/main_development.dart

# Build web
flutter build web --release --flavor production -t lib/main_production.dart

# Testes
flutter test

# Lint
flutter analyze

# Gerar localização
flutter gen-l10n

# Gerar ícones
flutter pub run flutter_launcher_icons
```

---

## Convenções de Nomenclatura

- **Arquivos**: `snake_case` → `landing_view.dart`, `hero_section.dart`
- **Classes**: `PascalCase` → `LandingView`, `LandingCubit`, `HeroSection`
- **Variáveis/Métodos**: `camelCase` → `_cubit`, `initialize()`
- **Rotas**: constantes em `AppRoutes` → `AppRoutes.landing`
- **States**: sealed class com sufixo do estado → `LandingInitial`, `LandingLoaded`, `LandingError`
- **Widgets de seção da landing**: sufixo `Section` → `HeroSection`, `FooterSection`

---

## Dependências Externas

**State Management**
- `bloc: ^9.0.1` + `flutter_bloc: ^9.1.1`

**Injeção de Dependências**
- `get_it: ^8.0.2`

**Navegação**
- `go_router: ^16.2.4`

**Network**
- `dio: ^5.7.0`

**Persistência Local**
- `shared_preferences: ^2.5.3`

**Internacionalização**
- `intl: ^0.20.2` + `flutter_localizations` (sdk)

**Utilitários**
- `package_info_plus: ^8.0.2`
- `url_launcher: ^6.3.1`
- `verify_local_purchase: ^1.0.4`

**Dev**
- `bloc_test: ^10.0.0` + `mocktail: ^1.0.4`
- `flutter_lints: ^2.0.0` + `very_good_analysis: ^10.0.0`
- `flutter_launcher_icons: ^0.14.4`
- `change_app_package_name: ^1.5.0`

---

## Skills Disponíveis

Skills em `.github/skills/` — leia o SKILL.md correspondente antes de executar a tarefa:

| Skill | Quando usar |
|---|---|
| `configure-di` | Registrar/modificar dependências no AppInjector (GetIt) |
| `configure-navigation` | Adicionar rotas ou modificar GoRouter |
| `custom-paint` | Desenhar formas, gráficos ou animações 2D com CustomPaint |
| `flutter-animating-apps` | Implementar animações, transições ou efeitos visuais |
| `flutter-isolates` | Tarefas CPU-intensivas, paralelas ou que travam a UI |
| `guideline-apple` | Auditoria para submissão na App Store |
| `implement-admob` | Integrar anúncios Google AdMob |
| `implement-auth-token-flow` | Autenticação com Bearer token, login, logout |
| `implement-data` | Camada de dados: Models, DataSources, RepositoryImpl |
| `implement-domain` | Camada de domínio: Entities e Repository Interfaces |
| `implement-firebase-notifications` | Push notifications via Firebase Cloud Messaging |
| `implement-in-app-purchase` | Compras in-app, assinaturas, paywall |
| `implement-view` | Criar ou modificar Views (telas) |
| `implement-view-model` | Criar ou modificar Cubits e States |
| `implement-widget` | Criar widgets reutilizáveis em `widgets/` ou `common/widgets/` |
| `skill-creator` | Criar ou melhorar skills do projeto |
