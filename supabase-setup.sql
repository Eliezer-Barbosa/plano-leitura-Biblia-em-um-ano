-- Sincronização do plano de leitura da Bíblia
-- Execute este arquivo uma vez no Supabase: SQL Editor -> New query -> Run.

create table if not exists public.bible_reading_progress (
  user_id uuid primary key references auth.users(id) on delete cascade,
  progress jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.bible_reading_progress enable row level security;

revoke all on table public.bible_reading_progress from anon;
grant select, insert, update, delete on table public.bible_reading_progress to authenticated;

drop policy if exists "Only owner email can read reading progress" on public.bible_reading_progress;
create policy "Only owner email can read reading progress"
on public.bible_reading_progress for select
to authenticated
using (
  user_id = (select auth.uid())
  and (select auth.jwt() ->> 'email') = 'eliezer1789@gmail.com'
);

drop policy if exists "Only owner email can insert reading progress" on public.bible_reading_progress;
create policy "Only owner email can insert reading progress"
on public.bible_reading_progress for insert
to authenticated
with check (
  user_id = (select auth.uid())
  and (select auth.jwt() ->> 'email') = 'eliezer1789@gmail.com'
);

drop policy if exists "Only owner email can update reading progress" on public.bible_reading_progress;
create policy "Only owner email can update reading progress"
on public.bible_reading_progress for update
to authenticated
using (
  user_id = (select auth.uid())
  and (select auth.jwt() ->> 'email') = 'eliezer1789@gmail.com'
)
with check (
  user_id = (select auth.uid())
  and (select auth.jwt() ->> 'email') = 'eliezer1789@gmail.com'
);

drop policy if exists "Only owner email can delete reading progress" on public.bible_reading_progress;
create policy "Only owner email can delete reading progress"
on public.bible_reading_progress for delete
to authenticated
using (
  user_id = (select auth.uid())
  and (select auth.jwt() ->> 'email') = 'eliezer1789@gmail.com'
);
