package databaseProject.demo.mapper;

import databaseProject.demo.pojo.Ticket;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;

@Repository
@Mapper
public interface TicketMapper {

    String buyATicket(String train_num, Integer depart_station_index,
                      Integer arr_station_index, String dpt_date,
                      String seat_type , String user_name,
                      String id_card_num ,String phone_number);

    ArrayList<Ticket> queryTicketById(String user_card_id);
    String refundTicketById(Integer refund_ticket_id);
}
