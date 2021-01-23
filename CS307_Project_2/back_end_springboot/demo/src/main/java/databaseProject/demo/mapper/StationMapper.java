package databaseProject.demo.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface StationMapper {
    String addStation(String add_station_name);
    String deleteStation(String del_station_name);

}
