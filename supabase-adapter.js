
# HERO Aesthetic Performance - pacote GitHub + Supabase

Este pacote contém:

- `index.html`: versão atual da plataforma HERO para hospedar no GitHub Pages.
- `404.html`: fallback para GitHub Pages.
- `supabase/schema.sql`: estrutura do banco, RLS e bucket de fotos.
- `supabase/seed_biblioteca_exercicios.sql`: biblioteca HERO com aproximadamente 394 exercícios.
- `supabase-config.example.js`: modelo para preencher URL e anon key.
- `supabase-adapter.js`: base de integração Supabase para substituir o localStorage.

## Observação importante

A plataforma atual está funcionando em modo **localStorage**, ótimo para validar estrutura e demonstrar o produto.

Para uso profissional real, conecte o Supabase seguindo o schema. A autenticação, proteção por aluno, fotos e dados persistentes devem rodar no Supabase com RLS ativado.

Nunca coloque `service_role` no frontend. Use apenas `anon key` no navegador e proteja tudo com Row Level Security.

## Ordem resumida

1. Criar repositório no GitHub.
2. Subir todos os arquivos deste pacote.
3. Ativar GitHub Pages.
4. Criar projeto no Supabase.
5. Executar `supabase/schema.sql`.
6. Executar `supabase/seed_biblioteca_exercicios.sql`.
7. Criar usuários em Supabase Authentication.
8. Atualizar tabela `profiles` e vincular `alunos.user_id`.
9. Criar `supabase-config.js` com sua URL e anon key.
10. Integrar `supabase-adapter.js` ao frontend, substituindo o modo localStorage por Supabase.
11. Testar login treinador, login aluna, prescrição, conclusão de treino e upload de foto.

## Credenciais planejadas

Treinador:
- Email: marcosestevees@icloud.com

Aluna:
- Email: jessika.liz.feitosa@gmail.com

As senhas devem ser criadas dentro do Supabase Authentication, não dentro do GitHub.
