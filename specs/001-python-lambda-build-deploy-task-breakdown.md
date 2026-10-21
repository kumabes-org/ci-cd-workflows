# Task Breakdown: Python Lambda Build, Teste, Empacotamento e Deploy

**Especificação relacionada**: [001-python-lambda-build-deploy.md](./001-python-lambda-build-deploy.md)

**Status**: Aguardando aprovação

**Objetivo**: acompanhar a implementação do microsserviço Python em Arquitetura Hexagonal e dos workflows Nested de CI/CD para validação, segurança, empacotamento e deploy em AWS Lambda.

## Legenda

- `[ ]` Pendente
- `[-]` Em andamento
- `[x]` Concluído
- `[!]` Bloqueado ou dependente de esclarecimento

## Dependências e decisões pendentes

- [!] Confirmar nome da função Lambda, região AWS e formato de configuração.
- [!] Confirmar a política de concorrência para atualizações do ambiente `dev`.
- [!] Confirmar limite e estratégia para ZIPs que excederem o upload direto, incluindo eventual uso de S3.
- [!] Confirmar se haverá gatilho da Lambda nesta entrega.
- [!] Definir a integração externa que justificará os testes com Testcontainers; caso não exista, registrar a não adoção.
- [ ] Confirmar a IAM Role de deploy e suas permissões mínimas.

## Fase 0 — Contratos e escopo

- [ ] 0.1 Consolidar os parâmetros do deploy: função, ambiente, região, Role e concorrência.
- [ ] 0.2 Definir o contrato de entrada e saída do handler Lambda.
- [ ] 0.3 Definir comportamento para entradas inválidas e falhas externas.
- [ ] 0.4 Definir a estratégia de testes de integração com Testcontainers.

**Critério de saída**: decisões pendentes resolvidas ou explicitamente registradas como fora do escopo.

## Fase 1 — Arquitetura Hexagonal do microsserviço

- [ ] 1.1 Definir a estrutura de módulos de domínio, aplicação, portas e adaptadores.
- [ ] 1.2 Implementar entidades, objetos de valor, regras e exceções de domínio.
- [ ] 1.3 Definir portas de entrada e saída usando contratos orientados ao negócio.
- [ ] 1.4 Implementar os casos de uso sem dependência direta de AWS.
- [ ] 1.5 Implementar adaptadores de saída para as integrações necessárias.
- [ ] 1.6 Implementar o adaptador de entrada Lambda.
- [ ] 1.7 Implementar a composição das dependências e do handler.

**Critério de saída**: o microsserviço executa o fluxo principal sem acoplamento da regra de negócio ao runtime Lambda ou à infraestrutura.

## Fase 2 — Testes do microsserviço

- [ ] 2.1 Criar testes unitários do domínio.
- [ ] 2.2 Criar testes dos casos de uso usando doubles das portas.
- [ ] 2.3 Criar testes do handler para sucesso, validação e falhas.
- [ ] 2.4 Criar testes de integração com Testcontainers, se aplicável.
- [ ] 2.5 Validar a importação do handler e das dependências no diretório empacotado.
- [ ] 2.6 Separar dependências de runtime e de teste.

**Critério de saída**: os cenários funcionais e de erro da especificação possuem cobertura automatizada apropriada.

## Fase 3 — Workflows Nested de CI/CD

- [ ] 3.1 Auditar o contrato de [entrypoint-python.yaml](../.github/workflows/entrypoint-python.yaml) e os engines reutilizáveis.
- [ ] 3.2 Definir ou ajustar os inputs públicos do entrypoint Python.
- [ ] 3.3 Separar jobs de qualidade, testes unitários, integração, segurança, empacotamento e deploy.
- [ ] 3.4 Implementar ou ajustar o engine de CI Python com Python 3.12, Ruff e pytest.
- [ ] 3.5 Implementar ou ajustar o engine de empacotamento ZIP.
- [ ] 3.6 Publicar o ZIP como artefato identificado por commit e execução.
- [ ] 3.7 Ajustar [engine-deploy-lambda.yaml](../.github/workflows/engine-deploy-lambda.yaml) para executar o deploy ZIP real.
- [ ] 3.8 Garantir autenticação AWS exclusivamente por OIDC e IAM Role.
- [ ] 3.9 Definir concorrência, reexecução e idempotência do deploy.

