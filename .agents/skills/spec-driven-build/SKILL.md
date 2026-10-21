---
name: spec-driven-build
description: "Cria especificações de funcionalidades orientadas por requisitos, cenários de aceite e critérios mensuráveis em Português do Brasil. Use quando o usuário pedir para especificar, detalhar, planejar ou estruturar uma nova funcionalidade antes da implementação."
argument-hint: "[descrição da funcionalidade]"
user-invocable: true
---

# Construção Orientada por Especificação

## Objetivo

Transformar uma descrição de funcionalidade em uma especificação clara, verificável e independente de tecnologia. A especificação deve permitir que desenvolvimento, testes e revisão compartilhem o mesmo entendimento do resultado esperado.

## Quando usar

Use esta skill quando for necessário:

- criar uma especificação de funcionalidade;
- transformar uma ideia ou pedido em requisitos testáveis;
- definir histórias de usuário e cenários de aceite;
- esclarecer escopo, premissas, entidades e critérios de sucesso antes da implementação;
- preparar uma funcionalidade para desenvolvimento orientado por especificação.

## Procedimento

1. Leia a descrição fornecida em `$ARGUMENTS` e identifique objetivo, usuários, valor esperado e limites conhecidos.
2. Se faltarem informações que alterem significativamente o comportamento, entreviste o usuário antes de concluir. Faça perguntas agrupadas e objetivas.
3. Defina um nome curto para a funcionalidade e uma branch no formato `[###-nome-da-funcionalidade]`, usando kebab-case.
4. Registre a data atual no formato `AAAA-MM-DD` e inicie o status como `Rascunho`.
5. Organize as histórias de usuário por prioridade (`P1`, `P2`, `P3`...). Cada história deve:
   - descrever uma jornada em linguagem simples;
   - explicar por que possui aquela prioridade;
   - ser testável de forma independente;
   - conter cenários de aceite no formato **Dado / Quando / Então**.
6. Liste casos de borda, incluindo condições de limite, entradas inválidas, falhas externas, concorrência, permissões e recuperação de erros quando aplicável.
7. Escreva requisitos funcionais numerados (`RF-001`, `RF-002`...). Cada requisito deve expressar uma capacidade observável e verificável.
8. Liste entidades e atributos relevantes somente quando a funcionalidade envolver dados. Descreva o significado dos dados, não a implementação.
9. Defina critérios de sucesso mensuráveis (`CS-001`, `CS-002`...) e independentes da tecnologia.
10. Registre premissas, dependências e limites de escopo.
11. Marque incertezas sem inventar decisões usando:
    `[NECESSITA ESCLARECIMENTO: pergunta objetiva]`.
12. Revise a especificação para garantir que:
    - cada história entregue valor por si só;
    - cada requisito possa ser validado;
    - os critérios de sucesso tenham métrica ou condição observável;
    - não existam conflitos entre histórias, requisitos e casos de borda;
    - detalhes de implementação não tenham sido introduzidos sem necessidade.

## Regras de escrita

- Escreva toda a especificação em Português do Brasil.
- Preserve nomes técnicos, comandos, identificadores e códigos quando necessário.
- Use linguagem direta, sem ambiguidades como “rápido”, “fácil” ou “adequado” sem uma métrica ou definição.
- Não presuma autenticação, retenção de dados, integrações, plataformas ou limites que não estejam informados; registre-os como premissas ou dúvidas.
- Não transforme tarefas técnicas em histórias de usuário. Histórias devem expressar valor para uma pessoa, sistema consumidor ou operação.
- Priorize o menor escopo que entregue valor. Funcionalidades posteriores devem receber prioridade menor ou ser explicitamente marcadas fora do escopo.
- Não inclua código de produção. A saída desta skill é uma especificação funcional.

## Formato de saída

Use o modelo abaixo. Substitua todos os placeholders e remova comentários orientativos antes de entregar o resultado.

```markdown
# Especificação de Funcionalidade: [NOME DA FUNCIONALIDADE]

**Branch da funcionalidade**: `[###-nome-da-funcionalidade]`

**Criada em**: [AAAA-MM-DD]

**Status**: Rascunho

**Entrada**: Descrição do usuário: "$ARGUMENTS"

## Jornadas do Usuário e Testes *(obrigatório)*

### História de Usuário 1 — [Título breve] (Prioridade: P1)

[Descreva a jornada do usuário em linguagem simples.]

**Por que esta prioridade**: [Explique o valor e a prioridade.]

**Teste independente**: [Explique como testar esta história isoladamente e qual valor ela entrega.]

**Cenários de aceite**:

1. **Dado** [estado inicial], **quando** [ação], **então** [resultado esperado].
2. **Dado** [estado inicial], **quando** [ação], **então** [resultado esperado].

---

### História de Usuário 2 — [Título breve] (Prioridade: P2)

[Repita a estrutura conforme necessário.]

## Casos de Borda

- [Condição de limite e comportamento esperado.]
- [Cenário de erro e comportamento esperado.]

## Requisitos *(obrigatório)*

### Requisitos Funcionais

- **RF-001**: O sistema DEVE [capacidade específica e verificável].
- **RF-002**: O usuário DEVE conseguir [interação principal].
- **RF-003**: O sistema DEVE [comportamento em caso de erro ou limite].
- **RF-004**: O sistema DEVE [regra de dados ou persistência, se aplicável].

### Entidades Principais *(incluir se a funcionalidade envolver dados)*

- **[Entidade 1]**: [O que representa e seus atributos relevantes.]
- **[Entidade 2]**: [Relacionamentos e regras relevantes.]

## Critérios de Sucesso *(obrigatório)*

### Resultados Mensuráveis

- **CS-001**: [Métrica de conclusão ou desempenho.]
- **CS-002**: [Métrica de confiabilidade, qualidade ou capacidade.]
- **CS-003**: [Métrica de adoção ou sucesso da jornada.]

## Premissas

- [Premissa sobre usuários ou contexto.]
- [Limite de escopo da primeira versão.]
- [Dependência de sistema, serviço ou permissão existente.]
```

## Checklist final

- [ ] A saída está em Português do Brasil.
- [ ] Todas as histórias têm prioridade e teste independente.
- [ ] Os cenários usam Dado / Quando / Então.
- [ ] Casos de borda relevantes foram considerados.
- [ ] Requisitos estão numerados e são verificáveis.
- [ ] Critérios de sucesso são mensuráveis.
- [ ] Dúvidas estão marcadas com `[NECESSITA ESCLARECIMENTO: ...]`.
- [ ] Não há placeholders não resolvidos nem comentários orientativos.
- [ ] A especificação não prescreve implementação sem necessidade.
