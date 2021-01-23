package databaseProject.demo.mapper;

import databaseProject.demo.pojo.Train;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.ArrayList;

@Mapper
@Repository
public interface TrainMapper {

    ArrayList<Train> getTrainByStationsAndDate(String depart_station,
                                               String arr_station,
                                               Date depart_date);

    ArrayList<Train> getTrainByNumAndDate(String train_num,
                                               Date depart_date);

    String addTrain(String add_train_num,
                    String add_dpt_date,
                    String add_station_name,
                    String add_arr_time,
                    String add_dpt_time,
                    Integer add_arr_day,
                    String add_entrance,
                    String add_interval_km,
                    String add_first_price,
                    Integer add_first_remain,
                    String add_second_price,
                    Integer add_second_remain
                    );

    String deleteTrain(String train_num, String date);

}
