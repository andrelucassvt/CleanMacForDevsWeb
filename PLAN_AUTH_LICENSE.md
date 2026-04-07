# Plano: Auth + Licença + Pagamento Stripe

## Visão Geral

Implementar Firebase Auth (email/senha), criação de documento do usuário no Firestore, seleção de licença (3 meses / 1 ano) e integração com Stripe Payment Link na landing page Flutter web. Admin ativa licenças manualmente por enquanto. O app macOS cuida da vinculação de dispositivo — a web apenas cria o doc com `macbook_id` vazio.

---

## Decisões

| Aspecto | Decisão |
|---|---|
| Auth provider | Firebase Auth (email/senha) |
| Pagamento | Stripe Payment Link estático (abre nova aba) |
| Ativação de licença | Admin atualiza Firestore manualmente |
| Login / Cadastro | Telas separadas com link entre elas |
| Tela de conta | Email + status + expiração + botão comprar + logout |
| Hero | Dois botões: Download (App Store) + Obter Licença |
| Vinculação de Mac | Web cria doc com `macbook_id` vazio; macOS cuida do binding |
| Fora do escopo | Cloud Functions, Stripe webhook, vinculação de dispositivo, página de sucesso |

---

## Estrutura do documento Firestore

```
users/{uid}
  email:              string
  macbook_id:         string  (vazio na criação)
  license_type:       string  ("" | "3_months" | "1_year")
  license_status:     string  ("inactive" | "active" | "expired")
  license_expires_at: timestamp | null
  created_at:         timestamp
```

---

## Fases de Implementação

### Fase 1 — Dependências e Infraestrutura

- [ ] **1. Adicionar `firebase_auth`** em `pubspec.yaml` → `flutter pub get`
- [ ] **2. Criar `AuthService`** em `lib/common/services/auth_service.dart`
  - Envolve `FirebaseAuth.instance`
  - Métodos: `signIn(email, password)`, `signUp(email, password)`, `signOut()`, `currentUser`, `authStateChanges`, `isAuthenticated`
  - Não toca no Firestore — apenas Firebase Auth
- [ ] **3. Atualizar regras do Firestore** em `firestore.rules`
  - Usuário autenticado pode ler/criar o próprio doc
  - Client não pode escrever campos de licença (apenas admin)

---

### Fase 2 — Camada de Domínio

- [ ] **4. Criar `UserEntity`** em `lib/domain/entities/user_entity.dart`
  - Campos: `uid`, `email`, `macbookId`, `licenseType`, `licenseStatus`, `licenseExpiresAt`, `createdAt`
  - `@immutable`, `const`, `final`, `copyWith()`, `==`, `hashCode`
- [ ] **5. Criar interface `UserRepository`** em `lib/domain/interfaces/user_repository.dart`
  - `Future<Result<UserEntity>> getUser(String uid)`
  - `Future<Result<UserEntity>> createUser(UserEntity user)`

---

### Fase 3 — Camada de Dados

- [ ] **6. Criar `UserModel`** em `lib/data/models/user_model.dart`
  - Estende `UserEntity`
  - `fromFirestore(DocumentSnapshot)`, `toFirestore()`, `fromEntity(UserEntity)`
- [ ] **7. Criar `UserFirestoreDatasource`** em `lib/data/datasources/user_firestore_datasource.dart`
  - Usa `FirebaseFirestore.instance`
  - Métodos: `getUser(uid)`, `createUser(uid, data)`, `userExists(uid)`
- [ ] **8. Criar `UserRepositoryImpl`** em `lib/data/repositories/user_repository_impl.dart`
  - Implementa `UserRepository`
  - `try/catch` retornando `Result.error()` — nunca relança

---

### Fase 4 — Feature Auth (Login + Cadastro)

- [ ] **9. Criar `AuthState`** em `lib/presentation/auth/view_model/auth_state.dart`
  - Sealed: `AuthInitial`, `AuthLoading`, `AuthSuccess(UserEntity)`, `AuthError(message)`
