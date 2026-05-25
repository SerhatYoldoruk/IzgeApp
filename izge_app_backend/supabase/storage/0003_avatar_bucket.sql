insert into storage.buckets (id, name, public)
values ('avatar', 'avatar', true)
on conflict (id) do update
set public = excluded.public;

create policy "avatar_public_read"
on storage.objects
for select
to public
using (bucket_id = 'avatar');

create policy "avatar_authenticated_upload"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'avatar'
  and split_part(name, '/', 1) = auth.uid()::text
);

create policy "avatar_authenticated_update"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'avatar'
  and split_part(name, '/', 1) = auth.uid()::text
)
with check (
  bucket_id = 'avatar'
  and split_part(name, '/', 1) = auth.uid()::text
);

create policy "avatar_authenticated_delete"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'avatar'
  and split_part(name, '/', 1) = auth.uid()::text
);
