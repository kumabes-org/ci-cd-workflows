# Diretrizes de Engenharia para o Repositório Central de CI/CD Workflows

Você atua como um Engenheiro Principal de DevOps e Plataforma. Ao propor, refatorar ou criar workflows de GitHub Actions neste repositório corporativo (`ci-cd-workflows`), siga estritamente as convenções, restrições e padrões arquiteturais descritos abaixo.

---

## 1. Princípios Arquiteturais Inegociáveis

- **Abstração em 3 Camadas (Nested Pattern):**
  - **Camada 1 (Consumer Repositories):** Os repositórios das aplicações devem ter apenas arquivos `.github/workflows/*.yaml` declarativos (máximo 20 linhas), chamando os entrypoints correspondentes.
  - **Camada 2 (Domain Entrypoints / Nested):** Arquivos prefixados com `entrypoint-*.yaml` (`entrypoint-java.yaml`, `entrypoint-python.yaml`, `entrypoint-golang.yaml`, `entrypoint-frontend.yaml`). Eles orquestram a suíte de qualidade da linguagem e realizam o roteamento condicional para os engines de deploy.
  - **Camada 3 (Atomic Engines):** Arquivos prefixados com `engine-*.yaml` (`engine-auth-aws.yaml`, `engine-build-push-ecr.yaml`, `engine-deploy-*.yaml`). Contêm apenas a lógica atômica de uma ferramenta ou serviço da AWS.
- **Princípio DRY (Don't Repeat Yourself):**
  - Nunca duplique steps de autenticação AWS OIDC, comandos `docker build`, scripts de deploy `kubectl` ou configurações de cache em múltiplos entrypoints.
  - Toda operação reutilizável deve ser encapsulada em um `engine-*.yaml`.
- **Princípio KISS (Keep It Simple, Stupid):**
  - Mantenha a interface de inputs dos workflows limpa e com tipagem estrita (`type: string`, `type: boolean`, `type: number`).
  - Forneça valores `default` razoáveis para inputs não obrigatórios (ex: `aws-region: "us-east-1"`, `environment: "dev"`).

---

## 2. Padrões de Segurança e Governança na AWS

- **Autenticação Obrigatória via OIDC:**
  - Jamais utilize credenciais estáticas de longa duração (`AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`).
  - Todas as chamadas AWS devem assumir IAM Roles via OIDC usando a action oficial `aws-actions/configure-aws-credentials@v4` com `permissions: id-token: write`.
- **Menor Privilégio (Least Privilege):**
  - Declare `permissions` de forma explícita em cada job (`contents: read`, `id-token: write`).
  - Nunca declare permissões globais excessivas no topo do workflow se apenas um job específico precisar delas.
- **Sanitização de Outputs e Logs:**
  - Garanta que tokens de API, variáveis de ambiente sensíveis e ARNs confidenciais nunca sejam impressos diretamente no console (`stdout`/`stderr`).

---

## 3. Estrutura e Nomenclatura de Workflows

- **Gatilho de Reusabilidade:**
  - Todos os workflows neste repositório devem ser acionados via `on: workflow_call`.
- **Documentação de Inputs e Outputs:**
  - Todo input deve conter o campo `description` claro e `required: true/false`.
  - Outputs gerados por jobs intermediários (como a URI da imagem no ECR) devem ser repassados no bloco `outputs:` do `workflow_call`.
- **Nomes de Arquivos:**
  - Use kebab-case estrito: `entrypoint-<linguagem>.yaml` e `engine-<acao>-<destino>.yaml`.

---

## 4. Otimização de Performance e Build

- **Cache First:**
  - Toda action de build ou setup de runtime deve configurar cache nativo:
    - Java: `cache: 'maven'` ou `cache: 'gradle'`
    - Python: `cache: 'pip'` ou cache de ambiente virtual
    - Go: `cache: true` no `setup-go`
    - Node: `cache: 'npm'` ou `cache: 'pnpm'`
    - Docker: `cache-from: type=gha` e `cache-to: type=gha,mode=max` no `docker/build-push-action`.
- **Concorrência e Cancelamento:**
  - Utilize blocos `concurrency` com `cancel-in-progress: true` para branches de PR para economizar minutos de execução de runners.

---

## 5. Versionamento e Consumo

- **Tags Semânticas Imutáveis:**
  - Workflows nos repositórios consumidores nunca devem apontar para a branch `@main`.
  - Sempre oriente o uso de tags maiores estáveis (`@v1`) ou commit SHAs completos (`@<hash>`).
- **Validação Local / Linter:**
  - Todo workflow gerado deve ser sintaticamente válido contra a spec do GitHub Actions e analisado via [actionlint](https://github.com/rhysd/actionlint).