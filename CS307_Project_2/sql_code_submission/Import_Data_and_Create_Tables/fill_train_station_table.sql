/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
    @Some Operation to winnow usable information
*/

-- update / add more stations to table: stations
insert into stations (station_name)
select distinct station_name
from temp_table
where station_name not in (select station_name from stations);

-- number of stations
select count(*)
from (
     select distinct station_name
from stations) c;


create or replace function cast_varchar_time(d varchar) returns time
    language plpgsql
as
$$
begin
    return cast(d as time);
    exception
    when others then
        return null;
    -- todo: implement
end;
$$;

select arr
from (select cast_varchar_time(arr_time) arr
from temp_table
) t;


-- select necessary data
select distinct on (tr.train_id, te.station_index)
        tr.train_id, te.station_index, st.station_id,
       cast_varchar_time(arr_time), cast_varchar_time(start_time),
       te.arr_day, te.interval_km, te.first_price, te.second_price
from temp_table te
    join trains tr on tr.train_num = te.train_no
    join stations st on st.station_name = te.station_name;

-- insert into my train_station table
insert into train_station (train_id,
                           station_index, station_id,
                           arr_time, depart_time, arr_day,
                           interval_km, first_price, second_price)
select distinct on (tr.train_id, te.station_index)
        tr.train_id, te.station_index, st.station_id,
       cast_varchar_time(arr_time), cast_varchar_time(start_time),
       te.arr_day, te.interval_km, te.first_price, te.second_price
from temp_table te
    join trains tr on tr.train_num = te.train_no
    join stations st on st.station_name = te.station_name;


-- Initialize Seats for every trains
-- both first/second class: 200/800
-- one class: 1000

update train_station
set first_remain = 0,
    second_remain = 1000
where train_id in (
    select distinct train_id
        from train_station
        where first_price = 0 and station_index != 1 and second_price != 0
    );

update train_station
set first_remain = 1000,
    second_remain = 0
where train_id in (
    select distinct train_id
        from train_station
        where second_price = 0 and station_index != 1 and first_price != 0
    );

update train_station
set first_remain = 200,
    second_remain = 800
where train_id in (
    select distinct train_id
        from train_station
        where second_price != 0 and station_index != 1 and first_price != 0
    );

-- check

select train_id
from train_station
where second_remain + first_remain != 1000;

select arr_time
from temp_table
where arr_time not like '__:__' and arr_time != '始发站';

select train_id, train_no
from temp_table
    join trains tr on temp_table.train_no = tr.train_num
limit 100;


