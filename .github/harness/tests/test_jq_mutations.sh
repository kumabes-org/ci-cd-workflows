#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIXTURE_PATH="${SCRIPT_DIR}/../fixtures/task-def-sample.json"

IMAGE_MOCK="123456789012.dkr.ecr.us-east-1.amazonaws.com/python-ecs:harness-test-tag"
CONTAINER_MOCK="python-ecs-sample-ctr"

echo "=== [Harness Test] Iniciando testes de mutação JQ ==="

if [[ ! -f "$FIXTURE_PATH" ]]; then
  echo "❌ Erro: Fixture $FIXTURE_PATH não encontrada." >&2
  exit 1
fi

# Executa a mesma expressão jq utilizada no workflow engine-deploy-ecs
PROCESSED_JSON=$(jq \
  --arg IMAGE "$IMAGE_MOCK" \
  --arg CNAME "$CONTAINER_MOCK" '
  ((.containerDefinitions[] | select(.name == $CNAME)).image = $IMAGE)
  | ((.containerDefinitions[] | select(.name == $CNAME)).logConfiguration.options["awslogs-create-group"] = "false")
  | with_entries(select(.value != null))
' "$FIXTURE_PATH")

# Teste 1: A imagem foi atualizada corretamente?
echo -n "• Teste 1: Injeção da nova imagem... "
UPDATED_IMAGE=$(echo "$PROCESSED_JSON" | jq -r --arg CNAME "$CONTAINER_MOCK" '.containerDefinitions[] | select(.name == $CNAME) | .image')
if [[ "$UPDATED_IMAGE" == "$IMAGE_MOCK" ]]; then
  echo "OK"
else
  echo "FALHOU! Esperado: $IMAGE_MOCK, Recebido: $UPDATED_IMAGE" >&2
  exit 1
fi

# Teste 2: O atributo taskRoleArn com valor null foi expurgado?
echo -n "• Teste 2: Remoção de chaves nulas (taskRoleArn)... "
HAS_TASK_ROLE=$(echo "$PROCESSED_JSON" | jq 'has("taskRoleArn")')
if [[ "$HAS_TASK_ROLE" == "false" ]]; then
  echo "OK"
else
  echo "FALHOU! taskRoleArn ainda existe no payload gerado." >&2
  exit 1
fi

# Teste 3: A flag awslogs-create-group foi alterada para false?
echo -n "• Teste 3: Atualização da flag de log do CloudWatch... "
LOG_FLAG=$(echo "$PROCESSED_JSON" | jq -r --arg CNAME "$CONTAINER_MOCK" '.containerDefinitions[] | select(.name == $CNAME) | .logConfiguration.options["awslogs-create-group"]')
if [[ "$LOG_FLAG" == "false" ]]; then
  echo "OK"
else
  echo "FALHOU! Flag awslogs-create-group não foi ajustada para false." >&2
  exit 1
fi

# Teste 4: Port mappings e compatibilidade Fargate continuam intactos?
echo -n "• Teste 4: Preservação de configurações base (portMappings / Fargate)... "
PORT_MAPPING=$(echo "$PROCESSED_JSON" | jq -r --arg CNAME "$CONTAINER_MOCK" '.containerDefinitions[] | select(.name == $CNAME) | .portMappings[0].containerPort')
if [[ "$PORT_MAPPING" == "8080" ]]; then
  echo "OK"
else
  echo "FALHOU! Port mapping foi corrompido." >&2
  exit 1
fi

echo "=== [Harness Test] Todos os 4 testes passaram com sucesso! ==="