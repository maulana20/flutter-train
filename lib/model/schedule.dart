import 'schedule_detail.dart';

class Schedule extends Object {
	String journey;
	String ka_name;
	String route;
	String str_time;
	List<ScheduleDetail> detail;
	
	Schedule({ this.journey, this.ka_name, this.route, this.str_time, this.detail });
	
	factory Schedule.fromJson(Map<String, dynamic> json) {
		List<ScheduleDetail> detail = json['sub'].map<ScheduleDetail>((data) => ScheduleDetail.fromJson(data)).toList();
		
		return Schedule(
			journey: json['journey'],
			ka_name: json['ka_name'],
			route: json['route'],
			str_time: json['str_time'],
			detail: detail,
		);
	}
}
