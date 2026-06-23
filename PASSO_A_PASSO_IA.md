# Passo a passo para finalizar a IA

## 1. Subir o HTML no GitHub

No GitHub, envie estes arquivos:

- index.html
- 404.html
- supabase-config.js

Depois vá em:

Settings > Pages

Configure:

- Source: Deploy from branch
- Branch: main
- Folder: /root

## 2. Criar as tabelas

No Supabase:

SQL Editor > New query

Apague o que estiver lá e cole o conteúdo do arquivo:

01_sql_ia_e_progresso.sql

Clique em Run.

## 3. Criar a secret da OpenAI

No Supabase:

Edge Functions > Secrets

Crie:

Name:
OPENAI_API_KEY

Value:
sua chave da OpenAI

Não coloque essa chave no GitHub, no HTML ou no supabase-config.js.

## 4. Criar a Edge Function

No Supabase:

Edge Functions > Create a new function

Nome:

generate-prescription

Depois abra a aba Code, apague o código padrão e cole todo o conteúdo de:

edge-function-generate-prescription.ts

Clique em:

Deploy function

## 5. Teste

1. Abra o site publicado.
2. Faça login como treinador.
3. Selecione uma aluna.
4. Clique em Gerar com IA.
5. Preencha objetivo, nível, dias, foco e restrições.
6. Clique em gerar.

A função deve criar:

- um registro em treinos
- registros em exercicios_prescritos
- um log em ai_prescription_logs

## 6. Conferir

No Supabase, confira:

Table Editor > treinos
Table Editor > exercicios_prescritos
Table Editor > ai_prescription_logs

## Observação importante

O treino gerado pela IA entra com:

liberado = false

Isso é proposital. A IA gera, você revisa, depois libera.
