
/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
  @Param:
  trainNo: 车号 D1
  startTrainStation_no varchar: 出发站序号
  endTrainStation_no varchar: 到达站序号
  dptDate varchar: 'YYYY-MM-DD'
  seatType varchar: '一等座' or '二等座'
  userName varchar: 乘客名字
  idCardNumber char(18): 身份证号
  phoneNumber varchar: 电话号码
 */

drop function if exists buy_ticket(trainNo varchar, startTrainStation_no int, endTrainStation_no int,
dptDate varchar, seatType varchar, userName varchar, idCardNumber varchar, phoneNumber varchar);

create or replace function buy_ticket(trainNo varchar,
                                      startTrainStation_no int,
                                      endTrainStation_no int,
                                      dptDate varchar,
                                      seatType varchar,
                                      userName varchar,
                                      idCardNumber varchar(20),
                                      phoneNumber varchar)
    returns text
    language plpgsql
as
$$
DECLARE
    get_userid           int;
    info                 record;
    get_train_id         int;
    get_start_station_id int;
    get_end_station_id   int;
    get_start_no         int;
    get_end_no           int;
    get_first_price      varchar;
    get_second_price     varchar;
    get_first_remain     int;
    get_second_remain    int;
    carriage_seat        varchar;
    get_carriage_info    int;
    get_seat_info        varchar;
    get_seat_type        char;
    get_price            varchar;
    i int;
    temp int;
BEGIN

    get_start_no := startTrainStation_no::int;
    get_end_no := endTrainStation_no::int;

    if (trainNo not in (select trains.train_num from trains)) then
        return '不存在此车次';
    end if;


-- 检查身份信息 --
    if (substring(idCardNumber, 1, 6)) not in (select code from district) then
        return '身份信息输入错误';
    end if;
    if (length(idCardNumber) <> 18) then
        return '身份信息输入错误';
    end if;

--     perform substring(idCardNumber, 7, 8)::timestamp;
    if (to_date(substring(idCardNumber, 7, 8), 'YYYYMMDD') > current_date or
        to_date(substring(idCardNumber, 7, 8), 'YYYYMMDD') < to_date('1900-5-1', 'YYYY-MM-DD')
        ) then
        return '身份信息输入错误';
    end if;


-- 计算校验码 --
    while(i <= 17)
        LOOP
            temp = temp + (cast(pow(2, 18 - i) as integer) % 11) * cast(substring(idCardNumber, i, 1) as integer);
            i = i + 1;
        end loop;
    temp = (12 - temp % 11) % 11;
    if (temp = 10) then
        if (substring(idCardNumber, 18, 1)) != 'X' then
            return '身份信息输入错误';
        end if;
    else
        if (temp <> cast(substring(idCardNumber, 18, 1) as integer)) then
            return '身份信息输入错误';
        end if;
    end if;
    
-- 信息无误 尝试进行购票操作--
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

--     检查余票情况
    select first_remain, second_remain
        into get_first_remain, get_second_remain
        from check_remain_tickets(get_train_id, get_start_no, get_end_no);

    if (seatType = '一等座' and get_first_remain <= 0) then
        rollback;
        return '余票不足';
    end if;
    if (seatType = '二等座' and get_second_remain <= 0) then
        rollback;
        return '余票不足';
    end if;


-- 尝试将车票和身份信息插入 --
-- 若该乘客已经在表中则忽略
--     TODO: 有优化空间 先添加乘客 再买票
    insert into users (user_id_card_number, user_name, user_phone_number)
    values (idCardNumber, userName, phoneNumber)
    on conflict on constraint id_card_unique
        do nothing;

    select (select user_id from users where user_id_card_number = idCardNumber)
    into get_userid;

--     避免乘客重复购买同一车次的车票
    if (select count(*) from (
        select tickets.ticket_id from tickets
        where tickets.user_id = get_userid and tickets.train_id = get_train_id and tickets.status = 1)
        t) > 0 then
--         rollback;
--         raise exception 'haha';
-- TODO: 改回来
--         return '该车次已经购票';
    end if;



-- --     TODO: 有优化空间 先添加乘客 再买票

/***
随机安排一个座位 并避免冲突
假设有 10个车厢，每个车厢20排，每排坐5个人 ABCDE
*/
    select (select cast(temp_info.seat_carriage as int) || ',' ||
                   cast(temp_info.seat_no1 || temp_info.seat_no2 as varchar)
            from (select *
                  from (select generate_series(1, 10) seat_carriage) sub
                           cross join (select generate_series(1, 20) seat_no1) sub2
                           cross join (select substr('ABCDE', generate_series(1, 5), 1) seat_no2) sub3) temp_info
                except
            select t1.carriage_num || ',' || t1.seat_num
            from tickets t1
            where t1.train_id = get_train_id
              and t1.depart_train_station >= get_start_station_id
              and t1.arrive_train_station < get_end_station_id
              and t1.status = '1' -- 已经付款的
            limit 1)
    into carriage_seat;

    if (carriage_seat is null) then
        rollback;
        return '余票不足';
    end if;

    --     TODO: 检查 该车是否只有一等或二等 座位
--     对应 座位 - 1
    if (seatType = '一等座') then
        UPDATE train_station
        set first_remain = first_remain - 1
        where train_station.id in (
            select ts.id
            from train_station ts
            where ts.train_id = get_train_id
              and ts.station_index >= get_start_no and ts.station_index < get_end_no);
    end if;

    if (seatType = '二等座') then
        UPDATE train_station
        set second_remain = second_remain - 1
        where train_station.id in (
            select ts.id
            from train_station ts
            where ts.train_id = get_train_id
              and ts.station_index >= get_start_no and ts.station_index < get_end_no);
    end if;


    get_carriage_info := split_part(carriage_seat, ',', 1);
    get_seat_info := split_part(carriage_seat, ',', 2);

    if (seatType = '一等座') then
        get_price := get_first_price;
        get_seat_type := '1';
    end if;
    if (seatType = '二等座') then
        get_price := get_second_price;
        get_seat_type := '2';
    end if;

    insert into tickets(user_id, train_id, depart_train_station, arrive_train_station, carriage_num, seat_num, seat_type,
                       price, status)
    values ( get_userid, get_train_id, get_start_station_id, get_end_station_id
           , get_carriage_info, get_seat_info, get_seat_type, get_price, '1');

-- 检查是否有余票 --
    for info in (select min(ts.first_remain) as first_remain, min(ts.second_remain) as second_remain
                 from trains t
                          join train_station ts on t.train_id = ts.train_id
                 where t.train_id = get_train_id
                   and ts.station_index between get_start_no and get_end_no)
        LOOP
            get_first_remain = info.first_remain;
            get_second_remain = info.second_remain;
        end loop;


    if (seatType = '一等座' and get_first_remain < 0) then
        rollback;
        return '余票不足';
    end if;
    if (seatType = '二等座' and get_second_remain < 0) then
        rollback;
        return '余票不足';
    end if;
    return '购票成功';

exception
    when others then
        return '购票失败';
end
$$;
