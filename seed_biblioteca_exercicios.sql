
-- HERO Aesthetic Performance - Supabase schema
-- Execute este arquivo no Supabase SQL Editor.
-- Depois execute seed_biblioteca_exercicios.sql.

create extension if not exists "pgcrypto";

-- 1. Perfis de usuários
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  nome text,
  email text unique,
  role text not null default 'student' check (role in ('admin','student')),
  status text not null default 'ativo' check (status in ('ativo','bloqueado')),
  created_at timestamptz not null default now()
);

-- 2. Alunos
create table if not exists public.alunos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references auth.users(id) on delete set null,
  nome text not null,
  email text not null unique,
  objetivo text default 'Estética, força e evolução real',
  plano text default 'HERO Aesthetic Performance',
  status text not null default 'ativo' check (status in ('ativo','bloqueado')),
  foto_url text,
  data_cadastro timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null
);

-- 3. Treinos
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

-- 4. Exercícios prescritos
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
  progressao_ativa boolean default false,
  progressao jsonb default '[]'::jsonb,
  observacoes text,
  video_url text,
  ordem integer default 1,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 5. Biblioteca de exercícios
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

-- 6. Exercícios concluídos pela aluna
create table if not exists public.exercicios_concluidos (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid not null references public.alunos(id) on delete cascade,
  exercicio_prescrito_id uuid not null references public.exercicios_prescritos(id) on delete cascade,
  dia_da_semana text not null,
  concluido boolean not null default true,
  concluido_em timestamptz not null default now(),
  unique(aluno_id, exercicio_prescrito_id, dia_da_semana)
);

-- 7. Treinos concluídos pela aluna
create table if not exists public.treinos_concluidos (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid not null references public.alunos(id) on delete cascade,
  treino_id uuid references public.treinos(id) on delete set null,
  dia_da_semana text not null,
  tempo_total_segundos integer default 0,
  total_exercicios integer default 0,
  exercicios_finalizados integer default 0,
  mensagem_enviada boolean default false,
  concluido_em timestamptz not null default now()
);

-- 8. Função utilitária para RLS
create or replace function public.is_admin()
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
      and p.status = 'ativo'
  );
$$;

-- 9. Trigger para atualizar data_atualizacao
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.data_atualizacao = now();
  return new;
end;
$$;

drop trigger if exists treinos_set_updated_at on public.treinos;
create trigger treinos_set_updated_at
before update on public.treinos
for each row execute procedure public.set_updated_at();

-- 10. Habilitar RLS
alter table public.profiles enable row level security;
alter table public.alunos enable row level security;
alter table public.treinos enable row level security;
alter table public.exercicios_prescritos enable row level security;
alter table public.biblioteca_exercicios enable row level security;
alter table public.exercicios_concluidos enable row level security;
alter table public.treinos_concluidos enable row level security;

-- 11. Políticas - profiles
drop policy if exists "profiles_select_own_or_admin" on public.profiles;
create policy "profiles_select_own_or_admin"
on public.profiles for select
to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists "profiles_update_own_or_admin" on public.profiles;
create policy "profiles_update_own_or_admin"
on public.profiles for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

-- 12. Políticas - alunos
drop policy if exists "alunos_admin_all" on public.alunos;
create policy "alunos_admin_all"
on public.alunos for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "alunos_student_select_own" on public.alunos;
create policy "alunos_student_select_own"
on public.alunos for select
to authenticated
using (user_id = auth.uid() and status = 'ativo');

drop policy if exists "alunos_student_update_own_photo" on public.alunos;
create policy "alunos_student_update_own_photo"
on public.alunos for update
to authenticated
using (user_id = auth.uid() and status = 'ativo')
with check (user_id = auth.uid());

-- 13. Políticas - treinos
drop policy if exists "treinos_admin_all" on public.treinos;
create policy "treinos_admin_all"
on public.treinos for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "treinos_student_select_own" on public.treinos;
create policy "treinos_student_select_own"
on public.treinos for select
to authenticated
using (
  liberado = true and exists (
    select 1 from public.alunos a
    where a.id = treinos.aluno_id
      and a.user_id = auth.uid()
      and a.status = 'ativo'
  )
);

