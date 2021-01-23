package databaseProject.demo.pojo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import org.springframework.stereotype.Repository;

import java.io.Serializable;
import java.sql.Time;

@Data
@Repository
@AllArgsConstructor
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Train implements Serializable {

    private String train_num;
    private Integer id;
    private Integer train_id;

    private Integer station_id;

    // 车站 大栏显示 原始出发站、目的地站 及其对应时间信息
    private String dpt_station_name;
    private String dpt_origin_time;
    private String arr_station_name;
    private String arr_destination_time;
    private Integer arr_day;
    // 总运行时间 大栏显示
    private int min_first_remain;
    private int min_second_remain;
    private String execution_time;
    private Integer dpt_station_index;
    private Integer arr_station_index;
    // 价格和余票
    private double first_price;
    private double second_price;

// =============== =============== =============== ===============
    // 当前车站 查找途径详细信息所用 停留时间
    private Integer station_index;
    private String station_name;
    private String depart_time;
    private String arr_time;
    private String time_diff;
    private Integer first_remain;
    private Integer second_remain;
    private Double interval_km;


}
