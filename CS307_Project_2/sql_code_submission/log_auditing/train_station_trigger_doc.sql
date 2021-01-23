create or replace function train_station_audit()
returns trigger
language plpgsql
as
$$
begin
    if tg_op='UPDATE'
    then
        insert into modify_log (table_name,primary_key,column_name,origin_value,new_value,edit_time,operation_type,editor)
        select table_name,old.id,column_name,from_value,to_value,current_timestamp,'U',cast(current_user as varchar)
        from(
            select 'train_station' table_name, 'id' column_name,
            cast(old.id as varchar) from_value,
            cast(new.id as varchar) to_value
            where old.id<>new.id
            union all
            select 'train_station' table_name, 'train_id' column_name,
            cast(old.train_id as varchar) from_value,
            cast(new.train_id as varchar) to_value
            where old.train_id<>new.train_id
            union all
            select 'train_station' table_name, 'station_index' column_name,
            cast(old.station_index as varchar) from_value,
            cast(new.station_index as varchar) to_value
            where old.station_index<>new.station_index
            union all
            select 'train_station' table_name, 'station_id' column_name,
            cast(old.station_id as varchar) from_value,
            cast(new.station_id as varchar) to_value
            where old.station_id<>new.station_id
            union all
            select 'train_station' table_name, 'arr_time' column_name,
            cast(old.arr_time as varchar) from_value,
            cast(new.arr_time as varchar) to_value
            where old.arr_time<>new.arr_time
            union all
            select 'train_station' table_name, 'depart_time' column_name,
            cast(old.depart_time as varchar) from_value,
            cast(new.depart_time as varchar) to_value
            where old.depart_time<>new.depart_time
            union all
            select 'train_station' table_name, 'arr_day' column_name,
            cast(old.arr_day as varchar) from_value,
            cast(new.arr_day as varchar) to_value
            where old.arr_day<>new.arr_day
            union all
            select 'train_station' table_name, 'entrance' column_name,
            cast(old.entrance as varchar) from_value,
            cast(new.entrance as varchar) to_value
            where old.entrance<>new.entrance
            union all
            select 'train_station' table_name, 'interval_km' column_name,
            cast(old.interval_km as varchar) from_value,
            cast(new.interval_km as varchar) to_value
            where old.interval_km<>new.interval_km
            union all
            select 'train_station' table_name, 'first_price' column_name,
            cast(old.first_price as varchar) from_value,
            cast(new.first_price as varchar) to_value
            where old.first_price<>new.first_price
            union all
            select 'train_station' table_name, 'second_price' column_name,
            cast(old.second_price as varchar) from_value,
            cast(new.second_price as varchar) to_value
            where old.second_price<>new.second_price
            union all
            select 'train_station' table_name, 'first_remain' column_name,
            cast(old.first_remain as varchar) from_value,
            cast(new.first_remain as varchar) to_value
            where old.first_remain<>new.first_remain
            union all
            select 'train_station' table_name, 'second_remain' column_name,
            cast(old.second_remain as varchar) from_value,
            cast(new.second_remain as varchar) to_value
            where old.second_remain<>new.second_remain)modified;
    elsif tg_op='INSERT' then
        insert into modify_log (table_name,primary_key,column_name,new_value,edit_time,operation_type,editor)
        select table_name,new.id,column_name,to_value,current_timestamp,'I',cast(current_user as varchar)
        from(
            select 'train_station' table_name, 'id' column_name,
            cast(new.id as varchar) to_value
            union all
            select 'train_station' table_name, 'train_id' column_name,
            cast(new.train_id as varchar) to_value
            union all
            select 'train_station' table_name, 'station_index' column_name,
            cast(new.station_index as varchar) to_value
            union all
            select 'train_station' table_name, 'station_id' column_name,
            cast(new.station_id as varchar) to_value
            union all
            select 'train_station' table_name, 'arr_time' column_name,
            cast(new.arr_time as varchar) to_value
            union all
            select 'train_station' table_name, 'depart_time' column_name,
            cast(new.depart_time as varchar) to_value
            union all
            select 'train_station' table_name, 'arr_day' column_name,
            cast(new.arr_day as varchar) to_value
            union all
            select 'train_station' table_name, 'entrance' column_name,
            cast(new.entrance as varchar) to_value
            union all
            select 'train_station' table_name, 'interval_km' column_name,
            cast(new.interval_km as varchar) to_value
            union all
            select 'train_station' table_name, 'first_price' column_name,
            cast(new.first_price as varchar) to_value
            union all
            select 'train_station' table_name, 'second_price' column_name,
            cast(new.second_price as varchar) to_value
            union all
            select 'train_station' table_name, 'first_remain' column_name,
            cast(new.first_remain as varchar) to_value
            union all
            select 'train_station' table_name, 'second_remain' column_name,
            cast(new.second_remain as varchar) to_value)modified;
    else
        insert into modify_log (table_name,primary_key,column_name,origin_value,edit_time,operation_type,editor)
        select table_name,old.id,column_name,from_value,current_timestamp,'D',cast(current_user as varchar)
        from(
            select 'train_station' table_name, 'id' column_name,
            cast(old.id as varchar) from_value
            union all
            select 'train_station' table_name, 'train_id' column_name,
            cast(old.train_id as varchar) from_value
            union all
            select 'train_station' table_name, 'station_index' column_name,
            cast(old.station_index as varchar) from_value
            union all
            select 'train_station' table_name, 'station_id' column_name,
            cast(old.station_id as varchar) from_value
            union all
            select 'train_station' table_name, 'arr_time' column_name,
            cast(old.arr_time as varchar) from_value
            union all
            select 'train_station' table_name, 'depart_time' column_name,
            cast(old.depart_time as varchar) from_value
            union all
            select 'train_station' table_name, 'arr_day' column_name,
            cast(old.arr_day as varchar) from_value
            union all
            select 'train_station' table_name, 'entrance' column_name,
            cast(old.entrance as varchar) from_value
            union all
            select 'train_station' table_name, 'interval_km' column_name,
            cast(old.interval_km as varchar) from_value
            union all
            select 'train_station' table_name, 'first_price' column_name,
            cast(old.first_price as varchar) from_value
            union all
            select 'train_station' table_name, 'second_price' column_name,
            cast(old.second_price as varchar) from_value
            union all
            select 'train_station' table_name, 'first_remain' column_name,
            cast(old.first_remain as varchar) from_value
            union all
            select 'train_station' table_name, 'second_remain' column_name,
            cast(old.second_remain as varchar) from_value)modified;
    end if;
    return null;
end;
$$;
create trigger train_station_trg
after insert or update or delete on train_station
for each row
execute procedure train_station_audit();
