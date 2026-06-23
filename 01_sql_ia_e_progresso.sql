-- HERO Aesthetic Performance: IA, exercícios prescritos, check-ins, progresso e cronômetro

create table if not exists public.exercicios_prescritos (
  id uuid primary key default gen_random_uuid(),
  treino_id uuid references public.treinos(id) on delete cascade,
  aluno_id uuid references public.alunos(id) on delete cascade,
  dia text,
  ordem int,
  nome text not null,
  traducao text,
  grupo text,
  categoria text,
  series text,
  repeticoes text,
  carga text,
  descanso text,
  metodo text,
  execucao text,
  observacoes text,
  video_url text,
  created_at timestamptz default now()
);

create table if not exists public.ai_prescription_logs (
  id uuid primary key default gen_random_uuid(),
  treinador_id uuid references auth.users(id) on delete set null,
  aluno_id uuid references public.alunos(id) on delete cascade,
  prompt jsonb not null,
  resposta jsonb,
  status text default 'gerado',
  created_at timestamptz default now()
);

create table if not exists public.exercicios_finalizados (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid references public.alunos(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  treino_id uuid references public.treinos(id) on delete cascade,
  exercicio_id uuid,
  dia text,
  finalizado boolean default true,
  finalizado_em timestamptz default now(),
  carga_usada text,
  observacoes text,
  unique(user_id, exercicio_id)
);

create table if not exists public.sessoes_treino (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid references public.alunos(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  treino_id uuid references public.treinos(id) on delete cascade,
  iniciado_em timestamptz default now(),
  finalizado_em timestamptz,
  duracao_segundos int,
  status text default 'em_andamento',
  created_at timestamptz default now()
);

create table if not exists public.checkins (
  id uuid primary key default gen_random_uuid(),
  aluno_id uuid references public.alunos(id) on delete cascade,
  user_id uuid references auth.users(id) on delete cascade,
  data date default current_date,
  peso numeric,
  energia int,
  sono int,
  dor int,
  humor int,
  observacoes text,
  foto_frente_url text,
  foto_lado_url text,
  foto_costas_url text,
  created_at timestamptz default now()
);

alter table public.exercicios_prescritos enable row level security;
alter table public.ai_prescription_logs enable row level security;
alter table public.exercicios_finalizados enable row level security;
alter table public.sessoes_treino enable row level security;
alter table public.checkins enable row level security;

drop policy if exists "admin pode gerenciar exercicios prescritos" on public.exercicios_prescritos;
drop policy if exists "aluno pode ver seus exercicios prescritos" on public.exercicios_prescritos;
drop policy if exists "admin pode ver logs de ia" on public.ai_prescription_logs;
drop policy if exists "admin pode criar logs de ia" on public.ai_prescription_logs;
drop policy if exists "admin pode ver progresso" on public.exercicios_finalizados;
drop policy if exists "aluno pode gerenciar seu progresso" on public.exercicios_finalizados;
drop policy if exists "admin pode ver sessoes" on public.sessoes_treino;
drop policy if exists "aluno pode gerenciar suas sessoes" on public.sessoes_treino;
drop policy if exists "admin pode ver checkins" on public.checkins;
drop policy if exists "aluno pode gerenciar seus checkins" on public.checkins;

create policy "admin pode gerenciar exercicios prescritos"
on public.exercicios_prescritos
for all
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'))
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'));

create policy "aluno pode ver seus exercicios prescritos"
on public.exercicios_prescritos
for select
using (exists (select 1 from public.alunos a where a.id = exercicios_prescritos.aluno_id and a.user_id = auth.uid() and a.status = 'ativo'));

create policy "admin pode ver logs de ia"
on public.ai_prescription_logs
for select
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'));

create policy "admin pode criar logs de ia"
on public.ai_prescription_logs
for insert
with check (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'));

create policy "admin pode ver progresso"
on public.exercicios_finalizados
for select
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'));

create policy "aluno pode gerenciar seu progresso"
on public.exercicios_finalizados
for all
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "admin pode ver sessoes"
on public.sessoes_treino
for select
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'));

create policy "aluno pode gerenciar suas sessoes"
on public.sessoes_treino
for all
using (user_id = auth.uid())
with check (user_id = auth.uid());

create policy "admin pode ver checkins"
on public.checkins
for select
using (exists (select 1 from public.profiles p where p.id = auth.uid() and p.role = 'admin' and p.status = 'ativo'));

create policy "aluno pode gerenciar seus checkins"
on public.checkins
for all
using (user_id = auth.uid())
with check (user_id = auth.uid());
