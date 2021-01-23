package databaseProject.demo.Controller;

import databaseProject.demo.mapper.TicketMapper;
import databaseProject.demo.pojo.Ticket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.sql.Date;
import java.util.ArrayList;

@RestController
@CrossOrigin
public class TicketController {
    @Autowired
    TicketMapper ticketMapper;

    @GetMapping("/buyTicket")
    public String  buyTicket(@RequestParam(value = "train_num") String train_num,
                             @RequestParam(value = "depart_station_index") Integer depart_station_index,
                             @RequestParam(value = "arr_station_index") Integer arr_station_index,
                             @RequestParam(value = "dpt_date") String dpt_date,
                             @RequestParam(value = "seat_type") String seat_type,
                             @RequestParam(value = "user_name") String user_name,
                             @RequestParam(value = "id_card_num") String id_card_num,
                             @RequestParam(value = "phone_number") String phone_number
                             ){
        if (! (seat_type.equals("一等座") || !seat_type.equals("二等座"))){
            return "-1";
        }
        try {
            Date dateSql =  Date.valueOf(dpt_date);
        } catch (IllegalArgumentException e){
            return "-1";
        }
        return ticketMapper.buyATicket(train_num, depart_station_index, arr_station_index, dpt_date, seat_type, user_name, id_card_num,
                phone_number);

    }
    @GetMapping("/queryTicketsById")
    public ArrayList<Ticket> queryTicketsById(@RequestParam("id_card_num") String id_card_num){
        return ticketMapper.queryTicketById(id_card_num);
    }


    @GetMapping("/refundTicketById")
    public String refundTicketsById(@RequestParam("refund_ticket_id") Integer refund_ticket_id){
        return ticketMapper.refundTicketById(refund_ticket_id);
    }


}
