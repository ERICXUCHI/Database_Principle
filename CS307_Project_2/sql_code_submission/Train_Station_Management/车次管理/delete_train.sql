/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
    @ 删除一辆列车
*/

create or replace function del_train(del_train_no varchar, del_dpt_date varchar)
    returns text
    language plpgsql
as
$$
DECLARE
    get_train_id int;
BEGIN
    if (del_train_no not in (select train_num from trains)) then
        return '不存在该车次';
    end if;

    select (select t.train_id
            from trains t
            where del_train_no = t.train_num
              and t.start_date = to_date(del_dpt_date, 'YYYY-MM-DD'))
    into get_train_id;

    delete from train_station where train_id = get_train_id;
    delete from trains where train_id = get_train_id;
    return '删除成功 ' || get_train_id;
exception
    when others then
    return '删除失败';
end;
$$;


create or replace function del_train(del_train_id int)
    returns text
    language plpgsql
as
$$
BEGIN
    if (del_train_id not in (select train_id from trains)) then
        return '不存在该车次';
    end if;

    delete from train_station where train_id = del_train_id;
    delete from trains where train_id = del_train_id;
    return '删除成功';
exception
    when others then
    return '删除失败';
end;
$$;