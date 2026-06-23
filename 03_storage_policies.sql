-- 03_storage_policies.sql
-- Opcional. Execute apenas quando for usar upload de fotos no Supabase Storage.

insert into storage.buckets (id, name, public)
values ('hero-fotos-alunas', 'hero-fotos-alunas', true)
on conflict (id) do nothing;

drop policy if exists hero_fotos_select on storage.objects;
drop policy if exists hero_fotos_insert_own_or_admin on storage.objects;
drop policy if exists hero_fotos_update_own_or_admin on storage.objects;
drop policy if exists hero_fotos_delete_admin on storage.objects;

create policy hero_fotos_select
on storage.objects
for select
to authenticated
using (bucket_id = 'hero-fotos-alunas');

create policy hero_fotos_insert_own_or_admin
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'hero-fotos-alunas'
  and (
    public.is_admin()
    or auth.uid()::text = (storage.foldername(name))[1]
  )
);

create policy hero_fotos_update_own_or_admin
on storage.objects
for update
to authenticated
using (
  bucket_id = 'hero-fotos-alunas'
  and (
    public.is_admin()
    or auth.uid()::text = (storage.foldername(name))[1]
  )
)
with check (
  bucket_id = 'hero-fotos-alunas'
  and (
    public.is_admin()
    or auth.uid()::text = (storage.foldername(name))[1]
  )
);

create policy hero_fotos_delete_admin
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'hero-fotos-alunas'
  and public.is_admin()
);
