-- نفّذ هذا الملف مرة واحدة من Supabase > SQL Editor.
create table if not exists public.students (
 id uuid primary key default gen_random_uuid(),
 name text not null check (char_length(name) between 1 and 100),
 student_group text,
 created_at timestamptz not null default now()
);
create table if not exists public.attendance (
 id uuid primary key default gen_random_uuid(),
 student_id uuid not null references public.students(id) on delete cascade,
 attendance_date date not null,
 status text not null check (status in ('present','absent')),
 marked_by uuid not null references auth.users(id),
 created_at timestamptz not null default now(),
 unique(student_id,attendance_date)
);
alter table public.students enable row level security;
alter table public.attendance enable row level security;
drop policy if exists "Authenticated users can view students" on public.students;
drop policy if exists "Authenticated users can add students" on public.students;
drop policy if exists "Authenticated users can delete students" on public.students;
drop policy if exists "Authenticated users can view attendance" on public.attendance;
drop policy if exists "Authenticated users can add attendance" on public.attendance;
drop policy if exists "Authenticated users can update attendance" on public.attendance;
create policy "Authenticated users can view students" on public.students for select to authenticated using (true);
create policy "Authenticated users can add students" on public.students for insert to authenticated with check (true);
create policy "Authenticated users can delete students" on public.students for delete to authenticated using (true);
create policy "Authenticated users can view attendance" on public.attendance for select to authenticated using (true);
create policy "Authenticated users can add attendance" on public.attendance for insert to authenticated with check (auth.uid() = marked_by);
create policy "Authenticated users can update attendance" on public.attendance for update to authenticated using (true) with check (auth.uid() = marked_by);
grant usage on schema public to authenticated;
grant select,insert,delete on public.students to authenticated;
grant select,insert,update on public.attendance to authenticated;
