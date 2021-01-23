

-- delete useless or error data
delete from temp_table
where train_no in (select distinct train_no
from temp_table
where (first_price is null or second_price is null) and arr_time != '始发站' and start_time != '终点站');

delete from temp_table
where train_no in (
    select distinct train_no
    from temp_table
        where arr_day not in (1, 2, 3, 4, 5));

delete from trains
where train_num in (
    select distinct train_no
    from temp_table
        where arr_day not in (1, 2, 3, 4, 5));


select * from trains;

select count(*)
from (
    select distinct train_no
        from temp_table) t;


-- 生成 trains 表
insert into trains (train_num, start_date)
select * from
              generate_trains( cast('2020-12-21' as date), 30);


-- generate unique trains 生成每辆列车
drop function generate_trains(date, integer);
create or replace function  generate_trains(date_start date, day_num int)
returns table(
    train_num varchar,
    start_date date
             )
    language plpgsql
as
$$
begin
    return query select distinct temp_table.train_no, d.start_date
    from temp_table
    cross join
    (select date_start + n as start_date
        from generate_series(1, day_num) n) d;
    -- todo: implement
end;
$$;

