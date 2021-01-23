/***
  dptStation 车站名字 return query version
*/
drop function if exists search_tickets_by_station_date(dptStation varchar, arrStation varchar, dptDate date);
create or replace function search_tickets_by_station_date(dptStation varchar, arrStation varchar, dptDate date)
returns table
            (
                train_num        varchar,
                train_id        int,
                dpt_station_name varchar,
                dpt_origin_time         varchar,
                arr_station_name varchar,
                arr_destination_time  varchar,
                execution_time    text,
                first_price     numeric,
                second_price    numeric,
                first_remain    int,
                second_remain   int,
                station_index      int,
                station_name    varchar,
                arr_time        text,
                depart_time      text,
                time_diff       text
            )
    language plpgsql
as
$$
DECLARE
    dptcode int;   -- station_id
    arrcode int;
BEGIN

    select (select s.station_id
            from stations s
            where s.station_name = dptStation)
    into dptcode;

    select (select s.station_id
            from stations s
            where s.station_name = arrStation)
    into arrcode;

    return query
--      获得能到目的地的列车信息 在给定 出发站、到达站
        with train_number as (
            select t.train_id                                                                      train_id,
                   t.train_num                                                                     train_no,
                   s1.station_name                                                                 dptStation,
                   ts1.station_index                                                               dptStation_no,
                   ts1.depart_time                                                                 dptTime,
                   s2.station_name                                                                 arrStation,
                   ts2.station_index                                                               arrStation_no,
                   ts2.arr_time                                                                    arrTime,
                   ts2.arr_day - ts1.arr_day                                                       arr_day,
                   round(cast(ts2.first_price as numeric) - cast(ts1.first_price as numeric), 2)   first_price,
                   round(cast(ts2.second_price as numeric) - cast(ts1.second_price as numeric), 2) second_price
            from trains t
                     join train_station ts1 on t.train_id = ts1.train_id
                     join train_station ts2 on t.train_id = ts2.train_id
                     join stations s1 on s1.station_id = dptcode and ts1.station_id = s1.station_id
                     join stations s2 on s2.station_id = arrcode and ts2.station_id = s2.station_id
            where t.start_date + ts1.arr_day - 1 = dptDate
              and ts1.station_index < ts2.station_index)
-- 与余票信息合并 并 返回
        select
                sub.train_no,
                sub.train_id,
                sub.dptStation,
                cast(to_char(sub.dptTime, 'HH24:MI') as varchar),
                sub.arrStation ,
                cast(to_char(sub.arrTime, 'HH24:MI') as varchar),
                sub.excution_time   ,
                sub.first_price     ,
                sub.second_price    ,
                sub.first_remain    ,
                sub.second_remain   ,
                sub2.station_no      ,
                sub2.station_name    ,
                sub2.arr_time        ,
                sub2.start_time      ,
                sub2.time_diff

        from (select tn.train_no          as train_no,
                     tn.train_id          as train_id,
                     tn.dptStation        as dptStation,
                     tn.dptTime           as dptTime,
                     tn.arrStation        as arrStation,
                     tn.arrTime           as arrTime,
                     to_char(tn.arrTime - tn.dptTime + (cast(tn.arr_day * 24 as text) || ' hour')::interval,
                             'HH24小时MI分') as excution_time,
                     x.first_remain       as first_remain,
                     tn.first_price       as first_price,
                     x.second_remain      as second_remain,
                     tn.second_price      as second_price
              from train_number tn
                       join (
                  select t.train_num, min(ts.first_remain) as first_remain, min(ts.second_remain) as second_remain
                  from trains t
                           join train_number tn on t.train_id = tn.train_id
                           join train_station ts on t.train_id = ts.train_id
                  where ts.station_index between tn.dptStation_no and tn.arrStation_no
                  group by t.train_num) x on x.train_num = tn.train_no) sub
                 left join (
            select ts.station_index                               as station_no,
                   s.station_name                              as station_name,
                   to_char(ts.arr_time, 'HH24:MI')             as arr_time,
                   to_char(ts.depart_time, 'HH24:MI')           as start_time,
                   to_char(ts.depart_time - ts.arr_time, 'MI分') as time_diff,
                   ts.train_id                                 as train_id
            from train_station ts
                     join stations s on ts.station_id = s.station_id
        ) sub2
                           on sub2.train_id = sub.train_id
        order by (sub.train_id, sub.dptTime, sub2.station_no);


