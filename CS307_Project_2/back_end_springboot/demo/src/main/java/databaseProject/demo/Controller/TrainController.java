package databaseProject.demo.Controller;


import databaseProject.demo.mapper.TrainMapper;
import databaseProject.demo.pojo.Train;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.sql.Date;
import java.util.ArrayList;

@RestController
@CrossOrigin
public class TrainController {

    @Autowired
    private TrainMapper trainMapper;

    @GetMapping("/searchTrainsByStationAndDate")
    public ArrayList<Train> searchTrainsByStationAndDate(@RequestParam(value = "depart_station") String depart_station,
                                                         @RequestParam(value = "arr_station") String arr_station,
                                                         @RequestParam(value = "date") String date){
        Date dateSql;
        try {
            dateSql =  Date.valueOf(date);
        }
        catch (Exception e){
            return null;
        }
        depart_station = depart_station.replace('\"',' ').trim();
        arr_station = arr_station.replace('\"', ' ').trim();
        System.out.println(depart_station);
        System.out.println(arr_station);
        System.out.println(dateSql);
        return trainMapper.getTrainByStationsAndDate(depart_station, arr_station, dateSql);
    }

    @GetMapping("/searchTrainsByNumAndDate")
    public ArrayList<Train> searchTrainsByNumAndDate(
            @RequestParam(value = "train_num") String train_num,
            @RequestParam(value = "date") String date){
        Date dateSql;
        try {
            dateSql =  Date.valueOf(date);
        }
        catch (Exception e){
            return null;
        }
        train_num = train_num.replace('\"',' ').trim();
        System.out.println(dateSql);
        return trainMapper.getTrainByNumAndDate(train_num, dateSql);
    }

    @GetMapping("/addTrain")
    public String addTrain(
            @RequestParam(value = "add_train_num") String       add_train_num,
            @RequestParam(value = "add_dpt_date") String        add_dpt_date,
            @RequestParam(value = "add_station_name") String    add_station_name,
            @RequestParam(value = "add_arr_time") String        add_arr_time,
            @RequestParam(value = "add_dpt_time") String        add_dpt_time,
            @RequestParam(value = "add_arr_day") Integer         add_arr_day,
            @RequestParam(value = "add_entrance") String        add_entrance,
            @RequestParam(value = "add_interval_km") String     add_interval_km,
            @RequestParam(value = "add_first_price") String    add_first_price,
            @RequestParam(value = "add_second_price") String    add_second_price,
            @RequestParam(value = "add_first_remain") Integer  add_first_remain,
            @RequestParam(value = "add_second_remain") Integer   add_second_remain
            ) {

        System.out.println(add_arr_day);
        System.out.println(add_arr_time);
        System.out.println(add_dpt_date);
        System.out.println(add_dpt_time);
        System.out.println(add_entrance);
        System.out.println(add_first_price);

        return trainMapper.addTrain(add_train_num, add_dpt_date, add_station_name,  add_arr_time,
            add_dpt_time, add_arr_day, add_entrance,
                  add_interval_km,
                 add_first_price,
                   add_first_remain,
                  add_second_price,
                   add_second_remain);
    }

    @GetMapping("/deleteTrainByNumAndDate")
    public String deleteTrainByNumAndDate(@RequestParam(value = "train_num") String train_num,
                                          @RequestParam(value = "date") String date){
        return trainMapper.deleteTrain(train_num, date);
    }


}
