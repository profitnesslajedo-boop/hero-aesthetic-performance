
# Passo a passo completo - GitHub + Supabase

## PARTE 1 - Preparar o GitHub

### 1. Criar repositório

1. Acesse GitHub.
2. Clique em **New repository**.
3. Nome sugerido:
   `hero-aesthetic-performance`
4. Marque como **Public** se for usar GitHub Pages gratuito.
5. Clique em **Create repository**.

### 2. Enviar os arquivos

Opção simples pelo navegador:

1. Entre no repositório criado.
2. Clique em **Add file**.
3. Clique em **Upload files**.
4. Envie todos os arquivos deste pacote.
5. Clique em **Commit changes**.

Estrutura esperada:

```txt
index.html
404.html
README_DEPLOY_GITHUB_SUPABASE.md
supabase-config.example.js
supabase-adapter.js
.gitignore
supabase/
  schema.sql
  seed_biblioteca_exercicios.sql
```

### 3. Ativar GitHub Pages

1. No repositório, vá em **Settings**.
2. Clique em **Pages**.
3. Em **Build and deployment**, selecione:
   - Source: **Deploy from a branch**
   - Branch: **main**
   - Folder: **/root**
4. Clique em **Save**.
5. Aguarde o GitHub gerar o link.

O link normalmente fica assim:

```txt
https://SEU-USUARIO.github.io/hero-aesthetic-performance/
```

## PARTE 2 - Criar Supabase

### 4. Criar projeto

1. Acesse Supabase.
2. Clique em **New project**.
3. Escolha a organização.
4. Nome sugerido:
   `hero-aesthetic-performance`
5. Crie uma senha forte para o banco.
6. Região: escolha a mais próxima do Brasil, se disponível.
7. Clique em **Create new project**.

### 5. Executar schema

1. No Supabase, vá em **SQL Editor**.
2. Clique em **New query**.
3. Cole todo o conteúdo de:
   `supabase/schema.sql`
4. Clique em **Run**.

Isso cria:
- profiles
- alunos
- treinos
- exercicios_prescritos
- biblioteca_exercicios
- exercicios_concluidos
- treinos_concluidos
- bucket de fotos
- políticas RLS

### 6. Inserir biblioteca de exercícios

1. Ainda no **SQL Editor**, clique em **New query**.
2. Cole o conteúdo de:
   `supabase/seed_biblioteca_exercicios.sql`
3. Clique em **Run**.

## PARTE 3 - Criar autenticação

### 7. Criar usuário treinador

1. Vá em **Authentication**.
2. Clique em **Users**.
3. Clique em **Add user**.
4. Email:
   `marcosestevees@icloud.com`
5. Senha:
   defina sua senha no próprio Supabase.
6. Confirme/crie o usuário.

Depois, copie o **User UID** do treinador.

### 8. Criar usuário aluna

1. Em **Authentication > Users**, clique em **Add user**.
2. Email:
   `jessika.liz.feitosa@gmail.com`
3. Defina a senha da aluna.
4. Copie o **User UID** dela.

### 9. Criar perfis e vínculo com aluno

No SQL Editor, rode este modelo, trocando os UUIDs:

```sql
insert into public.profiles (id, nome, email, role, status)
values
('UUID_DO_TREINADOR', 'Marcos Esteves', 'marcosestevees@icloud.com', 'admin', 'ativo')
on conflict (id) do update set role='admin', status='ativo';

insert into public.profiles (id, nome, email, role, status)
values
('UUID_DA_ALUNA', 'Jessika Liz Feitosa', 'jessika.liz.feitosa@gmail.com', 'student', 'ativo')
on conflict (id) do update set role='student', status='ativo';

insert into public.alunos (user_id, nome, email, objetivo, plano, status, created_by)
values
(
  'UUID_DA_ALUNA',
  'Jessika Liz Feitosa',
  'jessika.liz.feitosa@gmail.com',
  'Estética, força e evolução real',
  'HERO Aesthetic Performance',
  'ativo',
  'UUID_DO_TREINADOR'
)
on conflict (email) do update set user_id='UUID_DA_ALUNA', status='ativo';
```

## PARTE 4 - Pegar URL e anon key

### 10. Copiar dados do projeto

1. No Supabase, vá em **Project Settings**.
2. Clique em **API**.
3. Copie:
   - Project URL
   - anon public key

### 11. Criar supabase-config.js

1. No GitHub, crie um arquivo chamado:
   `supabase-config.js`
2. Use o modelo:

```js
window.HERO_SUPABASE_CONFIG = {
  url: "https://SEU-PROJETO.supabase.co",
  anonKey: "SUA_CHAVE_ANON_PUBLICA"
};
```

3. Faça commit.

Importante:
- Pode usar anon key no navegador.
- Nunca coloque service_role no GitHub.
- A segurança vem das políticas RLS.

## PARTE 5 - Conectar frontend

A versão atual usa localStorage para funcionar como protótipo.

Para conexão real, existem dois caminhos:

### Caminho A - integração gradual

1. Adicione no `index.html`, antes do script principal:

```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
<script src="./supabase-config.js"></script>
<script src="./supabase-adapter.js"></script>
```

2. Substitua as funções locais:
   - `data()`
   - `save()`
   - `login()`
   - criação de aluno
   - criação de treino
   - criação de exercício
   - upload de foto

pelas funções do `supabase-adapter.js`.

### Caminho B - recomendado para versão profissional

Migrar para:
- Vite
- React
- Supabase Auth
- Supabase Database
- Supabase Storage

Esse caminho deixa o projeto escalável e mais fácil de manter.

## PARTE 6 - Testes obrigatórios

Teste nesta ordem:

1. Abrir link GitHub Pages.
2. Testar login do treinador.
3. Ver se treinador acessa painel.
4. Testar login da aluna.
5. Ver se aluna não acessa painel admin.
6. Criar aluno.
7. Criar treino.
8. Adicionar exercícios.
9. Salvar treino.
10. Ver se aluna vê apenas o próprio treino.
11. Testar upload/recorte de foto.
12. Testar cronômetro.
13. Marcar exercício como concluído.
14. Finalizar treino.
15. Testar link WhatsApp/e-mail.
16. Testar em celular real.

## PARTE 7 - Notificações automáticas reais

A versão HTML abre WhatsApp/e-mail com mensagem pronta.

Para enviar automático, use:

- Supabase Edge Function
- Resend, SendGrid ou outro serviço de e-mail
- WhatsApp Business API

Não coloque token de API no frontend. Use Edge Function com secrets.
