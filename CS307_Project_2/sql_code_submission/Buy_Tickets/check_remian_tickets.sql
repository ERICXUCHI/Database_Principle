/***

====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
  @ check the # of remaining tickets
*/
drop function check_remain_tickets(input_train_id int, get_start_no int, get_end_no int);
create or replace function check_remain_tickets(input_train_id int, get_start_no int,  get_end_no int) returns
    table (
        first_remain int,
        second_remain int
          )
    language plpgsql
as
$$
begin
    -- 检查是否有余票 --
    return query  select min(ts.first_remain) as first_remain, min(ts.second_remain) as second_remain
    from trains t
              join train_station ts on t.train_id = ts.train_id
    where t.train_id = input_train_id
       and ts.station_index between get_start_no and get_end_no
    limit 1;
    -- todo: implement
end;
$$;

select second_remain, first_remain from check_remain_tickets(33333, 1,3) t;