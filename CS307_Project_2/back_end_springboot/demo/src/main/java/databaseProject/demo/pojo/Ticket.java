package databaseProject.demo.pojo;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.logging.log4j.message.StringFormattedMessage;
import org.springframework.stereotype.Repository;

import java.io.Serializable;

@Repository
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Ticket implements Serializable {
    private Integer ticket_id;
    private Integer user_id;
    private Integer train_id;

    private String depart_train_station;
    private String destination_train_station;

    private String train_num;
    private String user_name;
    private String id_card_number;
    private String phone_number;
    private String dpt_date;
    private String dpt_time;
    private String arr_time;
    private String train_no;
    private String entrance;
    private String seat_type;
    private String seat_info;
    private String price;
    private String state;


}
