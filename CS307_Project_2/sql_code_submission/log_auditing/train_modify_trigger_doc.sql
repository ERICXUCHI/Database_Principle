
create or replace function train_audit()
returns trigger
language plpgsql
as
$$
begin
    if tg_op='UPDATE'
    then
        insert into modify_log (table_name,primary_key,column_name, origin_value, new_value, edit_time,operation_type,editor)
        select table_name,old.train_id,column_name,from_value,to_value,current_timestamp,'U',cast(current_user as varchar)
        from(
            select 'train' table_name, 'train_id' column_name,
            cast(old.train_id as varchar) from_value,
            cast(new.train_id as varchar) to_value
            where old.train_id<>new.train_id
            union all
            select 'train' table_name, 'train_index' column_name,
            cast(old.train_num as varchar) from_value,
            cast(new.train_num as varchar) to_value
            where old.train_num<>new.train_num
            union all
            select 'train' table_name, 'start_date' column_name,
            cast(old.start_date as varchar) from_value,
            cast(new.start_date as varchar) to_value
            where old.start_date<>new.start_date)modified;
    elsif tg_op='INSERT' then
        insert into modify_log (table_name,primary_key,column_name, new_value,edit_time,operation_type,editor)
        select table_name,new.train_id,column_name,to_value,current_timestamp,'I',cast(current_user as varchar)
        from(
            select 'train' table_name, 'train_id' column_name,
            cast(new.train_id as varchar) to_value
            union all
            select 'train' table_name, 'train_index' column_name,
            cast(new.train_num as varchar) to_value
            union all
            select 'train' table_name, 'start_date' column_name,
            cast(new.start_date as varchar) to_value)modified;
    else
        insert into modify_log (table_name,primary_key,column_name, origin_value,edit_time,operation_type,editor)
        select table_name,old.train_id,column_name,from_value,current_timestamp,'D',cast(current_user as varchar)
        from(
            select 'train' table_name, 'train_id' column_name,
            cast(old.train_id as varchar) from_value
            union all
            select 'train' table_name, 'train_index' column_name,
            cast(old.train_num as varchar) from_value
            union all
            select 'train' table_name, 'start_date' column_name,
            cast(old.start_date as varchar) from_value)modified;
    end if;
    return null;
end;
$$;


drop trigger train_trigger on trains;
create trigger train_trigger
after insert or update or delete on trains
for each row
execute procedure train_audit();