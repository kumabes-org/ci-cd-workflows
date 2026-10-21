# ci-cd-workflows

## Nested Workflows
- entrypoint-frontend.yaml
- entrypoint-golang.yaml
- entrypoint-java.yaml
- entrypoint-python.yaml
- entrypoint-rust.yaml
- entrypoint-terraform.yaml

## Reusable Workflows
- engine-auth-aws.yaml
- engine-build-push-ecr.yaml
- engine-cd-terraform.yaml
- engine-ci-rust.yaml
- engine-ci-terraform.yaml
- engine-deploy-ecs.yaml
- engine-deploy-eks.yaml
- engine-deploy-glue.yaml
- engine-deploy-lambda.yaml

## Workflow de validação e testes do próprio repositório de CI/CD.
- harness.yaml

## Workflow do GitHub Actions que mantém uma tag principal, como v1, apontando para a versão mais recente publicada de uma release.
- publish-immutable-actions.yaml


## Resumo da Jornada
|Fase|Ação Principal|O que a IA faz|
|----|----|----|
|1. Spec|Criar o arquivo .specs/feature.md|"Ajuda a estruturar os requisitos, contratos e regras."|
|2. Plano (Próximo Passo)|Pedir o Task Breakdown|Planeja as micro-tarefas e valida o entendimento técnico.|
|3. Testes|Gerar a suíte de testes (TDD)|Escreve os cenários de sucesso e erro antes do código.|
|4. Código|Implementação fatiada (Domínio → Portos → Adaptadores)|Codifica seguindo estritamente o CLAUDE.md.|
|5. Validação|Executar build e testes locais (./mvnw verify)|Valida a robustez e a qualidade do microsserviço.|


```
"Por favor, leia a especificação em @specs\001-python-lambda-build-deploy.md e as diretrizes do @AGENTS.md. Não implemente nenhum código ainda. Em vez disso, crie um Plano de Execução passo a passo (Task Breakdown) que inclua tanto o desenvolvimento do microsserviço (Arquitetura Hexagonal, Domínio, Portos e Adaptadores) quanto a criação e validação dos Workflows do GitHub Actions para CI/CD (ex: build, testes com Testcontainers, análise de qualidade e segurança). Aguarde minha aprovação do plano antes de começarmos a codificar."
```