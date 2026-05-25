alter table public.profiles enable row level security;
alter table public.announcements enable row level security;
alter table public.events enable row level security;
alter table public.event_days enable row level security;
alter table public.polls enable row level security;
alter table public.poll_options enable row level security;
alter table public.poll_votes enable row level security;
alter table public.chat_rooms enable row level security;
alter table public.messages enable row level security;

create policy "profiles_select_own"
on public.profiles
for select
using (auth.uid() = id);

create policy "profiles_insert_own"
on public.profiles
for insert
with check (
  auth.uid() = id
  or auth.uid() is null
);

create policy "profiles_update_own"
on public.profiles
for update
using (auth.uid() = id)
with check (
  auth.uid() = id
  or auth.uid() is null
);

create policy "announcements_read_all"
on public.announcements
for select
to authenticated, anon
using (true);

create policy "events_read_all"
on public.events
for select
to authenticated, anon
using (true);

create policy "event_days_read_all"
on public.event_days
for select
to authenticated, anon
using (true);

create policy "polls_read_all"
on public.polls
for select
to authenticated, anon
using (true);

create policy "poll_options_read_all"
on public.poll_options
for select
to authenticated, anon
using (true);

create policy "poll_votes_insert_own"
on public.poll_votes
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "poll_votes_read_own"
on public.poll_votes
for select
to authenticated
using (auth.uid() = user_id);

create policy "chat_rooms_read_own"
on public.chat_rooms
for select
to authenticated
using (auth.uid() = user_id);

create policy "chat_rooms_insert_own"
on public.chat_rooms
for insert
to authenticated
with check (auth.uid() = user_id);

create policy "messages_read_room_owner"
on public.messages
for select
to authenticated
using (
  exists (
    select 1
    from public.chat_rooms cr
    where cr.id = room_id
      and cr.user_id = auth.uid()
  )
);

create policy "messages_insert_room_owner"
on public.messages
for insert
to authenticated
with check (
  auth.uid() = sender_id
  and exists (
    select 1
    from public.chat_rooms cr
    where cr.id = room_id
      and cr.user_id = auth.uid()
  )
);
