import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'bloc/search_bloc.dart';
import '../../model/schedule.dart';
import '../../model/schedule_detail.dart';

class TrainSchedulePage extends StatelessWidget {
	TrainSchedulePage({ this.search, this.schedules });
	
	Search search;
	List<Schedule> schedules;
	
	@override
	Widget build(BuildContext context) {
		int count_pax = search.adult + (search.infant != null ? search.infant : 0);
		
		return MaterialApp(
			title: 'Pilih Jadwal',
			home: Scaffold(
				appBar: AppBar(
					leading: IconButton(
						icon: Icon(Icons.arrow_back),
						onPressed: () { Navigator.pop(context); },
					),
					title: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							Row(
								children: [
									Text(search.departure.station_code, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
									SizedBox(width: 5.0),
									Icon(Icons.arrow_forward, size: 10.0),
									SizedBox(width: 5.0),
									Text(search.arrival.station_code, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
								],
							),
							Row(
								children: [
									Text(search.date, style: TextStyle(fontSize: 12.0)),
									SizedBox(width: 5.0),
									Icon(Icons.grade, size: 8.0),
									SizedBox(width: 5.0),
									Text('${count_pax} pax', style: TextStyle(fontSize: 12.0)),
								],
							),
						]
					),
				),
				body: ListView.builder(
					itemCount: schedules.length,
					itemBuilder: (context, index) {
						for (final detail in schedules[index].detail) {
							return ScheduleDetailTile(schedule: schedules[index], detail: detail);
						}
					},
				),
			),
		);
	}
}

class ScheduleDetailTile extends StatelessWidget {
	ScheduleDetailTile({ this.schedule, this.detail });
	
	final Schedule schedule;
	final ScheduleDetail detail;
	
	@override
	Widget build(BuildContext context) {
		double total = double.parse(detail.adult_fare) + double.parse(detail.infant_fare);
		MoneyFormatterOutput total_amount = FlutterMoneyFormatter(amount: total).output;
		
		return Card(
			child: Padding(
				padding: EdgeInsets.all(8.0),
				child: ListTile(
					title: Row(
						mainAxisAlignment: MainAxisAlignment.spaceBetween,
						children: [
							Column(
								mainAxisSize: MainAxisSize.min,
								children: [
									Train(schedule.ka_name, schedule.journey),
									SizedBox(height: 4.0),
									Schedulex(schedule.route, schedule.str_time),
									SizedBox(height: 10.0),
								]
							),
							Column( children: [Text(total_amount.withoutFractionDigits, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)), SizedBox(height: 2.0), Text(detail.train_class, style: TextStyle(fontSize: 10.0))], ),
						],
					),
				),
			),
		);
	}
	
	Row Train(String name, String code) {
		return Row( children: [ Text(name, style: TextStyle(fontSize: 10.0)), SizedBox(width: 5.0), Icon(Icons.train, size: 12.0), SizedBox(width: 5.0), Text(code, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)), ], );
	}
	
	Row Schedulex(String route, String time) {
		return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Icon(Icons.calendar_today, size: 12.0), SizedBox(width: 5.0), Detail(route.split('-')[0], time.split(' ')[0]), SizedBox(width: 12.0), Detail(route.split('-')[1], time.split(' ')[1])]);
	}
	
	Row Detail(String station, String hour) {
		return Row(children: [Text(station, style: TextStyle(fontSize: 12.0)), SizedBox(width: 3.0), Text(hour, style: TextStyle(fontSize: 10.0))]);
	}
}
