package databaseProject.demo.Controller;


import databaseProject.demo.mapper.StationMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin
@RestController
public class StationController {


    @Autowired
    private StationMapper stationMapper;

    @GetMapping("/addStationByName")
    public String addStationByName(@RequestParam(value = "add_station_name") String add_station_name){
        return stationMapper.addStation(add_station_name);
    }

    @GetMapping("/deleteStationByName")
    public String deleteStationByName(@RequestParam(value = "del_station_name") String del_station_name){
        return stationMapper.deleteStation(del_station_name);
    }


}
