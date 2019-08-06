import 'dart:core';

import 'package:flutter/material.dart';

import 'train_passenger_form_page.dart';

import '../../model/itinerary.dart';
import '../../model/schedule.dart';
import '../../model/schedule_detail.dart';
import '../../model/passenger.dart';

import 'bloc/search_bloc.dart';

class TrainPassengerPage extends StatelessWidget {
	TrainPassengerPage({ this.itinerary, this.passengers });
	
	final Itinerary itinerary;
	List<Passenger> passengers;
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				leading: IconButton(
					icon: Icon(Icons.arrow_back),
					onPressed: () { Navigator.pop(context); },
				),
				title: Text('Data Penumpang', style: TextStyle(fontSize: 18.0)),
			),
			body: ListView(
				padding: EdgeInsets.zero,
				children: [
					SizedBox(height: 10.0),
					ChangeSearch(),
					SizedBox(height: 10.0),
					DetailRoute(itinerary: itinerary),
					SizedBox(height: 10.0),
					DetailPassenger(itinerary: itinerary, passengers: passengers),
				],
			),
		);
	}
}

class ChangeSearch extends StatelessWidget {
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.only(left: 20.0, right: 20.0),
			child: Container(
				constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
				padding: EdgeInsets.all(15.0),
				decoration: BoxDecoration(
					border: Border.all(color: Colors.lightBlue[300], width: 1.0),
					borderRadius: BorderRadius.circular(5.0),
				),
				child: Center(
					child: Text('UBAH PENCARIAN', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
				),
			),
		);
	}
}

class DetailRoute extends StatelessWidget {
	DetailRoute({ this.itinerary });
	
	final Itinerary itinerary;
	
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.only(left: 20.0, right: 20.0),
			child: Column(
				children: [
					Row(children:[ Text('Detail Keberangkatan', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)), ]),
					SizedBox(height: 15.0),
					Container(
						constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
						padding: EdgeInsets.all(15.0),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.grey[400], width: 1.0),
							borderRadius: BorderRadius.circular(5.0),
						),
						child:  Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									children: [
										Row(children:[ Text(itinerary.search.departure.station_name, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)), SizedBox(width: 5.0), Icon(Icons.arrow_forward, size: 12.0), SizedBox(width: 5.0), Text(itinerary.search.arrival.station_name, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)), ]),
										SizedBox(height: 5.0),
										Row(children:[ Route(itinerary.schedule.route.split('-')[0], itinerary.schedule.str_time.split(' ')[0]), SizedBox(width: 5.0), Text('-'), SizedBox(width: 5.0), Route(itinerary.schedule.route.split('-')[1], itinerary.schedule.str_time.split(' ')[1]), SizedBox(width: 5.0), Icon(Icons.grade, size: 8.0), SizedBox(width: 5.0), Text(itinerary.search.date, style: TextStyle(fontSize: 12.0))]),
									],
								),
								Row(children:[ Icon(Icons.arrow_downward, size: 16.0), ]),
							],
						),
					),
				],
			),
		);
	}
	
	Row Route(String station, String hour) {
		return Row(children: [Text(station, style: TextStyle(fontSize: 12.0)), SizedBox(width: 3.0), Text(hour, style: TextStyle(fontSize: 10.0))]);
	}
}

class DetailPassenger extends StatefulWidget {
	DetailPassenger({ this.itinerary, this.passengers });
	
	final Itinerary itinerary;
	List<Passenger> passengers;
	
	_DetailPassengerState createState() => _DetailPassengerState(itinerary: itinerary, passengers: passengers);
}

class _DetailPassengerState extends State<DetailPassenger> {
	_DetailPassengerState({ this.itinerary, this.passengers });
	
	final Itinerary itinerary;
	List<Passenger> passengers;
	
	Future<Passenger> _passenger(int adult, int infant) {
		passengers.clear();
		if (adult != null) for (var i = 0; i < adult; i++) { passengers.add(Passenger(type: "Adult", title: "Mr")); }
		if (infant != null) for (var i = 0; i < infant; i++) { passengers.add(Passenger(type: "Infant", title: "Mstr")); }
	}
	
	initState() {
		super.initState();
		if (passengers.length == 0) _passenger(itinerary.search.adult, itinerary.search.infant);
	}
	
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.only(left: 20.0, right: 20.0),
			child: Column( children: Passengers(), ),
		);
	}
	
	List<Widget> Passengers() {
		List<Widget> list = new List();
		list.add( Row(children:[ Text('Detail Penumpang', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)), ]) );
		list.add( SizedBox(height: 15.0) );
		for (var index = 0; index < passengers.length; index++) {
			list.add( Detail(passengers[index], index) );
			list.add( SizedBox(height: 10.0) );
		}
		
		return list;
	}
	
	Widget Detail(Passenger passenger, int index) {
		var type = passenger.type == 'Adult' ? 'dewasa' : 'bayi';
		int i = index + 1;
		
		String info;
		if (passenger.name != null) {
			info = '${passenger.title} ${passenger.name} ${passenger.identity}';
		} else {
			info = 'penumpang ${type} ' + (passenger.type == 'Adult' ? 'ke ${i}' : '');
		}
		
		return Container(
			constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
			padding: EdgeInsets.all(15.0),
			decoration: BoxDecoration(
				border: Border.all(color: Colors.grey[200], width: 1.0),
				borderRadius: BorderRadius.circular(5.0),
				color: Colors.grey[200],
			),
			child: InkWell(
				onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TrainPassengerForm(itinerary: itinerary, passengers: passengers, index: index))),
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Text(info, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
						Icon(Icons.create, size: 14.0),
					],
				),
			),
		);
	}
}