- [ ] **10. Criar `AuthCubit`** em `lib/presentation/auth/view_model/auth_cubit.dart`
  - Dependências: `AuthService`, `UserRepository`
  - `login(email, password)`: Loading → `authService.signIn()` → `userRepository.getUser()` → AuthSuccess
  - `register(email, password)`: Loading → `authService.signUp()` → `userRepository.createUser()` → AuthSuccess
  - Erros do Firebase Auth mapeados para mensagens amigáveis via l10n
- [ ] **11. Criar `LoginView`** em `lib/presentation/auth/view/login_view.dart`
  - Email + senha + botão login
  - `BlocListener`: `AuthSuccess` → `context.go(AppRoutes.account)`
  - Link: "Criar conta" → `context.push(AppRoutes.register)`
- [ ] **12. Criar `RegisterView`** em `lib/presentation/auth/view/register_view.dart`
  - Email + senha + confirmar senha + botão cadastrar
  - `BlocListener`: `AuthSuccess` → `context.go(AppRoutes.account)`
  - Link: "Já tenho conta" → `context.pop()`

---

### Fase 5 — Feature Account (Dashboard)

- [ ] **13. Criar `AccountState`** em `lib/presentation/account/view_model/account_state.dart`
  - Sealed: `AccountInitial`, `AccountLoading`, `AccountLoaded(UserEntity)`, `AccountError(message)`, `AccountLoggedOut`
- [ ] **14. Criar `AccountCubit`** em `lib/presentation/account/view_model/account_cubit.dart`
  - Dependências: `AuthService`, `UserRepository`
  - `loadAccount()`: Loading → get UID atual → `userRepository.getUser()` → Loaded
  - `logout()`: `authService.signOut()` → emite LoggedOut
- [ ] **15. Criar `AccountView`** em `lib/presentation/account/view/account_view.dart`
  - Mostra: email, badge de status da licença (ativo/inativo/expirado), data de expiração
  - Botão "Selecionar plano" (se inativa/expirada) → `context.push(AppRoutes.plans)`
  - Botão logout → `BlocListener` para `AccountLoggedOut` → `context.go(AppRoutes.landing)`

---

### Fase 6 — Feature Plans (Seleção de Licença)

- [ ] **16. Criar `PlansState`** em `lib/presentation/plans/view_model/plans_state.dart`
  - Sealed: `PlansInitial`, `PlansLoaded(selectedPlan)`
- [ ] **17. Criar `PlansCubit`** em `lib/presentation/plans/view_model/plans_cubit.dart`
  - Apenas UI — `selectPlan(type)` → emite PlansLoaded
  - Sem repository (links do Stripe são hardcoded/config)
- [ ] **18. Criar widget `PlanCard`** em `lib/presentation/plans/widgets/plan_card.dart`
  - Card reutilizável: título, preço, duração, lista de features, destaque quando selecionado
- [ ] **19. Criar `PlansView`** em `lib/presentation/plans/view/plans_view.dart`
  - 2 `PlanCard` widgets (3 meses / 1 ano)
  - Botão "Pagar" habilitado quando plano selecionado → abre Stripe Payment Link via `url_launcher`
  - `launchUrl()` com `LaunchMode.externalApplication`

---

### Fase 7 — Routing e DI

- [ ] **20. Atualizar `AppRoutes`** em `lib/config/routes/app_routes.dart`
  - Adicionar: `login = '/login'`, `register = '/register'`, `account = '/account'`, `plans = '/plans'`
- [ ] **21. Atualizar `AppRouter`** em `lib/config/routes/app_router.dart`
  - Adicionar 4 novas GoRoutes
  - `redirect` guard: não autenticado tentando acessar `/account` ou `/plans` → redireciona para `/login`
- [ ] **22. Atualizar `AppInjector`** em `lib/config/inject/app_injector.dart`
  - `registerLazySingleton`: `AuthService`, `UserFirestoreDatasource`, `UserRepository` → `UserRepositoryImpl`
  - `registerFactory`: `AuthCubit`, `AccountCubit`, `PlansCubit`
  - Ordem: services → datasources → repositories → cubits

---

### Fase 8 — Landing Page e i18n

- [ ] **23. Atualizar `HeroSection`** em `lib/presentation/landing/widgets/hero_section.dart`
  - Adicionar botão "Obter Licença" ao lado do botão Download
  - Ao tap: `context.push(AppRoutes.login)`