**Critério de saída**: o deploy só é elegível após a aprovação de todos os gates anteriores.

## Fase 4 — Aplicação de validação

- [ ] 4.1 Adaptar [validate-python-lambda-workflow/app](../validate-python-lambda-workflow/app) para a arquitetura definida.
- [ ] 4.2 Adicionar configuração de Ruff, pytest e Python 3.12.
- [ ] 4.3 Atualizar dependências de runtime e de teste.
- [ ] 4.4 Adicionar fixtures ou configurações seguras para o cenário de validação.

**Critério de saída**: a aplicação de validação representa um consumidor realista do workflow Python/Lambda.

## Fase 5 — Harness e validação dos workflows

- [ ] 5.1 Executar yamllint e actionlint nos workflows.
- [ ] 5.2 Adicionar testes de contrato dos inputs e do roteamento do entrypoint.
- [ ] 5.3 Validar criação, conteúdo, integridade e tamanho do ZIP.
- [ ] 5.4 Validar falhas de Ruff, pytest, integração, segurança e empacotamento.
- [ ] 5.5 Validar falha explícita de autenticação OIDC e de atualização da Lambda.
- [ ] 5.6 Validar que o deploy não ocorre após falha em qualquer gate.
- [ ] 5.7 Executar o [harness.yaml](../.github/workflows/harness.yaml) remotamente no GitHub Actions.

**Critério de saída**: o harness fornece evidência da validação estática, contratual, de integração e de deploy.

## Fase 6 — Segurança, rastreabilidade e documentação

- [ ] 6.1 Revisar permissões por job e aplicar menor privilégio.
- [ ] 6.2 Revisar versões ou SHAs das Actions usadas.
- [ ] 6.3 Verificar que logs não exponham tokens, segredos ou valores confidenciais.
- [ ] 6.4 Adicionar análise de vulnerabilidades de dependências e SAST aprovado.
- [ ] 6.5 Documentar inputs, secrets, artefatos, limites e forma de consumo.
- [ ] 6.6 Garantir rastreabilidade por SHA, execução, ambiente, função e artefato.
- [ ] 6.7 Fazer revisão final contra os requisitos RF-001 a RF-017 e CS-001 a CS-006.

**Critério de saída**: documentação e implementação refletem o contrato aprovado e os critérios mensuráveis da especificação.

## Grafo de dependências

```text
Fase 0
  ├── Fase 1 — Arquitetura Hexagonal
  │     └── Fase 2 — Testes do microsserviço
  └── Fase 3 — Workflows Nested
        └── Fase 4 — Aplicação de validação
              └── Fase 5 — Harness e validação remota
                    └── Fase 6 — Segurança, rastreabilidade e documentação
```

As tarefas 2 e 3 podem avançar em paralelo depois que os contratos da Fase 0 forem aprovados. A Fase 4 depende dos contratos do microsserviço e dos workflows. As Fases 5 e 6 dependem da implementação integrada.

## Critérios finais de conclusão

- [ ] O microsserviço está separado entre domínio, aplicação, portas e adaptadores.
- [ ] O handler Lambda possui testes de sucesso, validação e falha.
- [ ] Ruff e pytest bloqueiam o empacotamento quando falham.
- [ ] Testes de integração com Testcontainers estão implementados ou sua não adoção está justificada.
- [ ] A análise de segurança bloqueia condições configuradas como críticas.
- [ ] O ZIP contém o handler e apenas as dependências de runtime necessárias.
- [ ] O ZIP é validado, identificado pelo commit e publicado como artefato.
- [ ] O deploy usa OIDC, IAM Role e permissões mínimas.
- [ ] O deploy falha explicitamente em erros de autenticação ou AWS.
- [ ] A política de concorrência e reexecução está definida.
- [ ] O harness remoto foi executado com sucesso.
- [ ] A documentação foi atualizada e os requisitos da especificação foram revisados.

## Registro de execução

| Data | Tarefa/Fase | Status | Evidência ou observação |
|---|---|---|---|
| 2026-10-21 | Criação do breakdown | Concluído | Plano documentado; implementação ainda não iniciada |
| 2026-10-21 | Aprovação do plano | Pendente | Aguardando aprovação do solicitante |
