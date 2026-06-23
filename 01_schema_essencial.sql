-- 01_schema_essencial.sql
-- HERO Aesthetic Performance
-- Execute primeiro no Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text,
  email text unique,
  role text not null default 'student' check (role in ('admin', 'student')),
  status text not null default 'ativo' check (status in ('ativo', 'bloqueado')),
  created_at timestamptz not null default now()
);

create table if not exists public.alunos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references auth.users(id) on delete set null,
  nome text not null,
  email text not null unique,
  objetivo text default 'Estética, força e evolução real',
  plano text default 'HERO Aesthetic Performance',
  status text not null default 'ativo' check (status in ('ativo', 'bloqueado')),
  foto_url text,
  data_cadastro timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null
);

create table if not exists public.treinos (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid not null references public.alunos(id) on delete cascade,
  nome_do_treino text not null default 'Protocolo HERO - treino do dia',
  fase text,
  objetivo_do_treino text,
  observacoes text,
  liberado boolean not null default true,
  data_criacao timestamptz not null default now(),
  data_atualizacao timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null
);

create table if not exists public.exercicios_prescritos (
  id uuid primary key default gen_random_uuid(),
  treino_id uuid not null references public.treinos(id) on delete cascade,
  dia_da_semana text not null,
  bloco_do_treino text,
  grupo_muscular text,
  exercicio text not null,
  traducao_exercicio text,
  como_executar text,
  series text,
  repeticoes text,
  carga text,
  descanso text,
  cadencia text,
  metodo text,
  metodo_descricao text,
  progressao_ativa boolean not null default false,
  progressao jsonb not null default '[]'::jsonb,
  observacoes text,
  video_url text,
  ordem integer not null default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.biblioteca_exercicios (
  id uuid primary key default gen_random_uuid(),
  nome_exercicio text not null,
  nome_traduzido text,
  categoria_hero text,
  grupo_muscular text,
  como_executar text,
  observacao_tecnica text,
  video_url text,
  nivel text,
  equipamento text,
  created_at timestamptz not null default now()
);

create table if not exists public.exercicios_concluidos (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid not null references public.alunos(id) on delete cascade,
  exercicio_prescrito_id uuid not null references public.exercicios_prescritos(id) on delete cascade,
  dia_da_semana text not null,
  concluido boolean not null default true,
  concluido_em timestamptz not null default now(),
  unique (aluno_id, exercicio_prescrito_id, dia_da_semana)
);

create table if not exists public.treinos_concluidos (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid not null references public.alunos(id) on delete cascade,
  treino_id uuid references public.treinos(id) on delete set null,
  dia_da_semana text not null,
  tempo_total_segundos integer not null default 0,
  total_exercicios integer not null default 0,
  exercicios_finalizados integer not null default 0,
  mensagem_enviada boolean not null default false,
  concluido_em timestamptz not null default now()
);

create index if not exists idx_alunos_user_id on public.alunos(user_id);
create index if not exists idx_alunos_email on public.alunos(email);
create index if not exists idx_treinos_aluno_id on public.treinos(aluno_id);
create index if not exists idx_exercicios_treino_id on public.exercicios_prescritos(treino_id);
create index if not exists idx_biblioteca_categoria on public.biblioteca_exercicios(categoria_hero);
create index if not exists idx_biblioteca_grupo on public.biblioteca_exercicios(grupo_muscular);

create or replace function public.set_treinos_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.data_atualizacao = now();
  return new;
end;
$$;

drop trigger if exists trg_treinos_updated_at on public.treinos;

create trigger trg_treinos_updated_at
before update on public.treinos
for each row
execute function public.set_treinos_updated_at();
