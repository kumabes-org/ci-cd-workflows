# AGENTS.md

## Visão geral do projeto

- **O que é**: Repositório centralizado de workflows reutilizáveis de CI/CD para GitHub Actions.
- **Stack principal**: GitHub Actions.
- **Arquitetura**: Nested Reusable Workflows em três camadas:
  - `entrypoint-*.yaml`: interface de domínio consumida pelos repositórios de aplicações.
  - `engine-*.yaml`: implementação atômica e compartilhada de CI, autenticação, build ou deploy.
  - Workflows auxiliares: `harness.yaml` valida este repositório e `publish-immutable-actions.yaml` atualiza tags de versão principal após releases.
- **Como rodar localmente**: Deploys não podem ser executados localmente, pois dependem do GitHub Actions, OIDC e recursos AWS. A validação deve ocorrer pelo workflow `harness.yaml`.

## Setup & Build

- Não há etapa de build local do projeto.
- Ao alterar workflows, valide as mudanças por meio do `harness.yaml`, que executa `yamllint`, `actionlint`, testes dos scripts inline e testes de integração dos entrypoints de Terraform e Python.
- Não crie credenciais AWS locais nem tente substituir OIDC por chaves estáticas para facilitar testes.

## Tests

- O workflow de validação é [`.github/workflows/harness.yaml`](.github/workflows/harness.yaml).
- Alterações em `.github/workflows/**` devem passar pela validação estática e pelos testes aplicáveis do harness.
- Os testes de aplicação de exemplo ficam em `validate-python-lambda-workflow/`; a infraestrutura de exemplo fica em `validate-terraform-workflow/`.
- Mudanças em scripts Bash, JQ ou parsing devem incluir ou atualizar uma asserção no harness quando o comportamento for coberto por ele.
- Não considere um deploy real como teste local. Use os ambientes e permissões configurados no GitHub Actions.

## Regras do projeto

- Siga o padrão DRY: lógica compartilhada deve ficar em `engine-*.yaml`, não duplicada nos entrypoints.
- Mantenha os consumidores simples: até 20 linhas e apenas a chamada ao entrypoint adequado. Em repositórios consumidores, use referências estáveis como `@v1`; nunca use `@main`.
- Use `workflow_call` nos workflows reutilizáveis e declare todos os inputs com `description`, `required`, `type` e `default` quando aplicável.
- Prefira tipos estritos (`string`, `boolean` e `number`) e nomes em kebab-case para arquivos e inputs.
- Declare outputs no `workflow_call` quando um job produzir valores usados por outro workflow, como a URI de uma imagem ECR.
- Preserve o roteamento por `target-platform` nos entrypoints e não mova lógica de engine para o consumidor.
- Ao refatorar, priorize mudanças cirúrgicas; refatorações relacionadas são aceitáveis quando melhorarem DRY ou KISS sem alterar o contrato existente.
- Atualize a documentação diretamente relacionada quando a interface, o comportamento ou a forma de consumo de um workflow mudar.
- Use mensagens de commit no padrão Conventional Commits.

## Skills disponíveis

- A skill [`github-actions-nested-pipeline`](.agents/skills/github-actions-nested-pipeline/SKILL.md) deve ser usada para criar, auditar ou refatorar pipelines seguindo o padrão nested, DRY, KISS e OIDC.
- A skill [`spec-driven-build`](.agents/skills/spec-driven-build/SKILL.md) deve ser usada para criar especificações de funcionalidades em Português do Brasil, com histórias priorizadas, cenários de aceite, requisitos verificáveis e critérios de sucesso mensuráveis.
- Antes de criar um novo workflow, procure um entrypoint ou engine existente que possa ser reutilizado.
- Ao adicionar uma nova linguagem ou destino, atualize o mapeamento da skill e a documentação relacionada.

## Integrações (MCP)

- Use integrações GitHub para consultar workflows, execuções, issues e pull requests quando a tarefa depender do estado remoto do repositório.
- Use ferramentas de Git apenas para operações solicitadas e não descarte alterações locais existentes.
- A ausência de execução local de GitHub Actions não deve ser ocultada: relate claramente quando a validação depender de uma execução remota.

## Princípios de segurança

- Nunca use `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` ou outras credenciais AWS estáticas.
- Toda operação AWS deve usar OIDC com IAM Role assumida por `aws-actions/configure-aws-credentials@v6`.
- Jobs que solicitam OIDC devem declarar `permissions: id-token: write`; mantenha também `contents: read` apenas quando necessário.
- Passe a role por Secret, sem imprimir ARNs sensíveis, tokens ou variáveis confidenciais nos logs.
- Aplique menor privilégio: não conceda `contents: write` globalmente quando somente um job precisar publicar tags.
- Ao publicar versões, preserve tags específicas da release e altere a tag principal (`v1`) somente pelo workflow de publicação aprovado.
- Use actions e workflows de terceiros com versões estáveis (`@vN`) ou SHA completo; não introduza referências a branches mutáveis.

## Diretório adicional

- `.github/workflows/`: entrypoints, engines, harness e automações de release.
- `.github/skills/`: skills específicas do repositório para orientar a criação de pipelines.
- `validate-python-lambda-workflow/`: aplicação e testes usados para validar o fluxo Python/Lambda.
- `validate-terraform-workflow/`: infraestrutura Terraform usada para validar o fluxo Terraform.
- `scripts/`: scripts auxiliares relacionados ao projeto.
