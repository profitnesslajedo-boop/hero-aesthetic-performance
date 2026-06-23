-- 02_policies_rls.sql
-- Execute depois do 01_schema_essencial.sql.

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
      and status = 'ativo'
  );
$$;

create or replace function public.is_own_aluno(aluno_uuid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.alunos
    where id = aluno_uuid
      and user_id = auth.uid()
      and status = 'ativo'
  );
$$;

alter table public.profiles enable row level security;
alter table public.alunos enable row level security;
alter table public.treinos enable row level security;
alter table public.exercicios_prescritos enable row level security;
alter table public.biblioteca_exercicios enable row level security;
alter table public.exercicios_concluidos enable row level security;
alter table public.treinos_concluidos enable row level security;

drop policy if exists profiles_select on public.profiles;
drop policy if exists profiles_update on public.profiles;
drop policy if exists alunos_admin_all on public.alunos;
drop policy if exists alunos_student_select_own on public.alunos;
drop policy if exists alunos_student_update_own on public.alunos;
drop policy if exists treinos_admin_all on public.treinos;
drop policy if exists treinos_student_select_own on public.treinos;
drop policy if exists exercicios_admin_all on public.exercicios_prescritos;
drop policy if exists exercicios_student_select_own on public.exercicios_prescritos;
drop policy if exists biblioteca_select_authenticated on public.biblioteca_exercicios;
drop policy if exists biblioteca_admin_all on public.biblioteca_exercicios;
drop policy if exists exercicios_concluidos_admin_all on public.exercicios_concluidos;
drop policy if exists exercicios_concluidos_student_all_own on public.exercicios_concluidos;
drop policy if exists treinos_concluidos_admin_all on public.treinos_concluidos;
drop policy if exists treinos_concluidos_student_all_own on public.treinos_concluidos;

create policy profiles_select
on public.profiles
for select
to authenticated
using (id = auth.uid() or public.is_admin());

create policy profiles_update
on public.profiles
for update
to authenticated
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy alunos_admin_all
on public.alunos
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy alunos_student_select_own
on public.alunos
for select
to authenticated
using (user_id = auth.uid() and status = 'ativo');

create policy alunos_student_update_own
on public.alunos
for update
to authenticated
using (user_id = auth.uid() and status = 'ativo')
with check (user_id = auth.uid() and status = 'ativo');

create policy treinos_admin_all
on public.treinos
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy treinos_student_select_own
on public.treinos
for select
to authenticated
using (
  liberado = true
  and public.is_own_aluno(aluno_id)
);

create policy exercicios_admin_all
on public.exercicios_prescritos
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy exercicios_student_select_own
on public.exercicios_prescritos
for select
to authenticated
using (
  exists (
    select 1
    from public.treinos t
    where t.id = exercicios_prescritos.treino_id
      and t.liberado = true
      and public.is_own_aluno(t.aluno_id)
  )
);

create policy biblioteca_select_authenticated
on public.biblioteca_exercicios
for select
to authenticated
using (true);

create policy biblioteca_admin_all
on public.biblioteca_exercicios
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy exercicios_concluidos_admin_all
on public.exercicios_concluidos
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy exercicios_concluidos_student_all_own
on public.exercicios_concluidos
for all
to authenticated
using (public.is_own_aluno(aluno_id))
with check (public.is_own_aluno(aluno_id));

create policy treinos_concluidos_admin_all
on public.treinos_concluidos
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

create policy treinos_concluidos_student_all_own
on public.treinos_concluidos
for all
to authenticated
using (public.is_own_aluno(aluno_id))
with check (public.is_own_aluno(aluno_id));
