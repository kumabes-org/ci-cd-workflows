# Especificação de Funcionalidade: Build, Teste, Empacotamento e Deploy de Lambda Python

**Branch da funcionalidade**: `001-python-lambda-build-deploy`

**Criada em**: 2026-10-21

**Status**: Rascunho

**Entrada**: Descrição do usuário: "Gostaria de criar um sdd para o Python e fazer build, test, empacotamento em zip para fazer deploy no AWS Lambda."

## Jornadas do Usuário e Testes *(obrigatório)*

### História de Usuário 1 — Validar a aplicação Python (Prioridade: P1)

Como pessoa responsável pelo desenvolvimento, quero executar as verificações de qualidade da aplicação Python antes do empacotamento, para impedir que código inválido ou testes regressivos chegue ao Lambda.

**Por que esta prioridade**: A validação é o primeiro controle para evitar a publicação de um artefato defeituoso e deve funcionar independentemente do deploy na AWS.

**Teste independente**: Executar o fluxo com uma aplicação Python contendo testes aprovados e falhos, verificando que o primeiro prossegue e o segundo interrompe o fluxo antes da criação ou publicação do artefato.

**Cenários de aceite**:

1. **Dado** um projeto Python compatível com Python 3.12, **quando** o pipeline for executado, **então** o `ruff` e o `pytest` devem ser executados antes do empacotamento.
2. **Dado** que o `ruff` ou o `pytest` falhe, **quando** o pipeline concluir a etapa de qualidade, **então** o pipeline deve falhar e não deve realizar o deploy da função Lambda.
3. **Dado** que o `ruff` e o `pytest` sejam aprovados, **quando** a etapa de qualidade terminar, **então** o pipeline deve permitir a etapa de empacotamento.

---

### História de Usuário 2 — Gerar um artefato ZIP implantável (Prioridade: P1)

Como pessoa responsável pelo desenvolvimento, quero gerar um ZIP contendo o código da aplicação e suas dependências Python, para obter um artefato reproduzível e aceito pelo AWS Lambda.

**Por que esta prioridade**: O ZIP é o artefato necessário para transportar a versão validada da aplicação até o Lambda.

**Teste independente**: Executar o empacotamento com um `requirements.txt` válido e inspecionar o ZIP resultante, verificando a presença do código, do handler e das dependências instaladas.

**Cenários de aceite**:

1. **Dado** um projeto com `requirements.txt`, **quando** a etapa de empacotamento for executada, **então** as dependências devem ser instaladas no diretório do artefato e incluídas no ZIP.
2. **Dado** um projeto com o handler `lambda_function.lambda_handler`, **quando** o ZIP for gerado, **então** o arquivo `lambda_function.py` deve estar disponível na raiz do pacote.
3. **Dado** que a instalação de uma dependência falhe, **quando** o empacotamento for executado, **então** o pipeline deve falhar explicitamente e não deve publicar o ZIP como artefato válido.
4. **Dado** que as etapas de qualidade e empacotamento sejam aprovadas, **quando** o pipeline terminar, **então** deve existir um ZIP identificável pela revisão do código que o originou.

---

### História de Usuário 3 — Atualizar a função Lambda no ambiente de desenvolvimento (Prioridade: P1)

Como pessoa responsável pela operação da aplicação, quero atualizar a função Lambda no ambiente `dev` a partir do ZIP validado, para disponibilizar a nova versão sem utilizar credenciais AWS estáticas.

**Por que esta prioridade**: A entrega do artefato no ambiente de desenvolvimento completa o objetivo do fluxo solicitado e permite validar a integração com a AWS.

**Teste independente**: Executar o pipeline com uma IAM Role autorizada e verificar que a função Lambda de `dev` recebe o ZIP aprovado; executar sem a permissão necessária e verificar uma falha explícita sem simular sucesso.

**Cenários de aceite**:

1. **Dado** um ZIP gerado após `ruff` e `pytest` aprovados, **quando** o pipeline de deploy for executado, **então** a função Lambda do ambiente `dev` deve ser atualizada com esse artefato.
2. **Dado** que o pipeline não consiga assumir a IAM Role via OIDC, **quando** iniciar uma operação AWS, **então** o deploy deve falhar e não deve usar credenciais estáticas como alternativa.
3. **Dado** que a função Lambda de destino não exista ou não possa ser atualizada, **quando** o deploy for executado, **então** o pipeline deve informar o erro e terminar com falha.
4. **Dado** que o deploy seja concluído, **quando** a atualização terminar, **então** o pipeline deve apresentar o resultado da operação sem expor tokens, segredos ou valores confidenciais nos logs.

