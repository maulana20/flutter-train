class Schedule extends Object {
	String journey;
	String ka_name;
	String route;
	String str_time;
	
	Schedule({ this.journey, this.ka_name, this.route, this.str_time });
	
	factory Schedule.fromJson(Map<String, dynamic> json) {
		return Schedule(
			journey: json['journey'],
			ka_name: json['ka_name'],
			route: json['route'],
			str_time: json['str_time'],
		);
	}
}