end;
$$;


select * from search_tickets_by_station_date('北京西', '长沙南', '2020-12-30');
select * from search_tickets_by_station_date('广州南', '北京西', '2020-12-30');

select * from search_tickets_by_station_date_simple('广州南', '北京西', '2020-12-30');


insert into train_station(id, train_id, station_index, station_id, arr_time, depart_time, arr_day, entrance, interval_km, first_price, second_price, first_remain, second_remain)

select station_name from stations
where station_name like '广州%';


select * from search_tickets_by_station_date('北京西', '广州南', '2020-12-30');

drop function  search_tickets_by_station_date_concise(dptStation varchar, arrStation varchar, dptDate date);

create or replace function search_tickets_by_station_date_concise(input_dptStation varchar, input_arrStation varchar, dptDate date)
returns table
            (
                train_num        varchar,
                train_id        int,
                dpt_station_name varchar,
                dpt_time         varchar,
                arr_station_name varchar,
                arr_destination_time  varchar,
                execution_time    text,
                first_price     numeric,
                second_price    numeric,
                first_remain    int,
                second_remain   int,
                station_index      int,
                station_name    varchar,
                arr_time        text,
                depart_time      text,
                time_diff       text,
                min_first_remain int,
                min_second_remain int
            )
    language plpgsql
as
$$
DECLARE
    dptcode int;   -- station_id
    arrcode int;
BEGIN

    select (select s.station_id
            from stations s
            where s.station_name = input_dptStation)
    into dptcode;

    select (select s.station_id
            from stations s
            where s.station_name = input_arrStation)
    into arrcode;

    return query
--      获得能到目的地的列车信息 在给定 出发站、到达站
        with train_number as (
            select t.train_id                                                                      train_id,
                   t.train_num                                                                     train_no,
                   s1.station_name                                                                 dptStation,
                   ts1.station_index                                                               dptStation_no,
                   ts1.depart_time                                                                 dptTime,
                   s2.station_name                                                                 arrStation,
                   ts2.station_index                                                               arrStation_no,
                   ts2.arr_time                                                                    arrTime,
                   ts2.arr_day - ts1.arr_day                                                       arr_day,
                   round(cast(ts2.first_price as numeric) - cast(ts1.first_price as numeric), 2)   first_price,
                   round(cast(ts2.second_price as numeric) - cast(ts1.second_price as numeric), 2) second_price
            from trains t
                     join train_station ts1 on t.train_id = ts1.train_id
                     join train_station ts2 on t.train_id = ts2.train_id
                     join stations s1 on s1.station_id = dptcode and ts1.station_id = s1.station_id
                     join stations s2 on s2.station_id = arrcode and ts2.station_id = s2.station_id
            where t.start_date + ts1.arr_day - 1 = dptDate
              and ts1.station_index < ts2.station_index)
