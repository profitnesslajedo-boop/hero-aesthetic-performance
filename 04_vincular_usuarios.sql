-- 04_vincular_usuarios.sql
-- Execute depois de criar os usuários em Authentication > Users.
-- Troque os UUIDs abaixo pelos User IDs reais.

insert into public.profiles (id, nome, email, role, status)
values (
  'COLE_AQUI_UUID_DO_TREINADOR',
  'Marcos Esteves',
  'marcosestevees@icloud.com',
  'admin',
  'ativo'
)
on conflict (id) do update
set nome = excluded.nome,
    email = excluded.email,
    role = 'admin',
    status = 'ativo';

insert into public.profiles (id, nome, email, role, status)
values (
  'COLE_AQUI_UUID_DA_ALUNA',
  'Jessika Liz Feitosa',
  'jessika.liz.feitosa@gmail.com',
  'student',
  'ativo'
)
on conflict (id) do update
set nome = excluded.nome,
    email = excluded.email,
    role = 'student',
    status = 'ativo';

insert into public.alunos (
  user_id,
  nome,
  email,
  objetivo,
  plano,
  status,
  created_by
)
values (
  'COLE_AQUI_UUID_DA_ALUNA',
  'Jessika Liz Feitosa',
  'jessika.liz.feitosa@gmail.com',
  'Estética, força e evolução real',
  'HERO Aesthetic Performance',
  'ativo',
  'COLE_AQUI_UUID_DO_TREINADOR'
)
on conflict (email) do update
set user_id = excluded.user_id,
    nome = excluded.nome,
    objetivo = excluded.objetivo,
    plano = excluded.plano,
    status = 'ativo',
    created_by = excluded.created_by;
