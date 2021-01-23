/***
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
====================== -> Final Submission <- ======================
    @Import Data
*/

COPY stations (station_name, station_abbr, station_pinyin,
               station_acronym, station_pinyin_code,
               station_longitude, station_altitude)
FROM '/Users/nongnong/Desktop/大三上/数据库原理/Project2/xiang_data/stations18.txt'
DELIMITER E'\t'
CSV HEADER;
-- encoding 'UTF16';

truncate table stations cascade;

show client_encoding;

COPY temp_table (train_no,station_index, station_name,  arr_time, start_time,
           interval_time, arr_day, execute_time, interval_km, first_price, second_price)
FROM '/Users/nongnong/Desktop/大三上/数据库原理/Project2/python爬虫/data2_utf8_1.txt'
DELIMITER E'\t'
NULL ''
CSV HEADER;

COPY temp_table (train_no,station_index, station_name,  arr_time, start_time,
           interval_time, arr_day, execute_time, interval_km, first_price, second_price)
FROM '/Users/nongnong/Desktop/大三上/数据库原理/Project2/python爬虫/data2_utf8_5.txt'
DELIMITER ','
NULL ''
CSV HEADER;

-- 导入 district 表
COPY district(code, name)
    from '/Users/nongnong/Desktop/大三上/数据库原理/Project2/python爬虫/district/id_card_district.csv'
DELIMITER ','
NULL ''
CSV HEADER;
