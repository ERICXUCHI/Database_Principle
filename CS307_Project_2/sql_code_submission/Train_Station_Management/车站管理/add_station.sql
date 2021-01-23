
/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
-- 先建一个车站
*/

drop function add_station(add_station_name varchar);

create or replace function add_station(add_station_name varchar)
    returns varchar
    language plpgsql
as
$$
BEGIN
    begin
    insert into stations(station_name) values (add_station_name);
    return '新建车站成功';
    exception
        when others then
        begin
        return '新建车站失败';
        end;
    end;
end;
$$;
