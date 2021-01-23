package databaseProject.demo.pojo;

import com.fasterxml.jackson.annotation.JsonInclude;
import org.springframework.stereotype.Repository;

import java.io.Serializable;

@Repository
@JsonInclude(JsonInclude.Include.NON_NULL)
public class Station implements Serializable {
    private Integer station_id;
    private String station_name;
    private String station_abbr;
    private String station_pinyin;
    private String station_acronym;
    private String station_pinyin_code;
    private Double station_longitude;
    private Double station_altitude;
}
