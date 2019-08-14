import '../screen/train/bloc/search_bloc.dart';
import 'schedule.dart';
import 'schedule_detail.dart';

class Itinerary extends Object {
	final Search search;
	final Schedule schedule;
	final ScheduleDetail detail;
	final Fare fare;
	
	Itinerary({ this.search, this.schedule, this.detail, this.fare });
	Itinerary fromJson(Map<String, dynamic> json) {
		return Itinerary(
			search: search,
			schedule: schedule,
			detail: detail,
			fare: fare,
		);
	}
}

class Fare extends Object {
	final String publish;
	final String tax;
	final String total;
	final String total_curr;
	final String info;
	
	Fare({ this.publish, this.tax, this.total, this.total_curr, this.info });
	Fare fromJson(Map<String, dynamic> json) {
		return Fare(
			publish: json['publish'],
			tax: json['tax'],
			total: json['total'],
			total_curr: json['total_curr'],
			info: json['all_result'],
		);
	}
}
