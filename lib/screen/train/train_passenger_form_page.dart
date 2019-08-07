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
	
	initState() {
		super.initState();
		title = passengers[index].title;
		name.text = passengers[index].name;
		identity.text = passengers[index].identity;
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
										Text('Title', style: TextStyle(fontSize: 16.0, color: Colors.grey[600])),
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
						TextFormField(
							controller: identity,
							decoration: InputDecoration(labelText: "Nomor identitas"),
							validator: (value) { if (value.isEmpty) return 'Nomor identitas tidak boleh kosong'; },
						),
						SizedBox(height: 20.0),
						Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(''), RaisedButton(color: Colors.blue[500], onPressed: () { if (formKey.currentState.validate()) { passengers[index] = Passenger(title: title, type: passengers[index].type, name: name.text, identity: identity.text); Navigator.push(context, MaterialPageRoute(builder: (context) => TrainPassengerPage(itinerary: itinerary, passengers: passengers))); } }, child: Text('SIMPAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)),), ]),
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
}
