# GitHub Copilot Instructions — Cleaner for Devs Landing Page

Este arquivo é lido pelo Copilot e fornece contexto e regras do projeto.

---

## Contexto

**Projeto**: Cleaner for Devs — Landing Page  
**Pacote**: `base_app`  
**Descrição**: Web app Flutter que serve como landing page para o app macOS "Cleaner for Devs"  
**Flutter SDK**: ^3.35.0 | **Dart SDK**: ^3.9.0  
**Plataformas**: Web (deploy principal), Android, iOS  
**iOS target**: 14.0 | **Android**: `flutter.minSdkVersion`  
**Bundle ID**: `com.andre.cleanMacForDevsWebPage`  
**Flavors**: `development`, `staging`, `production`

---

## Arquitetura: Clean Architecture — Flutter

### Regras Obrigatórias

- Imports SEMPRE absolutos: `package:base_app/...` — NUNCA relativos
- Views: `StatefulWidget` + `BlocBuilder` + Cubit obtido do `AppInjector`
- Cubit async: emitir `Loading` → chamar repository → usar `result.when()`
- Repositories: SEMPRE `try/catch` retornando `Result.error(...)` — nunca relançar exceções
- Textos na UI: SEMPRE `context.l10n.<chave>` — ZERO strings hardcoded visíveis
- States: `sealed class` com `@immutable` + `const`
- DI: Cubits → `registerFactory`; todo o resto → `registerLazySingleton`
- Navegação: GoRouter — SEMPRE na View ou `BlocListener`, NUNCA no Cubit
- `SafeArea`: SEMPRE envolver o conteúdo principal da View
- Performance: NUNCA criar `Widget _buildXxx()` nem classes privadas de widget dentro da View — extrair para `widgets/` (reutilizável) ou `content/` (auxiliar específico); dialog/bottomSheet são exceção

### Compatibilidade de Plataformas

| Plataforma | Status | Observações |
|---|---|---|
| Web | Suportado | Deploy em `public/` — target primário do projeto |
| iOS | Suportado | Target 14.0, flavors via schemes |
| Android | Suportado | Flavors: development (.dev), staging (.stg), production |
| macOS | Não configurado | — |
| Linux | Não configurado | — |
| Windows | Não configurado | — |

### Convenções de Nomenclatura

- **Arquivos**: `snake_case` → `landing_view.dart`, `hero_section.dart`
- **Classes**: `PascalCase` → `LandingView`, `LandingCubit`, `HeroSection`
- **Variáveis/Métodos**: `camelCase` → `_cubit`, `initialize()`
- **Constantes de rota**: em `AppRoutes` → `AppRoutes.landing`
- **States**: `<Feature>Initial`, `<Feature>Loading`, `<Feature>Loaded`, `<Feature>Error`
- **Widgets de seção**: sufixo `Section` → `HeroSection`, `TechnologiesSection`, `FooterSection`

### Princípios

1. **Camadas independentes**: `presentation` usa `domain`; `data` implementa `domain`; `domain` é puro Dart
2. **Result Pattern**: toda operação assíncrona retorna `Result<T>` — sem exceções escapando
3. **Imutabilidade**: Entities e States sempre `@immutable` com `const` e propriedades `final`
4. **i18n obrigatório**: adicionar chaves em `app_en.arb` E `app_pt.arb` antes de usar na UI
5. **DI centralizado**: toda criação de dependências passa pelo `AppInjector`
6. **Zero `print()`**: usar `log()` do `dart:developer`

### Estrutura de Pastas

```
lib/
├── app.dart                    # MaterialApp.router — tema, localização, router
├── bootstrap.dart              # Bootstrap e AppBlocObserver
├── main_development.dart       # Entry point Development
├── main_staging.dart           # Entry point Staging
├── main_production.dart        # Entry point Production
├── common/
│   ├── services/               # StorageService, HttpService (interfaces + impls)
│   ├── styles/                 # AppTheme (light/dark)
│   ├── utils/                  # Extensions do BuildContext
│   └── widgets/                # Widgets reutilizáveis entre features
├── config/
│   ├── app_initializer.dart    # Inicialização da app
│   ├── error/                  # Result<T> pattern
│   ├── inject/                 # AppInjector (GetIt)
│   ├── network/                # Dio, interceptors
│   └── routes/                 # GoRouter, AppRoutes
├── l10n/                       # i18n: arb/, gen/, l10n.dart
└── presentation/
    ├── landing/                # View + Cubit/State + Widgets da landing
    └── locale/                 # LocaleCubit + LocaleState (troca de idioma)
```

---

## Skills Disponíveis

Skills em `.github/skills/` — carregar o SKILL.md correspondente **antes** de executar a tarefa:

| Skill | Quando usar |
|---|---|
| `configure-di` | Registrar/modificar dependências no AppInjector |
| `configure-navigation` | Adicionar rotas ou modificar GoRouter |
| `custom-paint` | CustomPaint/CustomPainter para gráficos 2D |
| `flutter-animating-apps` | Animações, transições ou efeitos visuais |
| `flutter-isolates` | Tarefas CPU-intensivas ou que travam a UI |
| `guideline-apple` | Auditoria para submissão na App Store |
| `implement-admob` | Anúncios Google AdMob |
| `implement-auth-token-flow` | Autenticação Bearer token, login, logout |
| `implement-data` | Models, DataSources, RepositoryImpl |
| `implement-domain` | Entities e Repository Interfaces |
| `implement-firebase-notifications` | Push notifications via FCM |
| `implement-in-app-purchase` | Compras in-app, assinaturas, paywall |
| `implement-view` | Criar ou modificar Views (telas) |
| `implement-view-model` | Criar ou modificar Cubits e States |
| `implement-widget` | Widgets reutilizáveis |
| `skill-creator` | Criar ou melhorar skills |
