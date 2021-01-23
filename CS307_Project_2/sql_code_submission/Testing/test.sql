-- 信息无误 尝试进行购票操作--

drop function test_1(trainNo varchar, dptDate varchar);
create or replace function test_1(trainNo varchar, dptDate varchar) returns varchar
    language plpgsql
as
$$
    DECLARE
    get_userid           int;
    info                 record;
    get_train_id         int;
    get_start_station_id int;
    get_end_station_id   int;
    get_start_no         int:=1;
    get_end_no           int:=3;
    get_first_price      varchar;
    get_second_price     varchar;
    get_first_remain     int;
    get_second_remain    int;
    carriage_seat        varchar;
    get_carriage_info    int;
    get_seat_info        varchar;
    get_seat_type        char;
    get_price            varchar;
    i                    int := 1;
    temp                 int := 0;
begin
--         return 1;
    for info in (
    select t.train_id                                                                      train_id,
           t.train_num                                                                      train_no,
           ts1.station_id                                                                   dptStation,
           ts2.station_id                                                                   arrStation,
           round(cast(ts2.first_price as numeric) - cast(ts1.first_price as numeric), 2)   first_price,
           round(cast(ts2.second_price as numeric) - cast(ts1.second_price as numeric), 2) second_price
    from trains t
             join train_station ts1 on t.train_id = ts1.train_id
             join train_station ts2 on t.train_id = ts2.train_id
    where t.train_num = trainNo
      and t.start_date + ts1.arr_day - 1 = to_date(dptDate, 'YYYY-MM-DD')
      and ts1.station_index = get_start_no
      and ts2.station_index = get_end_no)
    LOOP
        get_train_id := info.train_id;
        get_start_station_id := info.dptStation;
        get_end_station_id := info.arrStation;
        get_first_price := cast(info.first_price as varchar);
        get_second_price := cast(info.second_price as varchar);
    end loop;
    return  info.train_id;


    -- todo: implement
end;
$$;



drop function test_2(arg1 int, s int, e int);
create or replace function test_2(arg1 int, s int, e int) returns int
    language plpgsql
as
$$
    declare f int:= 0;
    declare second int;
begin
    select first_remain, second_remain
    into f, second
    from check_remain_tickets(arg1, s, e);
    return second;
    -- todo: implement
end;
$$;

select * from test_2(33333,1, 3);

select test_1('D1', '2020-12-23');



select t.train_id                                                                      train_id,
           t.train_num                                                                      train_no,
           ts1.station_id                                                                   dptStation,
           ts2.station_id                                                                   arrStation,
           round(cast(ts2.first_price as numeric) - cast(ts1.first_price as numeric), 2)   first_price,
           round(cast(ts2.second_price as numeric) - cast(ts1.second_price as numeric), 2) second_price
    from trains t
             join train_station ts1 on t.train_id = ts1.train_id
             join train_station ts2 on t.train_id = ts2.train_id
    where t.train_num = 'D1'
      and t.start_date + ts1.arr_day - 1 = to_date('2020-12-23', 'YYYY-MM-DD')
      and ts1.station_index = 1
      and ts2.station_index = 3;


select min(ts.first_remain) as first_remain, min(ts.second_remain) as second_remain
                 from trains t
                          join train_station ts on t.train_id = ts.train_id
                 where t.train_id = 35732
                   and ts.station_index between 1 and 3

