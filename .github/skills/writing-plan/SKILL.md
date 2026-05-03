---
name: writing-plan
description: Generates a structured Markdown implementation plan and saves it to the /plan folder. Use this skill whenever the user asks to "create a plan", "write a plan", "make a plan", "plan this feature", "draft a plan for", "gerar um plano", "criar um plano", "escrever um plano", or describes any multi-step task they want planned out — even if they just say "plan this" or "how should I approach X". Also triggers when the user shares a feature description, refactoring goal, or implementation request and wants a roadmap before coding. Always prefer this skill over ad-hoc bullet lists when the user wants a reusable, saveable plan document.
---

# Writing Plan

## O que esta skill faz

Gera um plano estruturado em Markdown e salva em `./plan/<nome-do-plano>.md` (cria a pasta se não existir).

O plano segue o padrão das melhores práticas de planejamento de software: objetivo claro, fases com checkboxes, passos acionáveis, verificações e critérios de sucesso.

---

## Fluxo de Execução

### 1. Entender o contexto

Antes de escrever o plano, responda mentalmente:

- **O que** precisa ser feito? (feature, refactor, fix, investigação, deploy)
- **Por quê?** Qual problema resolve?
- **Quais arquivos/sistemas** estão envolvidos?
- **Qual o critério de conclusão?** Como saber que está pronto?

Se o prompt for vago, faça **uma única pergunta de clarificação** antes de prosseguir. Não faça múltiplas perguntas — escolha a mais importante.

### 2. Escolher o nome do arquivo

Derive um `kebab-case` conciso do objetivo. Exemplos:
- "plano para tela de login" → `login-screen.md`
- "refatorar repositório de usuário" → `refactor-user-repository.md`
- "implementar push notifications" → `implement-push-notifications.md`

### 3. Criar a pasta e o arquivo

```bash
mkdir -p ./plan
# salvar em ./plan/<nome>.md
```

### 4. Escrever o plano usando a estrutura abaixo

---

## Estrutura do Plano (template obrigatório)

```markdown
# [Título do Plano]

> **Objetivo:** Uma frase descrevendo o que será entregue ao final.

## Contexto

[2–4 frases explicando o estado atual, o problema ou a motivação. Por que isso precisa ser feito agora?]

## Arquitetura / Escopo

[Diagrama textual ou tabela mapeando os arquivos/módulos afetados e suas responsabilidades. Inclua apenas o que muda ou é criado.]

| Arquivo | Ação | Responsabilidade |
|---------|------|-----------------|
| `lib/...` | criar | ... |

## Fases

### Fase 1 — [Nome da Fase]

- [ ] Passo 1: [ação concreta com arquivo e função]
- [ ] Passo 2: ...
- [ ] Verificação: [como confirmar que a fase está completa]

### Fase 2 — [Nome da Fase]

- [ ] ...
- [ ] Verificação: ...

_(repita para cada fase)_

## Critérios de Sucesso

- [ ] [resultado observável 1]
- [ ] [resultado observável 2]
- [ ] Testes passando / build sem erros

## Riscos e Mitigações

| Risco | Probabilidade | Mitigação |
|-------|--------------|-----------|
| ... | Baixa/Média/Alta | ... |

## Rollback

[Como desfazer as mudanças se algo der errado. Se não aplicável, escreva "N/A".]
```

---

## Regras de Qualidade

**Passos acionáveis** — cada item de checkbox deve ser específico o suficiente para ser executado sem ambiguidade. Ruim: "adicionar validação". Bom: "adicionar validação de email em `lib/presentation/login/widgets/email_field.dart`".

**Sem placeholders vagos** — nunca escreva "TBD", "ver depois", "adicionar lógica aqui". Se não souber, diga explicitamente o que precisa ser investigado e por quê.

**Fases sequenciais e seguras** — ordene para que cada fase possa ser concluída e verificada antes da próxima começar. Mudanças de tipos/interfaces vêm antes de implementações.

**Tamanho das fases** — idealmente 3–7 passos por fase. Se uma fase ficar grande, divida.

**Seção de riscos não é opcional para planos com 3+ fases** — qualquer plano não trivial deve listar pelo menos um risco real.

---

## Após salvar o arquivo

Informe o usuário:
1. O caminho do arquivo gerado (ex: `./plan/login-screen.md`)
2. Um resumo de 2–3 linhas do plano (quantas fases, escopo geral)
3. Pergunte se quer ajustar algo antes de começar a execução

Não execute o plano automaticamente — a decisão de começar é do usuário.
