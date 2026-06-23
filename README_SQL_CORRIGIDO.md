# SQL corrigido - HERO Aesthetic Performance

Execute no Supabase SQL Editor nesta ordem:

1. `01_schema_essencial.sql`
2. `02_policies_rls.sql`
3. `03_storage_policies.sql` somente se for usar upload de fotos pelo Supabase Storage
4. Criar usuários em Authentication
5. Editar e executar `04_vincular_usuarios.sql`
6. `05_seed_biblioteca_exercicios.sql`
7. `06_teste_consulta.sql`

## Quando usar o reset

Use `00_reset_opcional.sql` apenas se quiser apagar as tabelas e começar do zero.

## O que foi corrigido

- Separei schema, policies, storage, vínculo e seed.
- Removi dependências desnecessárias.
- Corrigi risco de recursão em policies usando `security definer`.
- Tirei storage do schema principal para evitar erro quando o ambiente do Supabase bloquear políticas de storage.
- Mantive apenas tabelas realmente necessárias para alunos, treinos, exercícios, biblioteca, conclusão e fotos.

## Biblioteca

O seed contém aproximadamente 394 exercícios.

## Erros comuns

### infinite recursion detected in policy for relation profiles
Corrigido nesta versão.

### invalid input syntax for type uuid
Você precisa trocar `COLE_AQUI_UUID...` pelos UUIDs reais do Supabase Authentication.

### new row violates row-level security policy
O perfil admin ainda não foi criado corretamente ou você está usando usuário sem permissão.

### permission denied for schema storage
Pule `03_storage_policies.sql` por enquanto e configure Storage depois.
