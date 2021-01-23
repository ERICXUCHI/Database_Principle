/*
  退票，已验证可用，输入所要退票的ID号
  set status = 0 if the tickets have been refund
  seat_type = 1 ->  or 2 ->
 */
create or replace function refund_ticket(refund_id int)
    returns text
    language plpgsql
as
$$
DECLARE
    result           record;
    begin_station_index int;
    end_station_index   int;
    seat_type        char;
    get_state        char;
BEGIN
    select tk.status
    from tickets tk
    where tk.ticket_id = refund_id
    into get_state;

    if (get_state = '0') then
        return '退票失败，已经退票';
    end if;

    if (refund_id not in (select ticket_id from tickets)) then
        return '退票失败，无此票';
    end if;

    update tickets set status ='0' where ticket_id = refund_id;

--   找到 出发站和到达站对应的index
    for result in (
        select ts1.station_index s1_no, ts2.station_index s2_no, tk.seat_type st
        from tickets tk
                 join train_station ts1 on tk.train_id = ts1.train_id
                 join train_station ts2 on tk.train_id = ts2.train_id
        where ts1.station_id = tk.depart_train_station
          and ts2.station_id = tk.arrive_train_station
    )
        LOOP
            begin_station_index := result.s1_no;
            end_station_index := result.s2_no;
            seat_type := result.st;
        end loop;


-- 补充 ticket 到 train_station 表中
    if (seat_type = '1') then
        UPDATE train_station ts3
        set first_remain = first_remain + 1
        where ts3.id in (
            select ts.id
            from train_station ts
                     join tickets tk on tk.train_id = ts.train_id
                and ts.station_index >= begin_station_index and ts.station_index < end_station_index);
    end if;

    if (seat_type = '2') then
        UPDATE train_station ts3
        set second_remain = second_remain + 1
        where ts3.id in (
            select ts.id
            from train_station ts
                     join tickets tk on tk.train_id = ts.train_id
                and ts.station_index >= begin_station_index and ts.station_index < end_station_index);
    end if;
    return '退票成功';
exception
    when others then
        return '退票失败';
end;
$$;
