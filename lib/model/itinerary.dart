import '../screen/train/bloc/search_bloc.dart';
import 'schedule.dart';
import 'schedule_detail.dart';

class Itinerary extends Object {
	final Search search;
	final Schedule schedule;
	final ScheduleDetail detail;
	
	Itinerary({ this.search, this.schedule, this.detail });
	Itinerary fromJson(Map<String, dynamic> json) {
		return Itinerary(
			search: search,
			schedule: schedule,
			detail: detail,
		);
	}
}
