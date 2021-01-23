/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================

*/

-- 删除车站
create or replace function del_station(del_station_name varchar)
    returns text
    language plpgsql
as
$$
BEGIN
    if (del_station_name not in (select station_name from stations)) then
        return '无此车站';
    end if;
    delete from stations where station_name = del_station_name;
    return '删除车站成功';
exception
    when others then
        return '删除失败，请检查是否有与此站相关的车次';
end
$$;
