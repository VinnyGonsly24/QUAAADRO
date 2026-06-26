create table if not exists public.quaaadro_states (
  user_id uuid primary key references auth.users(id) on delete cascade,
  state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.quaaadro_states enable row level security;

create or replace function public.set_quaaadro_states_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists set_quaaadro_states_updated_at on public.quaaadro_states;

create trigger set_quaaadro_states_updated_at
before update on public.quaaadro_states
for each row
execute function public.set_quaaadro_states_updated_at();

grant usage on schema public to anon, authenticated;
grant select, insert, update on table public.quaaadro_states to authenticated;

drop policy if exists "read own quaaadro state" on public.quaaadro_states;
create policy "read own quaaadro state"
on public.quaaadro_states
for select
to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "insert own quaaadro state" on public.quaaadro_states;
create policy "insert own quaaadro state"
on public.quaaadro_states
for insert
to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "update own quaaadro state" on public.quaaadro_states;
create policy "update own quaaadro state"
on public.quaaadro_states
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
