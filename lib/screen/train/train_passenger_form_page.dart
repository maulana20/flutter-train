import 'package:flutter/material.dart';

import 'train_passenger_page.dart';

import '../../model/itinerary.dart';
import '../../model/passenger.dart';

class TrainPassengerForm extends StatelessWidget {
	TrainPassengerForm({ this.itinerary, this.passengers, this.index });
	
	final Itinerary itinerary;
	final List<Passenger> passengers;
	final int index;
	
	@override
	Widget build(BuildContext context) {
		passengers[index] = Passenger(title: 'Mr', type: 'Adult', name: 'Maulana', identity: '012479687');
		
		return Scaffold(
			appBar: AppBar(
				title: Text('Form Penumpang', style: TextStyle(fontSize: 18.0)),
			),
			body: ListView(
				padding: EdgeInsets.zero,
				children: [
					TitleOption(),
					InkWell(
						onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TrainPassengerPage(itinerary: itinerary, passengers: passengers))),
						child: Container(
							padding: EdgeInsets.only(left: 20.0, right: 20.0),
							child: Container(
								alignment: Alignment.center,
								constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
								decoration: BoxDecoration(
									color: Colors.blue[500],
									border: Border.all(color: Colors.grey[400], width: 1.0),
									borderRadius: BorderRadius.circular(10.0),
								),
								child: Text('SIMPAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)),
							),
						),
					),
				],
			),
		);
	}
}

class TitleOption extends StatefulWidget {
	@override
	_TitleOptionState createState() => _TitleOptionState();
}

class _TitleOptionState extends State<TitleOption> {
	String dropdownValue = 'Mr';
	
	@override
	Widget build(BuildContext context) {
		return DropdownButton<String>(
			value: dropdownValue,
			onChanged: (String newValue) { setState(() { dropdownValue = newValue; }); },
			items: <String>['Mr', 'Mrs', 'Ms'].map<DropdownMenuItem<String>>((String value) {
				return DropdownMenuItem<String>(value: value, child: Text(value));
			}).toList(),
		);
	}
}
