-- =====================================================================
-- Mystic Nova Brief Studio — database setup for Supabase
--
-- HOW TO USE: create your studio login first (Authentication → Users →
-- Add user → Create new user, tick "Auto Confirm User"). Then copy this
-- whole file into Supabase → SQL Editor → New query and click Run.
-- You don't need to change anything in it.
-- It is safe to run again. It never deletes your projects or answers.
-- =====================================================================

-- ---------- tables ----------
create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

create table if not exists public.settings (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.projects (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.versions (
  id text primary key,
  project_id text not null references public.projects(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
create index if not exists versions_project_idx on public.versions(project_id);

create table if not exists public.invites (
  id text primary key,                    -- the private code in the client's link
  project_id text not null references public.projects(id) on delete cascade,
  payload jsonb not null,
  updated_at timestamptz not null default now()
);
create index if not exists invites_project_idx on public.invites(project_id);

create table if not exists public.project_access (
  project_id text not null references public.projects(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (project_id, user_id)
);

create table if not exists public.briefs (       -- the client's own answers and approval
  id text primary key references public.projects(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.issued (       -- the brief version sent to the client
  id text primary key references public.projects(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

-- ---------- table access for the app ----------
-- Newer Supabase projects don't open new tables to the app automatically.
-- These grants let the app reach its tables; the access rules further down
-- still decide exactly who can see and change each row.
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.settings, public.projects, public.versions, public.invites, public.briefs, public.issued to authenticated;
grant select, delete on public.project_access to authenticated;
grant select on public.admins to authenticated;
grant select on public.settings to anon;

-- ---------- helper functions ----------
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins where user_id = auth.uid());
$$;

create or replace function public.has_access(pid text)
returns boolean language sql stable security definer set search_path = public as $$
  select public.is_admin()
      or exists (select 1 from public.project_access where project_id = pid and user_id = auth.uid());
$$;

-- Look at an invitation before accepting it (works without signing in).
create or replace function public.peek_invite(p_code text)
returns jsonb language plpgsql stable security definer set search_path = public as $$
declare inv public.invites;
begin
  select * into inv from public.invites where id = p_code;
  if not found then return null; end if;
  return jsonb_build_object(
    'pid', inv.project_id,
    'payload', inv.payload,
    'claimed', auth.uid() is not null and exists (
      select 1 from public.project_access where project_id = inv.project_id and user_id = auth.uid()));
end $$;

-- Accept an invitation: gives this browser access to the one project.
create or replace function public.claim_invite(p_code text, p_consent jsonb)
returns text language plpgsql security definer set search_path = public as $$
declare
  inv public.invites;
  ms bigint := (extract(epoch from now()) * 1000)::bigint;
begin
  if auth.uid() is null then raise exception 'Sign-in required'; end if;
  select * into inv from public.invites where id = p_code;
  if not found then return null; end if;
  insert into public.project_access(project_id, user_id) values (inv.project_id, auth.uid())
    on conflict do nothing;
  insert into public.briefs(id, data) values (inv.project_id, jsonb_build_object(
      'pid', inv.project_id,
      'ref', inv.payload->>'ref',
      'answers', coalesce(inv.payload->'answers', '{}'::jsonb),
      'status', 'in_progress',
      'startedAt', ms,
      'updatedAt', ms,
      'consent', p_consent))
    on conflict (id) do nothing;
  return inv.project_id;
end $$;

revoke all on function public.claim_invite(text, jsonb) from public, anon;
grant execute on function public.claim_invite(text, jsonb) to authenticated;
grant execute on function public.peek_invite(text) to anon, authenticated;
grant execute on function public.is_admin() to anon, authenticated;
grant execute on function public.has_access(text) to authenticated;

-- Lets the app's connection check see whether setup is finished (true/false only).
create or replace function public.studio_ready()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.admins);
$$;
grant execute on function public.studio_ready() to anon, authenticated;

-- ---------- row level security ----------
alter table public.admins enable row level security;
alter table public.settings enable row level security;
alter table public.projects enable row level security;
alter table public.versions enable row level security;
alter table public.invites enable row level security;
alter table public.project_access enable row level security;
alter table public.briefs enable row level security;
alter table public.issued enable row level security;

drop policy if exists admins_self on public.admins;
create policy admins_self on public.admins for select to authenticated using (user_id = auth.uid());

drop policy if exists settings_read on public.settings;
create policy settings_read on public.settings for select to anon, authenticated using (true);
drop policy if exists settings_write on public.settings;
create policy settings_write on public.settings for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists projects_studio on public.projects;
create policy projects_studio on public.projects for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists versions_studio on public.versions;
create policy versions_studio on public.versions for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists invites_studio on public.invites;
create policy invites_studio on public.invites for all to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists access_read on public.project_access;
create policy access_read on public.project_access for select to authenticated using (user_id = auth.uid() or public.is_admin());
drop policy if exists access_studio_delete on public.project_access;
create policy access_studio_delete on public.project_access for delete to authenticated using (public.is_admin());

drop policy if exists briefs_read on public.briefs;
create policy briefs_read on public.briefs for select to authenticated using (public.has_access(id));
drop policy if exists briefs_insert on public.briefs;
create policy briefs_insert on public.briefs for insert to authenticated with check (public.has_access(id));
drop policy if exists briefs_update on public.briefs;
create policy briefs_update on public.briefs for update to authenticated using (public.has_access(id)) with check (public.has_access(id));
drop policy if exists briefs_delete on public.briefs;
create policy briefs_delete on public.briefs for delete to authenticated using (public.is_admin());

drop policy if exists issued_read on public.issued;
create policy issued_read on public.issued for select to authenticated using (public.has_access(id));
drop policy if exists issued_studio on public.issued;
create policy issued_studio on public.issued for all to authenticated using (public.is_admin()) with check (public.is_admin());

-- ---------- live updates ----------
do $$
declare t text;
begin
  foreach t in array array['projects','versions','briefs','issued','settings'] loop
    begin
      execute format('alter publication supabase_realtime add table public.%I', t);
    exception when duplicate_object then null;
              when undefined_object then null;
    end;
  end loop;
end $$;

-- ---------- file storage (private) ----------
insert into storage.buckets (id, name, public, file_size_limit)
values ('brief-files', 'brief-files', false, 52428800)
on conflict (id) do nothing;

drop policy if exists brief_files_read on storage.objects;
create policy brief_files_read on storage.objects for select to authenticated
  using (bucket_id = 'brief-files' and public.has_access((storage.foldername(name))[1]));
drop policy if exists brief_files_insert on storage.objects;
create policy brief_files_insert on storage.objects for insert to authenticated
  with check (bucket_id = 'brief-files' and public.has_access((storage.foldername(name))[1]));
drop policy if exists brief_files_update on storage.objects;
create policy brief_files_update on storage.objects for update to authenticated
  using (bucket_id = 'brief-files' and public.has_access((storage.foldername(name))[1]));
drop policy if exists brief_files_delete on storage.objects;
create policy brief_files_delete on storage.objects for delete to authenticated
  using (bucket_id = 'brief-files' and public.has_access((storage.foldername(name))[1]));

-- ---------- make your login the studio account ----------
-- The first time this runs, every login that already exists (not clients)
-- becomes a studio account. After that it adds no one, so running the file
-- again is safe. To add a freelancer later, see the setup guide.
insert into public.admins (user_id)
select id from auth.users
where coalesce(is_anonymous, false) = false
  and not exists (select 1 from public.admins)
on conflict do nothing;
