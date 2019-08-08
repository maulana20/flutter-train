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
		return Scaffold(
			appBar: AppBar(
				title: Text('Form Penumpang', style: TextStyle(fontSize: 18.0)),
			),
			body: CustomForm(itinerary: itinerary, passengers: passengers, index: index),
		);
	}
}

class CustomForm extends StatefulWidget {
	CustomForm({ this.itinerary, this.passengers, this.index });
	
	final Itinerary itinerary;
	final List<Passenger> passengers;
	final int index;
	
	@override
	_CustomFormState createState() => _CustomFormState(itinerary: itinerary, passengers: passengers, index: index);
}

class _CustomFormState extends State<CustomForm> {
	_CustomFormState({ this.itinerary, this.passengers, this.index });
	
	final Itinerary itinerary;
	final List<Passenger> passengers;
	final int index;
	
	final formKey = GlobalKey<FormState>();
	
	final name = TextEditingController();
	final identity = TextEditingController();
	String title;
	
	String year;
	String month;
	String day;
	
	initState() {
		super.initState();
		title = passengers[index].title;
		name.text = passengers[index].name;
		identity.text = passengers[index].identity;
	}
	
	Future _setName(String text) {
		List names = List();
		
		for (final data in text.split(' ')) {
			names.add('${data[0].toUpperCase()}${data.substring(1)}');
		}
		setState(() { name.text = names.join(' '); });
	}
	
	@override
	Widget build(BuildContext context) {
		return Form(
			key: formKey,
			child: Container(
				padding: EdgeInsets.all(20.0),
				alignment: Alignment(-1.0, -1.0),
				child: Column(
					mainAxisAlignment: MainAxisAlignment.start,
					children: [
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
								Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text('Title', style: TextStyle(fontSize: 12.0, color: Colors.grey[600])),
										passengers[index].type == 'Adult' ? TitleAdultOption() : TitleInfantOption()
									]
								),
								Text(''),
							]
						),
						TextFormField(
							controller: name,
							decoration: InputDecoration(labelText: "Nama lengkap"),
							validator: (value) { if (value.isEmpty) return 'Nama lengkap tidak boleh kosong'; },
						),
						passengers[index].type == 'Adult' ? TextFormField(controller: identity, decoration: InputDecoration(labelText: "Nomor identitas"), validator: (value) { if (value.isEmpty) return 'Nomor identitas tidak boleh kosong'; }, ) : Birthday(),
						SizedBox(height: 20.0),
						Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(''), RaisedButton(color: Colors.blue[500], onPressed: () { if (formKey.currentState.validate()) { _setName(name.text); passengers[index] = Passenger(title: title, type: passengers[index].type, name: name.text, identity: passengers[index].type == 'Adult' ? identity.text : '${year}${month}${day}'); Navigator.push(context, MaterialPageRoute(builder: (context) => TrainPassengerPage(itinerary: itinerary, passengers: passengers))); } }, child: Text('SIMPAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)),), ]),
					],
				),
			),
		);
	}
	
	Widget TitleAdultOption() {
		return DropdownButton<String>(
			value: title,
			onChanged: (String _value) { setState(() { title = _value; }); },
			items: <String>['Mr.', 'Mrs.', 'Ms.'].map<DropdownMenuItem<String>>((String value) {
				return DropdownMenuItem<String>(value: value, child: Text(value));
			}).toList(),
		);
	}
	
	Widget TitleInfantOption() {
		return DropdownButton<String>(
			value: title,
			onChanged: (String _value) { setState(() { title = _value; }); },
			items: <String>['Mstr.', 'Miss.'].map<DropdownMenuItem<String>>((String value) {
				return DropdownMenuItem<String>(value: value, child: Text(value));
			}).toList(),
		);
	}
	
	Widget Birthday() {
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				SizedBox(height: 15.0),
				Text('Tanggal lahir', style: TextStyle(fontSize: 12.0, color: Colors.grey[600])),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: [
						Row(children:[ Text('tanggal', style: TextStyle(fontSize: 10.0, color: Colors.grey[600])), SizedBox(width: 4.0), DayOption() ]),
						Row(children:[ Text('bulan', style: TextStyle(fontSize: 10.0, color: Colors.grey[600])), SizedBox(width: 4.0), MonthOption() ]),
						Row(children:[ Text('tahun', style: TextStyle(fontSize: 10.0, color: Colors.grey[600])), SizedBox(width: 4.0), YearOption() ]),
					]
				),
			],
		);
	}
	
	Widget YearOption() {
		return DropdownButton<String>(
			value: year,
			onChanged: (String _value) { setState(() { year = _value; }); },
			items: <String>['2014', '2015', '2016', '2017', '2018', '2019', '2020', '2021'].map<DropdownMenuItem<String>>((String value) {
				return DropdownMenuItem<String>(value: value, child: Text(value));
			}).toList(),
		);
	}
	
	Widget MonthOption() {
		return DropdownButton<String>(
			value: month,
			onChanged: (String _value) { setState(() { month = _value; }); },
			items: <String>['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'].map<DropdownMenuItem<String>>((String value) {
				return DropdownMenuItem<String>(value: value, child: Text(value));
			}).toList(),
		);
	}
	
	Widget DayOption() {
		return DropdownButton<String>(
			value: day,
			onChanged: (String _value) { setState(() { day = _value; }); },
			items: <String>['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'].map<DropdownMenuItem<String>>((String value) {
				return DropdownMenuItem<String>(value: value, child: Text(value));
			}).toList(),
		);
	}
}
