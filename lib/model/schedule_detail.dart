class ScheduleDetail extends Object {
	String train_name;
	String train_class;
	String type;
	String seat;
	bool disabled;
	String adult_fare;
	String infant_fare;
	
	ScheduleDetail({ this.train_name, this.train_class, this.type, this.seat, this.disabled, this.adult_fare, this.infant_fare });
	factory ScheduleDetail.fromJson(Map<String, dynamic> json) {
		return ScheduleDetail(
			train_name: json['value'],
			train_class: json['class'],
			type: json['type'],
			seat: json['seat'],
			disabled: json['disabled'],
			adult_fare: json['adult_fare'],
			infant_fare: json['infant_fare'],
		);
	}
}