---

### História de Usuário 4 — Reexecutar o fluxo com rastreabilidade (Prioridade: P2)

Como pessoa responsável pela manutenção, quero relacionar cada deploy ao commit e ao artefato produzido, para identificar qual versão está publicada e reexecutar uma versão conhecida quando necessário.

**Por que esta prioridade**: A rastreabilidade reduz o tempo de diagnóstico e torna o processo de entrega auditável, mas depende do fluxo principal de build e deploy.

**Teste independente**: Executar o pipeline em dois commits diferentes e verificar que cada execução produz uma identificação distinta e registra o commit correspondente ao artefato e ao deploy.

**Cenários de aceite**:

1. **Dado** um commit identificado no repositório, **quando** o ZIP for gerado, **então** o artefato deve ser associado à identificação dessa execução ou commit.
2. **Dado** um deploy concluído, **quando** a execução for consultada, **então** deve ser possível identificar o commit usado para atualizar o Lambda.

## Casos de Borda

- Se o `requirements.txt` não existir, o pipeline deve falhar com uma mensagem que indique o arquivo esperado, salvo se o projeto for explicitamente definido como sem dependências.
- Se o handler informado não estiver presente no ZIP, o pipeline deve falhar antes do deploy.
- Se uma dependência tiver binários incompatíveis com o ambiente do Lambda, o problema deve ser detectado antes da publicação ou explicitamente reportado como falha de compatibilidade.
- Se o ZIP exceder o limite aceito pelo AWS Lambda, o pipeline deve falhar antes de atualizar a função e informar o tamanho ou o limite violado. **[NECESSITA ESCLARECIMENTO: o fluxo deve validar o limite de upload direto do Lambda ou utilizar S3 para artefatos maiores?]**
- Se o nome da função Lambda não estiver configurado, o pipeline não deve inferir um nome a partir de dados arbitrários. **[NECESSITA ESCLARECIMENTO: qual é o nome ou padrão do nome da função Lambda?]**
- Se houver duas execuções concorrentes para a mesma função `dev`, deve existir uma política definida para evitar que uma versão mais antiga substitua uma mais nova. **[NECESSITA ESCLARECIMENTO: execuções concorrentes devem ser canceladas, serializadas ou permitidas?]**
- Se a AWS estiver indisponível ou retornar erro transitório, o pipeline deve falhar de forma explícita após as tentativas permitidas, sem declarar o deploy como concluído.
- Se o pipeline for reexecutado, o resultado deve permanecer idempotente: atualizar a mesma função com o mesmo artefato não deve criar configuração divergente.
- O gatilho/evento de invocação da Lambda não faz parte da definição atual do fluxo. **[NECESSITA ESCLARECIMENTO: qual gatilho deve ser suportado ou configurado?]**

## Requisitos *(obrigatório)*

### Requisitos Funcionais