-- 与余票信息合并 并 返回
        select
                 ss2.train_no,
                 ss2.train_id ,
                 ss2.dptStation,
                 ss2.dptTime,
                 ss2.arrStation,
                 ss2.arrTime,
                 ss2.excution_time,
                 ss2.first_price,
                 ss2.second_price,
                 ss2.first_remain,
                 ss2.second_remain,
                 ss2.station_no,
                 ss2.station_name,
                 ss2.arr_time,
                 ss2.start_time,
                 ss2.time_diff,
                min(ss2.first_remain) over (partition by ss2.train_id) as min_first_remain,
                min(ss2.second_remain) over (partition by ss2.train_id) as min_second_remain
        from (
                 select sub.train_no,
                        sub.train_id,
                        sub.dptStation,
                        cast(to_char(sub.dptTime, 'HH24:MI') as varchar) as dptTime,
                        sub.arrStation,
                        cast(to_char(sub.arrTime, 'HH24:MI') as varchar) as arrTime,
                        sub.excution_time,
                        sub.first_price,
                        sub.second_price,
                        sub.first_remain,
                        sub.second_remain,
                        sub2.station_no,
                        sub2.station_name,
                        sub2.arr_time,
                        sub2.start_time,
                        sub2.time_diff

                 from (select tn.train_no          as train_no,
                              tn.train_id          as train_id,
                              tn.dptStation        as dptStation,
                              tn.dptTime           as dptTime,
                              tn.arrStation        as arrStation,
                              tn.arrTime           as arrTime,
                              to_char(tn.arrTime - tn.dptTime + (cast(tn.arr_day * 24 as text) || ' hour')::interval,
                                      'HH24小时MI分') as excution_time,
                              x.first_remain       as first_remain,
                              tn.first_price       as first_price,
                              x.second_remain      as second_remain,
                              tn.second_price      as second_price
                       from train_number tn
                                join (
                           select t.train_num,
                                  min(ts.first_remain)  as first_remain,
                                  min(ts.second_remain) as second_remain
                           from trains t
                                    join train_number tn on t.train_id = tn.train_id
                                    join train_station ts on t.train_id = ts.train_id
                           where ts.station_index between tn.dptStation_no and tn.arrStation_no
                           group by t.train_num) x on x.train_num = tn.train_no) sub
                          left join (
                     select ts.station_index                             as station_no,
                            s.station_name                               as station_name,
                            to_char(ts.arr_time, 'HH24:MI')              as arr_time,
                            to_char(ts.depart_time, 'HH24:MI')           as start_time,
                            to_char(ts.depart_time - ts.arr_time, 'MI分') as time_diff,
                            ts.train_id                                  as train_id
                     from train_station ts
                              join stations s on ts.station_id = s.station_id
                 ) sub2
                                    on sub2.train_id = sub.train_id
                 order by (sub.train_id, sub.dptTime, sub2.station_no)
             ) as ss2
                    where ss2.station_name = input_dptStation or ss2.station_name = input_arrStation;

end;
$$;

select * from search_tickets_by_station_date_concise('北京西', '广州南', '2020-12-30');
select * from search_tickets_by_station_date('北京西', '广州南', '2020-12-30');


drop function search_tickets_by_station_date_final(input_dptstation varchar, input_arrstation varchar, dptdate date);

create or replace function  search_tickets_by_station_date_final(input_dptStation varchar, input_arrStation varchar, dptDate date)
    returns table
            (
                train_num        varchar,
                train_id        int,
                dpt_station_name varchar,
                dpt_origin_time   varchar,
                arr_station_name varchar,
                arr_destination_time  varchar,
                execution_time    text,
                first_price     numeric,
                second_price    numeric,
                first_remain    int,
                second_remain   int,
                dpt_station_index   int,
                arr_station_index int,
                min_first_remain int,
                min_second_remain int
            )
    language plpgsql
as
$$
begin
        return query
        with temp_table as (
            select * from search_tickets_by_station_date_concise(input_dptStation, input_arrStation, dptDate)
        )
        select t1.train_num as train_num, t1.train_id, t1.dpt_station_name, t1.dpt_time as dpt_origin_time , t1.arr_station_name, t1.arr_destination_time, t1.execution_time,
           t1.first_price, t1.second_price, t1.first_remain, t1.second_remain, t1.station_index as dpt_station_index , t2.station_index as arr_station_index,
            t1.min_first_remain, t2.min_second_remain
        from temp_table t1 join temp_table t2 on t1.train_num = t2.train_num and t1.station_index < t2.station_index;
end;
$$;


