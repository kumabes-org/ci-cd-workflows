---
name: github-actions-nested-pipeline
description: Cria e audita pipelines GitHub Actions seguindo o padrão Nested Reusable Workflows corporativo (DRY, KISS e OIDC AWS).
triggers: ["/pipeline", "crie o workflow", "gere a action", "configure ci/cd"]
tools_required: ["workspace", "edit"]
---

# Skill: Nested Reusable Workflows (GitHub Actions)

Você é um Especialista em DevOps e CI/CD. Ao gerar ou refatorar workflows de GitHub Actions para este repositório, você deve seguir estritamente as regras de arquitetura abaixo.

## Premissas Inegociáveis
1. **KISS no Consumidor:** O arquivo de workflow da aplicação consumidora (`.github/workflows/*.yaml`) deve ter no máximo 20 linhas e apenas chamar o entrypoint correspondente (`entrypoint-{java|python|golang|frontend}.yaml@v1`).
2. **DRY nos Reusables:** Toda lógica compartilhada (OIDC AWS com `configure-aws-credentials`, build de imagem Docker/ECR, login em Kubernetes/Helm) deve residir nos workflows de engine (`engine-*.yaml`).
3. **Autenticação Segura:** Jamais use `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`. Utilize sempre OIDC com IAM Roles assumidas via `permissions: id-token: write`.

## Tabela de Mapeamento Linguagem x Destino

| Linguagem | Destinos Suportados (`target-platform`) | Entrypoint |
| :--- | :--- | :--- |
| **Java** | `ecs`, `eks` | `entrypoint-java.yaml` |
| **Golang** | `ecs`, `eks`, `lambda` | `entrypoint-golang.yaml` |
| **Python** | `ecs`, `eks`, `lambda`, `glue` | `entrypoint-python.yaml` |
| **Node.js (React/TS)** | `s3-cloudfront`, `ecs` | `entrypoint-frontend.yaml` |

## Checklist de Geração
- [ ] O workflow consumidor usa `uses: .../entrypoint-*.yaml@v1`?
- [ ] O `target-platform` correto foi informado (`ecs`, `eks`, `lambda`, `glue`)?
- [ ] As credenciais AWS foram passadas via OIDC Secret (`aws-role-arn`)?
- [ ] O versionamento do reusable workflow aponta para tag estável (`@v1`) ou commit SHA, nunca `@main`?