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
					SizedBox(height: 15.0),
					BoxDecorationWidget(title: 'Tanggal Keberangkatan', content: Text('yyyy-mm-dd'), onPressed: () => print('date')),
					SizedBox(height: 15.0),
					BoxDecorationWidget(title: 'Penumpang', content: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [passenger('adult', 1), SizedBox(width: 1.0), passenger('infant', 0)]), onPressed: () => print('pax')),
				]
			),
		);
	}
	
	Widget passenger(String type, int count) {
		return Column(children: [Text('${count}', style: TextStyle(fontSize: 18.0)), Text(type, style: TextStyle(fontSize: 12.0, color: Colors.grey[400]))]);
	}
}

class RouteWidget extends StatelessWidget {
	void selectDepart(BuildContext context) {
		print('depart');
	}
	
	void selectArrival(BuildContext context) {
		print('arrival');
	}
	
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
					TerminalWidget(code: 'GMR', name: 'Gambir Jakarta', onPressed: () => selectDepart(context)),
					Icon(Icons.train, color: Colors.white, size: 35.0),
					TerminalWidget(code: 'BD', name: 'Bandung', onPressed: () => selectArrival(context)),
				],
			),
		);
	}
}

class TerminalWidget extends StatelessWidget {
	TerminalWidget({ this.code, this.name, this.onPressed });
	
	final String code;
	final String name; 
	final VoidCallback onPressed;
	
	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: onPressed,
			child: Column(
				children: [
					Text(code, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),
					Text(name, style: TextStyle(fontSize: 10.0, color: Colors.white))
				]
			),
		);
	}
}


class BoxDecorationWidget extends StatelessWidget {
	BoxDecorationWidget({ this.title, this.content, this.onPressed });
	
	final title;
	final Widget content;
	final VoidCallback onPressed;
	
	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: onPressed,
			child: Container(
				padding: EdgeInsets.only(left: 20.0, right: 20.0),
				child: Column(
					children: [
						Row(children: [Text(title, style: TextStyle(fontSize: 12.0, color: Colors.grey[400]))]),
						SizedBox(height: 2.0),
						Container(
							alignment: Alignment.center,
							constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
							decoration: BoxDecoration(
								border: Border.all(color: Colors.grey[400], width: 1.0),
								borderRadius: BorderRadius.circular(10.0),
							),
							child: content,
						),
					],
				),
			),
		);
	}
}
