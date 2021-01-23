
/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
    @ Privilege
*/
create user guest with password 'guest';
create user administrator with password 'administrator';

grant select on district to guest;
grant select on stations to guest;
grant select,insert,update on tickets to guest;
grant select on trains to guest;
grant select,update on train_station to guest;
grant select,insert on users to guest;
grant insert on modify_log to guest;
grant all on users_user_id_seq to guest;
grant all on edit_log_id_seq to guest;
grant all on ticket_ticket_id_seq to guest;
grant select on district to administrator;
grant select,insert,delete on modify_log to administrator;
grant select,insert,update,delete on stations to administrator;
grant select,insert,update,delete on tickets to administrator;
grant select,insert,update,delete on trains to administrator;
grant select,insert,update,delete on train_station to administrator;
grant select,insert,update,delete on users to administrator;
grant all on users_user_id_seq to administrator;
grant all on edit_log_id_seq to administrator;
grant all on ticket_ticket_id_seq to administrator;
grant all on station_station_id_seq to administrator;
grant all on train_station_id_seq to administrator;
grant all on train_train_id_seq to administrator;