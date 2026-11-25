create table public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 role text not null default 'customer' check(role in ('customer','agent','admin')),
 display_name text
);
create table public.plans (
 id uuid primary key default gen_random_uuid(),
 carrier text not null, category text not null, title text not null,
 monthly_cents integer not null check(monthly_cents >= 0),
 active boolean not null default false,
 eligibility jsonb not null default '{}'
);
create table public.orders (
 id uuid primary key default gen_random_uuid(),
 customer_id uuid not null references auth.users(id),
 agent_id uuid references auth.users(id),
 plan_id uuid not null references public.plans(id),
 status text not null default 'order placed' check(status in ('order placed','processing','port request sent','completed','on hold','cancelled')),
 referral_name text, referral_type text check(referral_type in ('friend','agent','none')),
 created_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
alter table public.plans enable row level security;
alter table public.orders enable row level security;
create function public.is_admin() returns boolean language sql stable security definer set search_path = '' as $$ select exists(select 1 from public.profiles where id=auth.uid() and role='admin') $$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to authenticated;
create policy profile_read on public.profiles for select to authenticated using(id=auth.uid() or public.is_admin());
create policy plan_read on public.plans for select to anon, authenticated using(active);
create policy plan_admin on public.plans for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy order_read on public.orders for select to authenticated using(customer_id=auth.uid() or agent_id=auth.uid() or public.is_admin());
create policy order_admin on public.orders for all to authenticated using(public.is_admin()) with check(public.is_admin());
-- Customer order writes intentionally require a validated server endpoint.
-- Provision roles only through a trusted administrator. No client role updates.
