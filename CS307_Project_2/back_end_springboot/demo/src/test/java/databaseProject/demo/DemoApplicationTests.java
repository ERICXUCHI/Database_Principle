package databaseProject.demo;

import databaseProject.demo.mapper.TicketMapper;
import databaseProject.demo.mapper.TrainMapper;
import databaseProject.demo.pojo.Ticket;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class DemoApplicationTests {

	@Autowired
	TrainMapper trainMapper;
	@Autowired
	TicketMapper ticketMapper;

	@Test
	void contextLoads() {
		System.out.println(trainMapper.addTrain("ADD1", "2020-12-30",
				"广州南","12:00", "13:00",
				1, "", "0",
				"200", 100, "150", 900));
	}

	@Test
	void contextLoads_1() {
		String train_num = "ADD1";
		String date = "2020-12-30";
		System.out.println(	trainMapper.deleteTrain(train_num, date));

	}

	@Test
	void contextLoads_2() {
		// 模拟抢票
		System.out.println("开始抢票: " + System.currentTimeMillis() / 1000.0 + "s");
		String id_card_num = "440111199712010000";
		for( int i = 0; i < 100000; i++){
			ticketMapper.buyATicket("G66", 2, 4, "2020-12-30", "二等座",
					"Database", id_card_num, "88888888");
		}
		System.out.println("开始抢票: " + System.currentTimeMillis() / 1000.0 + "s");
	}

	@Test
	void contextLoads_3() {
		// 模拟抢票
		long start = System.currentTimeMillis();
		System.out.println("开始抢票: " + start + "ms");
		long num = 1;
		for( int i = 0; i < 1000000; i++){
			ticketMapper.buyATicket("2095", 2, 4, "2020-12-27", "二等座",
					"Database", String.valueOf(num), "88888888");
			num++;
		}
		long end = System.currentTimeMillis();
		System.out.println("结束抢票: " + end + "ms");
		System.out.println("时间差: " + (end - start));
	}
	@Test
	void contextLoads_4() {
		// 模拟抢票
		long start = System.currentTimeMillis();
		System.out.println("开始抢票: " + start + "ms");
		long num = 1;
		for( int i = 0; i < 1000000; i++){
			ticketMapper.buyATicket("Z99", 1, 3, "2020-12-27", "二等座",
					"Database", String.valueOf(num), "88888888");
			System.out.println(num++);
		}
		long end = System.currentTimeMillis();
		System.out.println("结束抢票: " + end + "ms");
		System.out.println("时间差: " + (end - start));
	}

}
