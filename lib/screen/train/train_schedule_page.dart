import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import 'train_passenger_page.dart';

import 'bloc/search_bloc.dart';

import '../../model/schedule.dart';
import '../../model/schedule_detail.dart';
import '../../model/itinerary.dart';
import '../../model/passenger.dart';

import '../../api/versatiket_api.dart';

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
							return ScheduleDetailTile(search: search, schedule: schedules[index], detail: detail);
						}
					},
				),
			),
		);
	}
}

class ScheduleDetailTile extends StatefulWidget {
	ScheduleDetailTile({ this.search, this.schedule, this.detail });
	
	final Search search;
	final Schedule schedule;
	final ScheduleDetail detail;
	
	_ScheduleDetailTileState createState() => _ScheduleDetailTileState(search: search, schedule: schedule, detail: detail);
}

class _ScheduleDetailTileState extends State<ScheduleDetailTile> {
	_ScheduleDetailTileState({ this.search, this.schedule, this.detail });
	
	final Search search;
	final Schedule schedule;
	final ScheduleDetail detail;
	
	VersatiketApi _versaApi;
	
	@override
	void initState() {
		super.initState();
		_versaApi = VersatiketApi();
	}
	
	Future<void> _alert(BuildContext context, String info) {
		return showDialog<void>(
			context: context,
			builder: (BuildContext context) {
				return AlertDialog(
					title: Text('Warning !'),
					content: Text(info),
					actions: <Widget>[
						FlatButton(
							child: Text('Ok'),
							onPressed: () {
							  Navigator.of(context).pop();
							},
						),
					],
				);
			},
		);
	}
	
	Future _process(Itinerary itinerary) async {
		await _versaApi.isonlogin();
		
		await Future.delayed(const Duration(seconds : 5));
		
		var res = await _versaApi.fare(itinerary);
		
		if (res['status'] == 'timeout') { 
			_alert(context, res['message']);
		} else if (res['status'] == 'failed') {
			if (res['content']['flag'] != null) {
				_alert(context, res['content']['alert']);
			} else {
				_alert(context, res['content']['reason']);
			}
		} else {
			List<Passenger> passengers = new List();
			Navigator.push(context, MaterialPageRoute(builder: (context) => TrainPassengerPage(itinerary: itinerary, passengers: passengers)));
		}
		
		// await _versaApi.logout();
	}
	
	@override
	Widget build(BuildContext context) {
		int adult_total = search.adult != null ? int.parse('${detail.adult_fare}') * search.adult : 0;
		int infant_total = search.infant != null ? int.parse('${detail.infant_fare}') * search.infant : 0;
		int total = adult_total + infant_total;
		MoneyFormatterOutput total_amount = FlutterMoneyFormatter(amount: double.parse('${total}')).output;
		
		Itinerary itinerary = Itinerary(search: search, schedule: schedule, detail: detail);
		
		var color_seat;
		if (detail.seat == '0') { color_seat = Colors.grey; } else if (detail.seat == 'Available') { color_seat = Colors.green; } else { color_seat = Colors.black; }
		
		var color_class;
		if (detail.train_class == 'ECONOMY-C') { color_class = Colors.blue; } else if (detail.train_class == 'BUSINESS-B') { color_class = Colors.green; } else { color_class = Colors.red; }
		
		return Card(
			child: GestureDetector(
				onTap: () => _process(itinerary),
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
								Column( children: [Text('seat', style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)), SizedBox(height: 2.0), Text(detail.seat, style: TextStyle(fontSize: 10.0, color: color_seat))], ),
								Column( children: [Text(total_amount.withoutFractionDigits, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)), SizedBox(height: 2.0), Text(detail.train_class, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold, color: color_class))], ),
							],
						),
					),
				),
			),
		);
	}
	
	Row Train(String name, String code) {
		return Row( children: [ Icon(Icons.train, size: 14.0), SizedBox(width: 5.0), Text(code, style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)), SizedBox(width: 5.0), Text(name, style: TextStyle(fontSize: 8.0)) ], );
	}
	
	Row Schedulex(String route, String time) {
		return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[Icon(Icons.calendar_today, size: 12.0), SizedBox(width: 5.0), Detail(route.split('-')[0], time.split(' ')[0]), SizedBox(width: 12.0), Detail(route.split('-')[1], time.split(' ')[1])]);
	}
	
	Row Detail(String station, String hour) {
		return Row(children: [Text(station, style: TextStyle(fontSize: 12.0)), SizedBox(width: 3.0), Text(hour, style: TextStyle(fontSize: 10.0))]);
	}
}
