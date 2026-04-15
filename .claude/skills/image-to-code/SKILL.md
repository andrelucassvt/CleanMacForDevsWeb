---
name: image-to-code
description: "Converts a reference image (screenshot, mockup, or design file) into Flutter code that faithfully replicates the visual. Use whenever the user attaches an image and asks to replicate, implement, or convert a design — even with phrases like 'implement this screen', 'build this UI', 'convert this mockup to Flutter', 'make it look like this', 'match this design', 'here is the reference image', 'analyze the attached image', 'analyze this image', 'implement according to the image', 'use this image as reference', 'here is the image', 'see the attached image', or 'implement from this image'. Always activate when an image is the primary input for a UI task. The skill inspects the project's design system (theme, tokens, colors, typography) before writing any code, then analyzes the image systematically before coding — it does NOT guess, correct, or upgrade the design."
argument-hint: "Attach the reference image and describe any constraints (e.g., 'this is a card widget', 'full screen', 'only the bottom bar')."
---

# Image-to-Code — Flutter

Skill especializada em converter imagens de referência (mockups, screenshots, protótipos) em código Flutter fiel ao visual, respeitando o design system existente do projeto.

> **Princípio central**: o código deve espelhar o que está na imagem — não o que parece "melhor" ou "mais correto". Quaisquer diferenças devem ser reportadas explicitamente.

---

## Fase 1 — Inspecionar o Design System do Projeto

Antes de qualquer análise da imagem, leia o que o projeto já define. Isso evita reinventar tokens que já existem.

### O que procurar e onde

```
lib/
├── common/styles/          # Tema principal, cores, tipografia
│   ├── app_theme.dart
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   └── app_spacing.dart (ou similar)
├── config/
│   └── app_initializer.dart  # pode referenciar o tema
└── l10n/                   # strings — use as chaves existentes
```

**Execute estas leituras antes de avançar:**

1. Glob `lib/common/styles/**` — listar arquivos de estilo
2. Glob `lib/**/theme*.dart` e `lib/**/*colors*.dart` — encontrar tokens de cor
3. Glob `lib/**/*text_style*.dart` ou `lib/**/*typography*.dart` — encontrar estilos de texto
4. Se houver arquivo de design tokens (ex: `app_spacing.dart`, `app_radius.dart`) — lê-los

**Construa um mapa mental:**

| Token | Valor | Uso no projeto |
|---|---|---|
| `AppColors.primary` | `#FF5733` | Botões primários |
| `AppTextStyles.heading1` | 24px, bold | Títulos de tela |
| Spacing padrão | 8, 16, 24, 32 | Padding/margin |
| Border radius padrão | 8 ou 12 | Cards, botões |

Se o projeto **não tiver** design system formal, registre isso e use valores literais (`const Color(0xFF...)`, `const TextStyle(fontSize: ...)`) extraídos diretamente da imagem.

---

## Fase 2 — Análise Sistemática da Imagem

Analise a imagem **antes de escrever uma linha de código**. Documente cada dimensão abaixo.

### 2.1 — Layout e Estrutura

- Qual é o tipo de tela? (tela cheia, card, modal, bottom sheet, list item, etc.)
- Existe AppBar/header? Qual o conteúdo?
- Como os elementos se organizam? (Column, Row, Stack, Grid, ListView)
- Há seções distintas? (header, body, footer)
- Existe padding externo visível? Estime em múltiplos de 8.
- Há ScrollView? ListView? SingleChildScrollView?

### 2.2 — Cores

Para **cada cor visível**, registre:

| Elemento | Cor aproximada (hex) | Token do projeto? |
|---|---|---|
| Background | `#F5F5F5` | `AppColors.background` ✅ |
| Botão primário | `#FF5733` | `AppColors.primary` ✅ |
| Texto principal | `#1A1A1A` | Literal (sem token) |

Não invente nomes. Se a cor da imagem não corresponde a nenhum token, use o valor literal.

### 2.3 — Tipografia

Para **cada bloco de texto**, registre:

| Elemento | Tamanho estimado | Peso | Cor | Token? |
|---|---|---|---|---|
| Título | ~24px | bold (700) | #1A1A1A | `AppTextStyles.heading1`? |
| Subtítulo | ~14px | regular (400) | #666666 | Literal |
| Label botão | ~16px | semibold (600) | #FFFFFF | Literal |

### 2.4 — Espaçamentos

- Padding horizontal externo: ___px
- Espaço entre elementos verticais: ___px
- Padding interno de cards/botões: ___px
- Espaço entre ícone e texto: ___px

Arredonde para o grid de 8 mais próximo. Prefira tokens de spacing do projeto se existirem.

### 2.5 — Componentes Identificados

Liste cada componente visível:

```
[ ] AppBar com título + ícone de voltar
[ ] Card com sombra (elevation ~4)
[ ] Avatar circular (raio ~24px)
[ ] Botão primário arredondado
[ ] Campo de texto com border outlined
[ ] Ícone (identificar qual — ex: Settings, chevron_right)
[ ] Divider entre itens
[ ] Badge/chip
[ ] Imagem/thumbnail
```

