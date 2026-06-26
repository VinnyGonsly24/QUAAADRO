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

do $do$
begin
  if not exists (
    select 1
    from pg_trigger
    where tgname = 'set_quaaadro_states_updated_at'
      and tgrelid = 'public.quaaadro_states'::regclass
  ) then
    create trigger set_quaaadro_states_updated_at
    before update on public.quaaadro_states
    for each row
    execute function public.set_quaaadro_states_updated_at();
  end if;
end;
$do$;

grant usage on schema public to anon, authenticated;
grant select, insert, update on table public.quaaadro_states to authenticated;

do $do$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'quaaadro_states'
      and policyname = 'read own quaaadro state'
  ) then
    execute $policy$
      create policy "read own quaaadro state"
      on public.quaaadro_states
      for select
      to authenticated
      using ((select auth.uid()) = user_id)
    $policy$;
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'quaaadro_states'
      and policyname = 'insert own quaaadro state'
  ) then
    execute $policy$
      create policy "insert own quaaadro state"
      on public.quaaadro_states
      for insert
      to authenticated
      with check ((select auth.uid()) = user_id)
    $policy$;
  end if;

  if not exists (
    select 1 from pg_policies
    where schemaname = 'public'
      and tablename = 'quaaadro_states'
      and policyname = 'update own quaaadro state'
  ) then
    execute $policy$
      create policy "update own quaaadro state"
      on public.quaaadro_states
      for update
      to authenticated
      using ((select auth.uid()) = user_id)
      with check ((select auth.uid()) = user_id)
    $policy$;
  end if;
end;
$do$;
