-- شغّل ده في Supabase: SQL Editor
create table if not exists public.exam_results (
  id bigint generated always as identity primary key,
  attempt_id uuid not null,
  student_name text not null check (char_length(student_name) between 1 and 120),
  stage text not null default 'submitted' check (stage in ('submitted','rated')),
  total_score int, total_max int, percent int,
  objective_score int, objective_max int,
  essay_score int, essay_max int,
  sections jsonb, essays jsonb,
  time_used_seconds int,
  auto_submitted boolean default false,
  created_at timestamptz not null default now()
);

alter table public.exam_results enable row level security;

-- الطلبة (anon) يقدروا يضيفوا نتيجة بس، ومحدش يقدر يقرا أو يعدّل أو يمسح
drop policy if exists "students can insert results" on public.exam_results;
create policy "students can insert results"
  on public.exam_results for insert to anon
  with check (true);

-- للقراءة: من لوحة Supabase (Table Editor) أو بحساب مدرّس مسجّل فقط.
-- أحدث نتيجة لكل محاولة:
-- select distinct on (attempt_id) * from public.exam_results order by attempt_id, created_at desc;