- **RF-001**: O pipeline DEVE executar as etapas usando Python 3.12, tanto quanto aplicável ao ambiente de validação.
- **RF-002**: O pipeline DEVE executar `ruff` como verificação de qualidade antes de gerar ou publicar o artefato.
- **RF-003**: O pipeline DEVE executar os testes automatizados com `pytest` antes de gerar ou publicar o artefato.
- **RF-004**: O pipeline DEVE interromper o fluxo quando `ruff` ou `pytest` retornar falha.
- **RF-005**: O pipeline DEVE instalar as dependências declaradas em `requirements.txt` no pacote destinado ao Lambda.
- **RF-006**: O pipeline DEVE gerar um arquivo ZIP contendo o código da aplicação, o handler `lambda_function.lambda_handler` e as dependências necessárias.
- **RF-007**: O pipeline DEVE impedir o deploy quando o ZIP não puder ser gerado, estiver vazio ou não contiver o handler esperado.
- **RF-008**: O pipeline DEVE associar o ZIP à identificação do commit ou da execução que o produziu.
- **RF-009**: O pipeline DEVE atualizar a função Lambda do ambiente `dev` somente depois da aprovação das etapas de qualidade e empacotamento.
- **RF-010**: O pipeline DEVE autenticar-se na AWS por OIDC, assumindo uma IAM Role configurada para o repositório ou ambiente.
- **RF-011**: O pipeline NÃO DEVE usar `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` ou credenciais AWS estáticas equivalentes.
- **RF-012**: O pipeline DEVE falhar explicitamente quando não conseguir assumir a IAM Role ou atualizar a função Lambda.
- **RF-013**: O pipeline DEVE evitar a exposição de tokens, segredos e valores confidenciais nos logs.
- **RF-014**: O pipeline DEVE validar o tamanho e a integridade do ZIP antes do deploy.
- **RF-015**: O pipeline DEVE publicar o resultado da execução de forma que seja possível distinguir sucesso, falha de qualidade, falha de empacotamento e falha de deploy.
- **RF-016**: O pipeline DEVE permitir identificar o nome da função Lambda e o ambiente de destino por configuração explícita. **[NECESSITA ESCLARECIMENTO: qual formato de configuração será adotado?]**
- **RF-017**: O pipeline DEVE definir uma política de concorrência para atualizações da mesma função Lambda. **[NECESSITA ESCLARECIMENTO: qual política deve ser aplicada?]**

### Entidades Principais

- **Código-fonte da aplicação**: Conjunto versionado de arquivos Python, incluindo o módulo que expõe o handler da Lambda.
- **Dependência Python**: Pacote declarado em `requirements.txt` e incluído no artefato quando necessário à execução.
- **Artefato Lambda**: Arquivo ZIP versionado ou identificável, contendo o código e as dependências aprovadas.
- **Execução do pipeline**: Registro de uma tentativa de validar, empacotar e, quando aprovado, publicar uma versão da aplicação.
- **Função Lambda**: Recurso AWS atualizado pelo artefato no ambiente `dev`. **[NECESSITA ESCLARECIMENTO: nome exato da função e configuração de região AWS.]**
- **IAM Role de deploy**: Role assumida via OIDC com as permissões mínimas para realizar a operação na AWS.

## Critérios de Sucesso *(obrigatório)*

### Resultados Mensuráveis

- **CS-001**: Em 100% das execuções com falha no `ruff` ou no `pytest`, nenhuma atualização da função Lambda deve ser iniciada.
- **CS-002**: Em 100% das execuções aprovadas, o pipeline deve gerar um ZIP não vazio contendo o módulo do handler e as dependências declaradas aplicáveis.
- **CS-003**: Em 100% dos deploys concluídos, a função Lambda `dev` deve reportar a atualização aceita pela AWS e a execução deve registrar o commit correspondente.
- **CS-004**: Em 100% das operações AWS, a autenticação deve ocorrer via OIDC e IAM Role, sem uso de chaves estáticas.
- **CS-005**: Em 100% das falhas de autenticação, empacotamento ou deploy, a execução deve terminar com status de falha e mensagem identificável para diagnóstico.
- **CS-006**: Pelo menos 95% das execuções de uma versão válida devem concluir o fluxo completo sem intervenção manual, desconsiderando indisponibilidades externas da AWS ou do runner.

## Premissas

- A aplicação é compatível com Python 3.12 e expõe o handler `lambda_function.lambda_handler`.
- As dependências de runtime são declaradas em `requirements.txt`.
- O repositório possui testes automatizados executáveis com `pytest`.
- O repositório possui configuração suficiente para executar `ruff`, ou a etapa do pipeline instalará a ferramenta de qualidade definida pelo projeto.
- O primeiro ambiente de destino é `dev`; `hom` e `prod` estão fora do escopo desta primeira versão.
- O deploy será realizado pelo GitHub Actions, com OIDC e uma IAM Role previamente configurada.
- O nome da função Lambda, a região AWS, o gatilho e a política de concorrência serão fornecidos antes da implementação. **[NECESSITA ESCLARECIMENTO: confirmar esses valores.]**
- O SDD não define provisionamento da função Lambda, criação da IAM Role, configuração do gatilho ou infraestrutura Terraform.
- O pipeline deve aproveitar os padrões de workflows reutilizáveis existentes no repositório, sem duplicar autenticação OIDC ou lógica de deploy.

