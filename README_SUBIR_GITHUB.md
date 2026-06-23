# HERO Aesthetic Performance - versão conectada ao Supabase

Arquivos principais:
- index.html
- 404.html
- supabase-config.js

## O que esta versão faz

- Login tenta autenticar primeiro pelo Supabase Auth.
- Se o login for de treinador/admin, abre a Central de Prescrição.
- O botão "Cadastrar aluna" chama a Edge Function:
  https://rkrhpdubooafecciffrb.supabase.co/functions/v1/create-student
- A Edge Function cria:
  - usuário no Authentication
  - profile
  - aluno
  - treino inicial
- Depois a tela abre a prescrição.

## Antes de subir

Confirme no Supabase:

1. A função `create-student` existe.
2. A função foi deployada.
3. Em Edge Functions > Secrets existe:
   HERO_SERVICE_ROLE_KEY
4. O código da função lê:
   Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || Deno.env.get("HERO_SERVICE_ROLE_KEY")
5. Seu usuário treinador existe em Authentication.
6. Seu usuário treinador está em `public.profiles` com:
   role = admin
   status = ativo

## Como subir no GitHub

1. Abra seu repositório no GitHub.
2. Clique em Add file > Upload files.
3. Envie:
   - index.html
   - 404.html
   - supabase-config.js
4. Clique em Commit changes.
5. Vá em Settings > Pages.
6. Configure:
   - Source: Deploy from branch
   - Branch: main
   - Folder: /root
7. Aguarde o link atualizar.

## Teste final

1. Abra o link publicado.
2. Faça login com o treinador:
   marcosestevees@icloud.com
3. Clique em Cadastrar aluna.
4. Preencha nome, email e senha.
5. Salve.
6. Verifique no Supabase > Authentication > Users se a aluna apareceu.
7. Verifique no banco se apareceram registros em `profiles`, `alunos` e `treinos`.

## Importante

A chave `publishableKey` pode ficar no frontend.
A chave `sb_secret_...` nunca pode ficar no frontend. Ela deve ficar somente em Edge Functions > Secrets.