- [ ] **24. Atualizar arquivos de i18n** em `lib/l10n/arb/app_en.arb` + `app_pt.arb`
  - Auth: `getLicenseButton`, `loginTitle`, `registerTitle`, `emailLabel`, `passwordLabel`, `confirmPasswordLabel`, `loginButton`, `registerButton`, `noAccountYet`, `alreadyHaveAccount`
  - Account: `accountTitle`, `licenseStatusLabel`, `licenseActiveStatus`, `licenseInactiveStatus`, `licenseExpiredStatus`, `licenseExpiresAtLabel`, `selectPlanButton`, `logoutButton`
  - Plans: `plansTitle`, `plan3MonthsTitle`, `plan1YearTitle`, `plan3MonthsPrice`, `plan1YearPrice`, `payButton`
  - Erros: `authErrorInvalidEmail`, `authErrorWeakPassword`, `authErrorEmailInUse`, `authErrorWrongPassword`, `authErrorUserNotFound`, `authErrorGeneric`

---

## Arquivos Afetados

### Modificar (8 arquivos)

| Arquivo | Mudança |
|---|---|
| `pubspec.yaml` | Adicionar `firebase_auth` |
| `firestore.rules` | Regras para coleção `users` |
| `lib/config/routes/app_routes.dart` | 4 novas constantes de rota |
| `lib/config/routes/app_router.dart` | 4 GoRoutes + redirect guard |
| `lib/config/inject/app_injector.dart` | 6 novos registros |
| `lib/presentation/landing/widgets/hero_section.dart` | Botão "Obter Licença" |
| `lib/l10n/arb/app_en.arb` | ~30 novas chaves |
| `lib/l10n/arb/app_pt.arb` | ~30 novas chaves (PT) |

### Criar (17 arquivos)

```
lib/
├── common/services/
│   └── auth_service.dart
├── domain/
│   ├── entities/user_entity.dart
│   └── interfaces/user_repository.dart
├── data/
│   ├── models/user_model.dart
│   ├── datasources/user_firestore_datasource.dart
│   └── repositories/user_repository_impl.dart
└── presentation/
    ├── auth/
    │   ├── view_model/
    │   │   ├── auth_state.dart
    │   │   └── auth_cubit.dart
    │   └── view/
    │       ├── login_view.dart
    │       └── register_view.dart
    ├── account/
    │   ├── view_model/
    │   │   ├── account_state.dart
    │   │   └── account_cubit.dart
    │   └── view/
    │       └── account_view.dart
    └── plans/
        ├── view_model/
        │   ├── plans_state.dart
        │   └── plans_cubit.dart
        ├── view/
        │   └── plans_view.dart
        └── widgets/
            └── plan_card.dart
```

---

## Checklist de Verificação

- [ ] `flutter pub get` — sem erros de dependência
- [ ] `flutter analyze` — sem erros de lint
- [ ] `flutter gen-l10n` — gera localizações sem erros
- [ ] `flutter run -d chrome --flavor development -t lib/main_development.dart` — app abre
- [ ] Landing page → "Obter Licença" → tela de login renderiza
- [ ] Cadastro → cria usuário no Firebase Auth + doc no Firestore (verificar no Console)
- [ ] Login → navega para tela de conta com dados do usuário
- [ ] Conta → "Selecionar Plano" → tela de planos → selecionar card → "Pagar" abre Stripe em nova aba
- [ ] Logout → retorna para landing page
- [ ] Navegar para `/account` sem autenticação → redireciona para `/login`
- [ ] Firebase Console: verificar doc criado com campos corretos

---

## Considerações Futuras

1. **URLs do Stripe**: Os Payment Links precisam ser configurados no Stripe Dashboard. Recomendado criar um arquivo de constantes ou usar Firestore Remote Config para armazenar as URLs
2. **Resetar senha**: Fora do escopo agora, mas passo natural seguinte — link "Esqueci minha senha" na tela de login
3. **Persistência de Auth**: Firebase Auth SDK persiste automaticamente no web (localStorage) — sem necessidade de armazenamento manual de tokens
4. **Webhook Stripe**: Para automação futura, criar Cloud Function que ouve eventos `checkout.session.completed` e atualiza `license_status` + `license_expires_at` no Firestore
