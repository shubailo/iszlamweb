-- 1. Ensure profile exists (backfill for existing user)
insert into public.profiles (id, email)
select id, email from auth.users where email = 'admin@iszlam.com'
on conflict (id) do nothing;

-- 2. Grant admin privileges
update public.profiles
set is_admin = true
where email = 'admin@iszlam.com';

-- 3. Verify
select * from public.profiles where email = 'admin@iszlam.com';
