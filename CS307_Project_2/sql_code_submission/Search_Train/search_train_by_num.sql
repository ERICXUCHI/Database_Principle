/***
    search train by train_num
 */

drop function if exists search_train_by_num(trainNo varchar, dptdate date);

create or replace function search_train_by_num(trainNo varchar, dptdate date)
    returns table
            (
                train_num        varchar,
                train_id        int,
                arr_day int,
                first_price     double precision,
                second_price    double precision,
                first_remain    int,
                second_remain   int,
                station_index      int,
                station_name    varchar,
                arr_time        varchar,
                depart_time      varchar,
                time_diff       varchar,
                interval_km double precision
            )
    language plpgsql
as
$$
DECLARE
    maxStationNo int;
    my_train_id int;
BEGIN
    select max(ts.station_index) over(), t.train_id
    from trains t
             join train_station ts on t.train_id = ts.train_id
    where t.train_num = trainNo
      and t.start_date = dptdate
    into maxStationNo, my_train_id;

    return query select
                tr.train_num,
                ts.train_id,
                ts.arr_day, -- 总运行时间
                ts.first_price,
                ts.second_price,
                ts.first_remain,
                ts.second_remain,
                ts.station_index,
                stat.station_name,
                cast(ts.arr_time as varchar),
                cast(ts.depart_time as varchar),
                cast((ts.depart_time - ts.arr_time) as varchar) as time_diff,
                ts.interval_km
    from train_station ts
        join stations stat on ts.station_id = stat.station_id
               join trains tr on ts.train_id = tr.train_id
    where ts.train_id = my_train_id
    order by ts.station_index;
end;
$$;