-- 14. Políticas - exercícios prescritos
drop policy if exists "exercicios_prescritos_admin_all" on public.exercicios_prescritos;
create policy "exercicios_prescritos_admin_all"
on public.exercicios_prescritos for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "exercicios_prescritos_student_select_own" on public.exercicios_prescritos;
create policy "exercicios_prescritos_student_select_own"
on public.exercicios_prescritos for select
to authenticated
using (
  exists (
    select 1
    from public.treinos t
    join public.alunos a on a.id = t.aluno_id
    where t.id = exercicios_prescritos.treino_id
      and t.liberado = true
      and a.user_id = auth.uid()
      and a.status = 'ativo'
  )
);

-- 15. Biblioteca: admin escreve, todos autenticados leem
drop policy if exists "biblioteca_select_authenticated" on public.biblioteca_exercicios;
create policy "biblioteca_select_authenticated"
on public.biblioteca_exercicios for select
to authenticated
using (true);

drop policy if exists "biblioteca_admin_all" on public.biblioteca_exercicios;
create policy "biblioteca_admin_all"
on public.biblioteca_exercicios for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- 16. Conclusões
drop policy if exists "exercicios_concluidos_admin_all" on public.exercicios_concluidos;
create policy "exercicios_concluidos_admin_all"
on public.exercicios_concluidos for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "exercicios_concluidos_student_own" on public.exercicios_concluidos;
create policy "exercicios_concluidos_student_own"
on public.exercicios_concluidos for all
to authenticated
using (
  exists(select 1 from public.alunos a where a.id = exercicios_concluidos.aluno_id and a.user_id = auth.uid())
)
with check (
  exists(select 1 from public.alunos a where a.id = exercicios_concluidos.aluno_id and a.user_id = auth.uid())
);

drop policy if exists "treinos_concluidos_admin_all" on public.treinos_concluidos;
create policy "treinos_concluidos_admin_all"
on public.treinos_concluidos for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "treinos_concluidos_student_own" on public.treinos_concluidos;
create policy "treinos_concluidos_student_own"
on public.treinos_concluidos for all
to authenticated
using (
  exists(select 1 from public.alunos a where a.id = treinos_concluidos.aluno_id and a.user_id = auth.uid())
)
with check (
  exists(select 1 from public.alunos a where a.id = treinos_concluidos.aluno_id and a.user_id = auth.uid())
);

-- 17. Storage para fotos de alunas
insert into storage.buckets (id, name, public)
values ('hero-fotos-alunas', 'hero-fotos-alunas', true)
on conflict (id) do nothing;

drop policy if exists "hero_fotos_select" on storage.objects;
create policy "hero_fotos_select"
on storage.objects for select
to authenticated
using (bucket_id = 'hero-fotos-alunas');

drop policy if exists "hero_fotos_insert_own_or_admin" on storage.objects;
create policy "hero_fotos_insert_own_or_admin"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'hero-fotos-alunas'
  and (public.is_admin() or auth.uid()::text = (storage.foldername(name))[1])
);

drop policy if exists "hero_fotos_update_own_or_admin" on storage.objects;
create policy "hero_fotos_update_own_or_admin"
on storage.objects for update
to authenticated
using (
  bucket_id = 'hero-fotos-alunas'
  and (public.is_admin() or auth.uid()::text = (storage.foldername(name))[1])
)
with check (
  bucket_id = 'hero-fotos-alunas'
  and (public.is_admin() or auth.uid()::text = (storage.foldername(name))[1])
);

drop policy if exists "hero_fotos_delete_admin" on storage.objects;
create policy "hero_fotos_delete_admin"
on storage.objects for delete
to authenticated
using (bucket_id = 'hero-fotos-alunas' and public.is_admin());
