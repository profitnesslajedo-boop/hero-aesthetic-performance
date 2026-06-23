# HERO Aesthetic Performance - pacote com IA OpenAI

Este pacote adiciona o botão **Gerar com IA** no painel do treinador.

## Arquivos

- `index.html`: plataforma com botão de IA.
- `404.html`: cópia do index para GitHub Pages.
- `supabase-config.js`: URL e publishable key do Supabase.
- `01_sql_ia_e_progresso.sql`: tabelas e políticas.
- `edge-function-generate-prescription.ts`: código da Edge Function.
- `PASSO_A_PASSO_IA.md`: instruções completas.

## Atenção

A chave da OpenAI não vai no HTML.
Ela deve ser cadastrada em:

Supabase > Edge Functions > Secrets

Nome:

OPENAI_API_KEY

Valor:

sua chave da OpenAI
