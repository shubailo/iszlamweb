-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Reset (Optional - use carefully)
drop table if exists public.books cascade;
drop table if exists public.khutbas cascade;
drop table if exists public.library_categories cascade;
-- drop table if exists public.profiles cascade; -- Uncomment if you want to reset profiles too

-- 1. Create tables
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  is_admin boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

alter table public.profiles enable row level security;
-- Helper function to check admin status without recursion
create or replace function public.is_admin()
returns boolean as $$
begin
  return exists (
    select 1 from public.profiles 
    where id = (select auth.uid()) 
    and is_admin = true
  );
end;
$$ language plpgsql security definer set search_path = '';

create policy "View profiles" on public.profiles for select using (
  (select auth.uid()) = id or public.is_admin()
);

-- Trigger to create profile on signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer set search_path = '';

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Category Policies
create policy "Public Read Categories" on public.library_categories for select using (true);
create policy "Admin Insert Categories" on public.library_categories for insert with check (public.is_admin());
create policy "Admin Update Categories" on public.library_categories for update using (public.is_admin());
create policy "Admin Delete Categories" on public.library_categories for delete using (public.is_admin());

-- Book Policies
create policy "Public Read Books" on public.books for select using (true);
create policy "Admin Insert Books" on public.books for insert with check (public.is_admin());
create policy "Admin Update Books" on public.books for update using (public.is_admin());
create policy "Admin Delete Books" on public.books for delete using (public.is_admin());

-- Khutba Policies
create policy "Public Read Khutbas" on public.khutbas for select using (true);
create policy "Admin Insert Khutbas" on public.khutbas for insert with check (public.is_admin());
create policy "Admin Update Khutbas" on public.khutbas for update using (public.is_admin());
create policy "Admin Delete Khutbas" on public.khutbas for delete using (public.is_admin());

-- 4. Storage Buckets
-- Create buckets if they don't exist
insert into storage.buckets (id, name, public, file_size_limit) 
values ('library_files', 'library_files', true, 52428800) -- 50MB limit
on conflict (id) do update set file_size_limit = 52428800;

insert into storage.buckets (id, name, public, file_size_limit) 
values ('covers', 'covers', true, 5242880) -- 5MB limit
on conflict (id) do update set file_size_limit = 5242880;

-- Storage Policies
-- Allow public read
create policy "Public Access Library Files" on storage.objects for select using ( bucket_id = 'library_files' );
create policy "Public Access Covers" on storage.objects for select using ( bucket_id = 'covers' );

-- Allow Admin write
create policy "Admin Upload Library Files" on storage.objects for insert with check (
  bucket_id = 'library_files' and public.is_admin()
);
create policy "Admin Upload Covers" on storage.objects for insert with check (
  bucket_id = 'covers' and public.is_admin()
);
