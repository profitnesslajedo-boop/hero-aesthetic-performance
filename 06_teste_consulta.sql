-- 06_teste_consulta.sql
-- Execute para verificar tabelas e biblioteca.

select 'profiles' as tabela, count(*) from public.profiles
union all
select 'alunos', count(*) from public.alunos
union all
select 'treinos', count(*) from public.treinos
union all
select 'exercicios_prescritos', count(*) from public.exercicios_prescritos
union all
select 'biblioteca_exercicios', count(*) from public.biblioteca_exercicios;

select categoria_hero, grupo_muscular, count(*) as total
from public.biblioteca_exercicios
group by categoria_hero, grupo_muscular
order by categoria_hero, grupo_muscular;
