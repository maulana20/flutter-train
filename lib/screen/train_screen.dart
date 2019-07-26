import 'package:flutter/material.dart';

class TrainScreen extends StatelessWidget {
	TrainScreen({ this.title });
	
	final String title;
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(title),
			),
			body: ListView(
				padding: EdgeInsets.zero,
				children: [
					RouteWidget(),
					DateWidget(),
					PassengerWidget(),
				]
			),
		);
	}
}

class RouteWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			color: Colors.blue[500],
			padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
			alignment: FractionalOffset.center,
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				// crossAxisAlignment: CrossAxisAlignment.center,
				children: [
					terminal('GMR', 'Gambir Jakarta'),
					Icon(Icons.train, color: Colors.white, size: 28.0),
					terminal('BD', 'Bandung'),
				],
			),
		);
	}
	
	Widget terminal(String code, String name) {
		return Column(children:[ Text(code, style: TextStyle(fontSize: 25.0, color: Colors.white)), Text(name, style: TextStyle(fontSize: 10.0, color: Colors.white))]);
	}
}

class DateWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.all(20.0),
			child: Column(
				children: [
					Row(children: [Text('Tanggal Keberangkatan', style: TextStyle(fontSize: 12.0))]),
					SizedBox(height: 2.0),
					Container(
						alignment: Alignment.center,
						constraints: BoxConstraints(minWidth: 400.0, minHeight: 50.0),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.grey[400], width: 1.0),
							borderRadius: BorderRadius.circular(10.0),
						),
						child: Text('yyyy-mm-dd'),
					),
				],
			),
		);
	}
}

class PassengerWidget extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.all(20.0),
			child: Column(
				children: [
					Row(children: [Text('Jumlah Penumpang', style: TextStyle(fontSize: 12.0))]),
					SizedBox(height: 2.0),
					Container(
						alignment: Alignment.center,
						constraints: BoxConstraints(minWidth: 300.0, minHeight: 50.0),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.grey[400], width: 1.0),
							borderRadius: BorderRadius.circular(10.0),
						),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceEvenly,
							children: [
								Text('1'),
								SizedBox(width: 1.0),
								Text('0'),
							],
						),
					),
				],
			),
		);
	}
}
