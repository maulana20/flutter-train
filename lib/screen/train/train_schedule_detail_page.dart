import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'train_passenger_page.dart';

import '../../model/itinerary.dart';
import '../../model/passenger.dart';

class TrainScheduleDetailPage extends StatelessWidget {
	TrainScheduleDetailPage({ this.itinerary, this.passengers });
	
	final Itinerary itinerary;
	final List<Passenger> passengers;
	
	@override
	Widget build(BuildContext context) {
		var time_depart = DateTime.fromMicrosecondsSinceEpoch(itinerary.schedule.time_depart * 1000 * 1000);
		var time_arrive = DateTime.fromMicrosecondsSinceEpoch(itinerary.schedule.time_arrive * 1000 * 1000);
		Duration diff_time = time_arrive.difference(time_depart);
		var diff = '${diff_time.toString().split(':')[0]} jam ${diff_time.toString().split(':')[1]} menit';
		
		return Scaffold(
			appBar: AppBar(
				title: Text('Schedule Detail', style: TextStyle(fontSize: 18.0)),
			),
			body: Container(
				color: Colors.grey[200],
				child: ListView(
					padding: EdgeInsets.zero,
					children: [
						Container(
							padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
							child: Row(
								mainAxisAlignment: MainAxisAlignment.spaceBetween,
								children: [
									Row(children: [Text(itinerary.schedule.ka_name, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)), SizedBox(width: 5.0), Text(itinerary.schedule.journey, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))]),
									Text(itinerary.detail.train_class, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))
								]
							),
						),
						Container(
							color: Colors.white,
							padding: EdgeInsets.all(15.0),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								children: [
									Schedule(itinerary.search.departure.station_code, itinerary.search.departure.station_name, time_depart),
									Divider(color: Colors.grey),
									SizedBox(height: 10.0),
									Row(children: [Text('Durasi ${diff}', style: TextStyle(fontSize: 14.0, color: Colors.grey))]),
									SizedBox(height: 10.0),
									Divider(color: Colors.grey),
									Schedule(itinerary.search.arrival.station_code, itinerary.search.arrival.station_name, time_arrive),
								],
							),
						),
						Container(
							padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.start,
								children: [
									Price('Harga Dasar', itinerary.fare.publish),
									SizedBox(height: 5.0),
									Price('Pajak', itinerary.fare.tax),
									SizedBox(height: 2.0),
									Divider(color: Colors.grey),
									SizedBox(height: 2.0),
									Price('TOTAL', itinerary.fare.total),
								],
							),
						),
					],
				),
			),
		);
	}
	
	Row Price(String name, String price) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Text(name, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
				Text(price, style: TextStyle(fontSize: 14.0, color: Colors.grey))
			]
		);
	}
	
	Row Schedule(String code, String name, DateTime time) {
		var date = DateFormat("dd MMM").format(time);
		var hour = DateFormat("HH:mm").format(time);
		
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Row(
					children: [
						Container(
							padding: EdgeInsets.all(5.0),
							decoration: BoxDecoration(
								color: Colors.grey[100],
								borderRadius: BorderRadius.circular(2.0),
							),
							child: Text(code, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
						),
						SizedBox(width: 5.0),
						Text(name, style: TextStyle(fontSize: 16.0)),
					],
				),
				Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						Text(hour, style: TextStyle(fontSize: 12.0, color: Colors.grey)),
						SizedBox(height: 1.0),
						Text(date, style: TextStyle(fontSize: 12.0, color: Colors.grey)),
					],
				),
			],
		);
	}
}