Para cada componente, decida: usar **widget padrão do Flutter** ou **widget existente do projeto** (`common/widgets/`)?

### 2.6 — Interatividade Visível

- Quais elementos parecem clicáveis? (botões, cards, list items)
- Há estados visíveis? (selecionado, disabled, loading)
- Há campos de entrada? (TextField, dropdown)

---

## Fase 3 — Mapeamento: Imagem → Código

Antes de implementar, monte o plano:

```
Imagem mostra tela inteira?
  ├── SIM → criar View completa (implement-view)
  │         + Cubit + State + rota + DI
  └── NÃO → criar Widget isolado (implement-widget)
              ├── Reutilizável entre features? → common/widgets/
              ├── Específico de uma feature? → presentation/<feature>/widgets/
              └── Auxiliar de uma View específica? → presentation/<feature>/content/
```

Componentes complexos da imagem (ex: card com múltiplas seções, lista com itens customizados) → extrair para widgets separados nos diretórios acima.

---

## Fase 4 — Implementação

### Regras de fidelidade visual

1. **Cores**: use exatamente as cores da imagem. Se existe token equivalente, use o token. Se não, use literal `const Color(0xFF...)`. **Nunca substitua** por uma cor "parecida" do tema.

2. **Tipografia**: use os tamanhos e pesos observados. Se existe `TextStyle` equivalente, use. Se não, declare literalmente. **Nunca arredonde** para cima ou troque `FontWeight.w600` por `FontWeight.bold` por conta própria.

3. **Espaçamentos**: use os valores estimados. Prefira múltiplos de 8. **Nunca normalize** espaçamentos por estética própria.

4. **Componentes**: use o widget Flutter mais próximo ao visual. **Nunca substitua** um `OutlinedButton` por `ElevatedButton` por parecer "melhor".

5. **Layout**: replique a estrutura exata (Column, Row, Stack). **Nunca reorganize** para "ficar mais responsivo" sem ser solicitado.

### Regras da arquitetura do projeto

- Imports SEMPRE absolutos: `package:base_app/...`
- Textos visíveis: SEMPRE `context.l10n.<chave>` (verifique se a chave existe; se não existir, registre como diferença)
- View: SEMPRE `SafeArea`; SEMPRE `StatefulWidget`; cubit via `AppInjector`
- Widget: SEMPRE `const` no construtor; `final` em todos os campos
- Sem `Widget _buildXxx()` na View — extraia para `content/` ou `widgets/`

### Estrutura de implementação recomendada

```dart
// 1. Widget folha (mais interno)
class _ItemCard extends StatelessWidget { ... }

// 2. Seção/conteúdo auxiliar
class _BodyContent extends StatelessWidget { ... }
// → salvo em content/<feature>_body_content.dart

// 3. View (se tela inteira)
class FeatureView extends StatefulWidget { ... }
```

---

## Fase 5 — Relatório de Fidelidade

Ao final da implementação, inclua **sempre** este relatório:

```
## Relatório de Fidelidade Visual

### ✅ Replicado com precisão
- [lista o que foi implementado exatamente como na imagem]

### ⚠️ Diferenças e motivos
| O que diferiu | Por que diferiu |
|---|---|
| Fonte não identificada → usando padrão do sistema | Família tipográfica não especificada na imagem |
| Imagem de avatar → usando placeholder | Não há asset real no projeto |
| Chave de i18n inexistente → string literal temporária | `l10n.profileTitle` não existe; registrar para adição futura |
| Sombra estimada (elevation 4) | Valor exato não mensurável em screenshot |

### ℹ️ Decisões tomadas
- [explique escolhas onde havia ambiguidade]
```

Se não houver diferenças, diga explicitamente: "Nenhuma diferença identificada — implementação fiel ao visual."

---

## Checklist de Execução

- [ ] Fase 1: design system inspecionado (colors, text styles, spacing)
- [ ] Fase 2: imagem analisada (layout, cores, tipografia, componentes)
- [ ] Fase 3: plano de mapeamento definido (tela inteira vs widget isolado)
- [ ] Fase 4: código implementado seguindo arquitetura do projeto
- [ ] Fase 5: relatório de fidelidade incluído na resposta

---

## Erros a Evitar

| Erro | Correto |
|---|---|
| Usar `AppColors.primary` quando a cor da imagem é diferente | Usar literal `const Color(0xFF...)` ou registrar divergência |
| Trocar `OutlinedButton` por `ElevatedButton` "por ser mais moderno" | Usar o componente que corresponde visualmente à imagem |
| Escrever `Text('Título')` hardcoded | `Text(context.l10n.featureTitle)` — ou registrar a chave como pendente |
| Omitir `SafeArea` em tela cheia | Sempre envolver o corpo principal com `SafeArea` |
| Criar `Widget _buildHeader()` na View | Extrair para `content/feature_header.dart` |
| Reorganizar layout "para ficar mais responsivo" | Implementar exatamente como está na imagem |

---

**Última atualização**: 13 de abril de 2026
