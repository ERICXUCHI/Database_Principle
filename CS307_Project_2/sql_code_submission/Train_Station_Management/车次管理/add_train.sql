/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
    添加列车
*/

drop function if exists add_train(add_train_no varchar, add_dpt_date varchar, add_station_name varchar, add_arr_time varchar, add_dpt_time varchar, add_arr_day int, add_entrance varchar, add_interval_km varchar, add_first_price varchar, add_first_remain int, add_second_price varchar, add_second_remain int);
create or replace function add_train(add_train_no varchar, add_dpt_date varchar, add_station_name varchar,
                                     add_arr_time varchar, add_dpt_time varchar, add_arr_day int, add_entrance varchar,
                                     add_interval_km varchar, add_first_price varchar,
                                     add_first_remain int, add_second_price varchar, add_second_remain int)
    returns text
    language plpgsql
as
$$
DECLARE
    get_station_id     int; -- 添加站的车站 id
    get_train_id       int;
    get_max_station_no int;
    get_max_arr_day    int; -- 当前最大到达的天数
    get_max_time       time; -- 当前最大的时间
    get_max_interval   float; -- 当前最大里程
    get_arr_time       time;
    get_dpt_time       time;
    get_first_price    float;
    get_second_price   float;
    get_interval_mile  float;
BEGIN

    if (add_station_name not in (select station_name from stations)) then
        return '无此车站';
    end if;

    get_arr_time = null;
    get_dpt_time = null;

    if(add_arr_time <> 'null') then
        select (select (add_arr_time::time)) into get_arr_time;
    end if;
    if(add_dpt_time <> 'null') then
        select (select (add_dpt_time::time)) into get_dpt_time;
    end if;

    if (add_first_remain < 0 or add_first_remain > 1500 or add_second_remain < 0 or add_second_remain > 1500) then
        return '座位数量不合理';
    end if;

    select (select cast(add_first_price as float)) into get_first_price;
    select (select cast(add_second_price as float)) into get_second_price;
    select (select cast(add_interval_km as float)) into get_interval_mile;

    select (select s.station_id
            from stations s
            where s.station_name = add_station_name)
    into get_station_id;

--     插入新建的车次 进 trains表中
    insert into trains(train_num, start_date)
    values (add_train_no, to_date(add_dpt_date, 'YYYY-MM-DD'))
    on conflict on constraint train_unique
        do nothing;

    select (select t.train_id
            from trains t
            where t.train_num = add_train_no
              and t.start_date = to_date(add_dpt_date, 'YYYY-MM-DD'))
    into get_train_id;

--     得到当前最大的 station_index 的值
    select (select coalesce(max(ts.station_index), 0)
            from train_station ts
            where ts.train_id = get_train_id)
    into get_max_station_no;

    select (select coalesce(max(ts.arr_day), 0)
            from train_station ts
            where ts.train_id = get_train_id)
    into get_max_arr_day;


    select (select max(depart_time)
            from train_station ts
            where ts.train_id = get_train_id
              and ts.arr_day = get_max_arr_day)
    into get_max_time;

    select (select max(ts.interval_km)
            from train_station ts
            where ts.train_id = get_train_id)
    into get_max_interval;


    if (cast(add_interval_km as float) < get_max_interval) then
        return '已行驶的里程数不合理';
    end if;

    if (get_dpt_time < get_arr_time or add_arr_day < get_max_arr_day or
        (add_arr_day = get_max_arr_day and get_dpt_time < get_max_time)) then
        return '时间不合理';
    end if;

    insert into train_station(train_id, station_index, station_id, arr_time, depart_time, arr_day, entrance, interval_km,
                              first_price, second_price, first_remain, second_remain)
    values (get_train_id, get_max_station_no + 1, get_station_id, get_arr_time, get_dpt_time, add_arr_day, add_entrance,
            get_interval_mile,
            cast(add_first_price as double precision), cast(add_second_price as double precision), add_first_remain, add_second_remain);
    return '添加成功 ' || get_train_id;

exception
    when others then
        return '输入有误，无法添加';
end;
$$;