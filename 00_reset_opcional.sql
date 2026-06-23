-- 00_reset_opcional.sql
-- Use somente se quiser apagar tudo e recomeçar.
-- Cuidado: apaga dados de alunos, treinos e prescrições.

drop table if exists public.treinos_concluidos cascade;
drop table if exists public.exercicios_concluidos cascade;
drop table if exists public.exercicios_prescritos cascade;
drop table if exists public.treinos cascade;
drop table if exists public.biblioteca_exercicios cascade;
drop table if exists public.alunos cascade;
drop table if exists public.profiles cascade;

drop function if exists public.is_admin() cascade;
drop function if exists public.is_own_aluno(uuid) cascade;
drop function if exists public.set_treinos_updated_at() cascade;
