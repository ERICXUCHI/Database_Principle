/***
    Create Tables
*/

-- a temporary table to store our data from various websites
-- we use it to create other tables later
create table temp_table
(
    train_no      varchar,
    station_index integer,
    arr_time      varchar,
    start_time    varchar,
    interval_time varchar,
    arr_day       integer,
    execute_time  varchar,
    interval_km   integer,
    first_price   double precision,
    second_price  double precision,
    station_name  varchar
);

-- stations
create table if not exists stations
(
    station_id          serial  not null
        constraint code_primary_key
            primary key,
    station_name        varchar not null
        constraint name_unique
            unique,
    station_abbr        varchar(20),
    station_pinyin      varchar(30),
    station_acronym     varchar(10),
    station_pinyin_code varchar(10),
    station_longitude   double precision,
    station_altitude    double precision
);

create trigger station_trg
    after insert or update or delete
    on stations
    for each row
execute procedure station_audit();


-- trains
create table if not exists trains
(
    train_id   serial      not null
        constraint train_id_primary_key
            primary key,
    train_num  varchar(10) not null,
    start_date date,
    constraint train_unique
        unique (train_num, start_date)
);

create index if not exists trains_train_id_index
    on trains (train_id);

create trigger train_trigger
    after insert or update or delete
    on trains
    for each row
execute procedure train_audit();



-- train_station
create table if not exists train_station
(
    id            serial           not null
        constraint route_id_primary_key
            primary key,
    train_id      integer          not null
        constraint train_station_train_id_fkey
            references trains,
    station_index integer          not null,
    station_id    integer          not null
        constraint train_station_station_id_fkey
            references stations,
    arr_time      time,
    depart_time   time,
    arr_day       integer          not null,
    entrance      varchar,
    interval_km   double precision not null,
    first_price   double precision,
    second_price  double precision,
    first_remain  integer,
    second_remain integer,
    constraint train_station_unique
        unique (train_id, station_index)
);

create index if not exists train_station_train_id_index
    on train_station (train_id);

create index if not exists train_station_station_id_index
    on train_station (station_id);

create trigger train_station_trg
    after insert or update or delete
    on train_station
    for each row
execute procedure train_station_audit();


-- users
create table if not exists users
(
    user_id             serial   not null
        constraint user_id_primary
            primary key,
    user_id_card_number char(20) not null
        constraint id_card_unique
            unique,
    user_name           varchar  not null,
    user_phone_number   varchar  not null
);


-- tickets
create table if not exists tickets
(
    ticket_id            serial  not null
        constraint ticket_id_primary
            primary key,
    user_id              integer not null
        constraint ticket_user_id_fkey
            references users,
    train_id             integer not null
        constraint ticket_train_id_fkey
            references trains,
    depart_train_station integer not null
        constraint tickets_stations_station_id_fk
            references stations,
    arrive_train_station integer not null
        constraint tickets_stations_station_id_fk_2
            references stations,
    carriage_num         integer not null,
    seat_num             varchar not null,
    seat_type            char    not null,
    price                varchar not null,
    status               smallint default 0
);


-- modify_log
create table if not exists modify_log
(
    id             serial    not null
        constraint log_primary
            primary key,
    table_name     varchar   not null,
    column_name    varchar   not null,
    primary_key    integer   not null,
    origin_value   varchar,
    new_value      varchar,
    edit_time      timestamp not null,
    operation_type char      not null,
    editor         varchar   not null
);


