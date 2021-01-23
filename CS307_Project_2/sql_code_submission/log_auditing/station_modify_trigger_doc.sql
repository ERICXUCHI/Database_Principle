create or replace function station_audit()
returns trigger
language plpgsql
as
$$
begin
    if tg_op='UPDATE'
    then
        insert into modify_log (table_name,primary_key,column_name,origin_value, new_value, edit_time,operation_type,editor)
        select table_name,old.station_id,column_name,from_value,to_value,current_timestamp,'U',cast(current_user as varchar)
        from(
            select 'station' table_name, 'station_id' column_name,
            cast(old.station_id as varchar) from_value,
            cast(new.station_id as varchar) to_value
            where old.station_id<>new.station_id
            union all
            select 'station' table_name, 'station_name' column_name,
            cast(old.station_name as varchar) from_value,
            cast(new.station_name as varchar) to_value
            where old.station_name<>new.station_name)modified;
    elsif tg_op='INSERT' then
        insert into modify_log (table_name,primary_key,column_name, new_value, edit_time,operation_type,editor)
        select table_name,new.station_id,column_name,to_value,current_timestamp,'I',cast(current_user as varchar)
        from(
            select 'station' table_name, 'station_id' column_name,
            cast(new.station_id as varchar) to_value
            union all
            select 'station' table_name, 'station_name' column_name,
            cast(new.station_name as varchar) to_value)modified;
    else
        insert into modify_log (table_name,primary_key,column_name, origin_value, edit_time,operation_type,editor)
        select table_name,old.station_id,column_name,from_value,current_timestamp,'D',cast(current_user as varchar)
        from(
            select 'station' table_name, 'station_id' column_name,
            cast(old.station_id as varchar) from_value
            union all
            select 'station' table_name, 'station_name' column_name,
            cast(old.station_name as varchar) from_value)modified;
    end if;
    return null;
end;
$$;

drop trigger station_trg on stations;
create trigger station_trg
after insert or update or delete on stations
for each row
execute procedure station_audit();


-- 时区调整
select *
from add_station('YUNHAO');

select current_timestamp;

show timezone;

ALTER DATABASE train SET timezone TO 'PRC';

set time zone 'PRC';
set timezone = PST8PDT;

insert into stations (station_id, station_name, station_abbr, station_pinyin, station_acronym, station_pinyin_code, station_longitude, station_altitude)


