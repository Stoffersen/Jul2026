-- FINAL CUP HARDENING (v6 + v7)
-- Run once in Supabase SQL Editor after the existing schema.
-- Safe to run again: functions are CREATE OR REPLACE and existing results are untouched.

-- Server-side December 2026 calendar enforcement.
-- The server, not the browser, decides whether a December challenge is open.
create or replace function public.cup_day_is_open(p_day smallint)
returns boolean
language sql stable
set search_path=public
as $$
  select p_day between 1 and 24
    and (clock_timestamp() at time zone 'Europe/Copenhagen')::date
        >= make_date(2026,12,p_day);
$$;
revoke all on function public.cup_day_is_open(smallint) from public;

create or replace function public.start_cup_day(p_day smallint)
returns timestamptz
language plpgsql security definer set search_path=public
as $$
declare v_started timestamptz;
begin
 if auth.uid() is null then raise exception 'Not authenticated'; end if;
 if p_day not between 1 and 24 then raise exception 'Invalid day'; end if;
 if not public.cup_day_is_open(p_day) then raise exception 'Day not open yet'; end if;
 if exists(select 1 from public.cup_attempts where user_id=auth.uid() and day=p_day) then raise exception 'Already played'; end if;
 insert into public.cup_starts(user_id,day) values(auth.uid(),p_day)
 on conflict(user_id,day) do nothing;
 select started_at into v_started from public.cup_starts where user_id=auth.uid() and day=p_day;
 return v_started;
end; $$;
revoke all on function public.start_cup_day(smallint) from public;
grant execute on function public.start_cup_day(smallint) to authenticated;

create or replace function public.submit_cup_answer(p_day smallint,p_answer smallint)
returns table(correct boolean,elapsed_ms integer)
language plpgsql security definer set search_path=public
as $$
declare v_correct boolean; v_started timestamptz; v_ms integer;
begin
 if auth.uid() is null then raise exception 'Not authenticated'; end if;
 if p_day not between 1 and 24 or p_answer not between 0 and 3 then raise exception 'Invalid answer'; end if;
 if not public.cup_day_is_open(p_day) then raise exception 'Day not open yet'; end if;
 if exists(select 1 from public.cup_attempts where user_id=auth.uid() and day=p_day) then raise exception 'Already played'; end if;
 select started_at into v_started from public.cup_starts where user_id=auth.uid() and day=p_day;
 if v_started is null then raise exception 'Round not started'; end if;
 v_ms:=floor(extract(epoch from (clock_timestamp()-v_started))*1000)::integer;
 if v_ms<250 or v_ms>120000 then raise exception 'Invalid elapsed time'; end if;
 select correct_answer=p_answer into v_correct from public.cup_challenges where day=p_day;
 insert into public.cup_attempts(user_id,day,correct,elapsed_ms) values(auth.uid(),p_day,v_correct,v_ms);
 delete from public.cup_starts where user_id=auth.uid() and day=p_day;
 return query select v_correct,v_ms;
end; $$;
revoke all on function public.submit_cup_answer(smallint,smallint) from public;
grant execute on function public.submit_cup_answer(smallint,smallint) to authenticated;


-- Recover safely from abandoned Cup rounds.
-- A start older than 120 seconds has already become un-submittable, so a new
-- explicit Start action may replace it without granting an extra scored attempt.
create or replace function public.start_cup_day(p_day smallint)
returns timestamptz
language plpgsql security definer set search_path=public
as $$
declare v_started timestamptz;
begin
 if auth.uid() is null then raise exception 'Not authenticated'; end if;
 if p_day not between 1 and 24 then raise exception 'Invalid day'; end if;
 if not public.cup_day_is_open(p_day) then raise exception 'Day not open yet'; end if;
 if exists(select 1 from public.cup_attempts where user_id=auth.uid() and day=p_day) then raise exception 'Already played'; end if;

 select started_at into v_started
 from public.cup_starts
 where user_id=auth.uid() and day=p_day;

 if v_started is not null and clock_timestamp()-v_started > interval '120 seconds' then
   delete from public.cup_starts where user_id=auth.uid() and day=p_day;
   v_started:=null;
 end if;

 if v_started is null then
   insert into public.cup_starts(user_id,day) values(auth.uid(),p_day)
   returning started_at into v_started;
 end if;

 return v_started;
end; $$;
revoke all on function public.start_cup_day(smallint) from public;
grant execute on function public.start_cup_day(smallint) to authenticated;
