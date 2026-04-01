---
agent: agent
description: Analisa este projeto Flutter e gera CLAUDE.md, AGENTS.md e copilot-instructions.md personalizados com base na arquitetura real do projeto.
---

Você é um agente especialista em Flutter/Dart. Sua tarefa é **analisar este projeto** e gerar arquivos de contexto de IA personalizados para ele.

## Passo 1 — Explorar o projeto

Faça uma varredura completa do projeto para identificar:

- **Nome do projeto**: leia `pubspec.yaml` (campo `name`)
- **Versão do Flutter / Dart SDK**: leia `pubspec.yaml` (campo `environment`)
- **Plataformas suportadas**: verifique as pastas `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`
- **iOS deployment target**: leia `ios/Podfile` ou `ios/Runner.xcodeproj/project.pbxproj`
- **Android minSdkVersion**: leia `android/app/build.gradle`
- **Flavors configurados**: verifique `main_development.dart`, `main_staging.dart`, `main_production.dart` ou configurações similares
- **Estrutura de pastas em `lib/`**: mapeie os diretórios principais com suas responsabilidades reais
- **Arquitetura usada**: Clean Architecture, Feature-first, MVVM, etc. — baseie-se nos arquivos existentes
- **State management**: BLoC/Cubit, Riverpod, Provider, GetX, etc.
- **DI**: GetIt, Injectable, Riverpod, etc.
- **Navegação**: GoRouter, AutoRoute, Navigator 2.0, etc.
- **Dependências externas**: leia `pubspec.yaml` (seções `dependencies` e `dev_dependencies`)
- **Scripts disponíveis**: verifique `Makefile`, `scripts/`, ou scripts em `pubspec.yaml`
- **Skills disponíveis**: liste as skills em `.github/skills/` (ou `.claude/skills/` ou `.agents/skills/`)

## Passo 2 — Gerar os arquivos

Com base na análise, reescreva os três arquivos abaixo. **Não copie o conteúdo genérico do template** — escreva informações reais e específicas deste projeto.

### Regras fixas (manter em todos os arquivos):
- Manter a seção de **Skills Disponíveis** referenciando as skills encontradas no projeto
- Não mencionar o repositório `instructions-ia` nem o script `sync-instructions.sh`
- Escrever em **Português Brasileiro**
- Ser direto e conciso — evitar texto genérico ou de template

---

### Arquivo 1: `CLAUDE.md` (raiz do projeto)

Estrutura obrigatória:

```
# CLAUDE.md

## Sobre Este Projeto
[Nome, descrição curta, Flutter/Dart version, plataformas suportadas, iOS target, Android minSdk]

## Estrutura do Projeto
[Árvore real de lib/ com uma linha de descrição por pasta]

## Arquitetura
[Padrão usado, state management, DI, navegação — convenções específicas deste projeto]

## Comandos Úteis
[Comandos de build, test, lint, run por flavor — apenas os que existirem no projeto]

## Convenções de Nomenclatura
[Específicas deste projeto]

## Dependências Externas
[Pacotes reais do pubspec.yaml separados por categoria: State Management, DI, Network, etc.]

## Skills Disponíveis
[Lista de skills encontradas com nome e descrição de uma linha]
```

---

### Arquivo 2: `AGENTS.md` (raiz do projeto)

Estrutura obrigatória:

```
# AGENTS.md

## Sobre Este Projeto
[Nome, descrição, Flutter/Dart version, plataformas — igual ao CLAUDE.md]

## Estrutura do Projeto
[Mesma árvore do CLAUDE.md]

## Arquitetura: [Nome do padrão] — Flutter
[Regras mandatórias específicas deste projeto — baseadas no que o agente encontrou, não no template]

## Convenções de Nomenclatura
[Específicas deste projeto]

## Skills
[Tabela: Skill | Quando usar — baseada nas skills encontradas]
```

---

### Arquivo 3: `.github/copilot-instructions.md`

Estrutura obrigatória:

```
# Copilot Instructions

## Contexto
[Nome do projeto, Flutter/Dart version, plataformas, iOS target, Android minSdk]

## Arquitetura: [padrão] — Flutter

### Regras Obrigatórias
[Regras reais do projeto — não genéricas]

### Compatibilidade de Plataformas
[Tabela: Plataforma | Status | Observações — baseada nas plataformas reais do projeto]

### Convenções de Nomenclatura
[Específicas do projeto]

### Princípios
[Baseados no que o projeto já usa]

### Estrutura de Pastas
[Árvore real de lib/]

## Skills Disponíveis
[Lista das skills encontradas]
```

---

## Passo 3 — Escrever os arquivos

Após gerar o conteúdo, **escreva os três arquivos** no projeto:
- `CLAUDE.md`
- `AGENTS.md`
- `.github/copilot-instructions.md`

Confirme ao final quais arquivos foram escritos e faça um resumo de 2-3 linhas do que foi descoberto sobre o projeto.
