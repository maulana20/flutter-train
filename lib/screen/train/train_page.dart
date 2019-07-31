import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'bloc/search_bloc.dart';

import '../../model/station.dart';
import '../../api/station_lookup.dart';

class TrainPage extends StatefulWidget {
	TrainPage({ this.stationLookup });
	
	final StationLookup stationLookup;
	
	@override
	_TrainPageState createState() => _TrainPageState(stationLookup: stationLookup);
}

class _TrainPageState extends State<TrainPage> {
	_TrainPageState({ this.stationLookup });
	
	final StationLookup stationLookup;
	
	@override
	Widget build(BuildContext context) {
		final searchBloc = Provider.of<SearchBloc>(context);
		
		return Scaffold(
			appBar: AppBar( title: Text('Flutter Train'), ),
			body: StreamBuilder(
				stream: searchBloc.searchStream,
				initialData: Search(),
				builder: (context, snapshot) {
					return ListView(
						padding: EdgeInsets.zero,
						children: [
							Route(stationLookup: stationLookup, searchBloc: searchBloc),
							SizedBox(height: 15.0),
							BoxDecorationDate(),
							SizedBox(height: 15.0),
							BoxDecorationPassenger(),
							RaisedButton(
								child: Text("SEARCH", style: TextStyle(color: Colors.white)),
								color: Colors.brown,
								onPressed: () => print(snapshot.data.from_code),
							),
						],
					);
				},
			),
		);
	}
}

class Route extends StatefulWidget {
	Route({ this.stationLookup, this.searchBloc });
	
	final StationLookup stationLookup;
	final SearchBloc searchBloc;
	
	@override
	_RouteState createState() => _RouteState(stationLookup: stationLookup, searchBloc: searchBloc);
}

class _RouteState extends State<Route> {
	_RouteState({ this.stationLookup, this.searchBloc });
	
	final StationLookup stationLookup;
	final SearchBloc searchBloc;
	
	Station departure;
	Station arrival;
	
	Future<Station> _showSearch(BuildContext context) async {
		return await showSearch<Station>(
			context: context,
			delegate: StationSearchDelegate( stationLookup: stationLookup )
		);
	}
	
	void _selectDepart(BuildContext context) async {
		var station = await _showSearch(context);
		setState(() => departure = station);
		
		print(departure);
		searchBloc.updateWith(from_code: station.station_code);
	}
	
	void _selectArrival(BuildContext context) async {
		var station = await _showSearch(context);
		setState(() => arrival = station);
		
		print(arrival);
		searchBloc.updateWith(from_code: station.station_code);
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
					StationWidget(code: 'GMR', name: 'Gambir Jakarta', onPressed: () => _selectDepart(context), station: departure),
					Icon(Icons.train, color: Colors.white, size: 35.0),
					StationWidget(code: 'BD', name: 'Bandung', onPressed: () => _selectArrival(context), station: arrival),
				],
			),
		);
	}
}

class StationWidget extends StatelessWidget {
	StationWidget({ this.code, this.name, this.onPressed, this.station });
	
	final String code;
	final String name; 
	final VoidCallback onPressed;
	final Station station;
	
	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: onPressed,
			child: Column(
				children: [
					Text(station != null ? station.station_code : code, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),
					Text(station != null ? station.station_name : name, style: TextStyle(fontSize: 10.0, color: Colors.white))
				]
			),
		);
	}
}


class BoxDecorationDate extends StatefulWidget {
	@override
	_BoxDecorationDateState createState() => _BoxDecorationDateState();
}

class _BoxDecorationDateState extends State<BoxDecorationDate> {
	String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
	
	Future selectDate() async {
		DateTime picked = await showDatePicker(
			context: context,
			initialDate: new DateTime.now(),
			firstDate: new DateTime(2016),
			lastDate: new DateTime(2030)
		);
		if(picked != null) {
			setState(() {
				date = DateFormat('yyyy-MM-dd').format(picked);
				print('Selected date: ' + date);
			});
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: () { selectDate(); },
			child: Container(
				padding: EdgeInsets.only(left: 20.0, right: 20.0),
				child: Column(
					children: [
						Row(children: [Text('Tanggal Keberangkatan', style: TextStyle(fontSize: 12.0, color: Colors.grey[400]))]),
						SizedBox(height: 2.0),
						Container(
							alignment: Alignment.center,
							constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
							decoration: BoxDecoration(
								border: Border.all(color: Colors.grey[400], width: 1.0),
								borderRadius: BorderRadius.circular(10.0),
							),
							child: Text(date),
						),
					],
				),
			),
		);
	}
}

class BoxDecorationPassenger extends StatefulWidget {
	@override
	_BoxDecorationPassengerState createState() => _BoxDecorationPassengerState();
}

class _BoxDecorationPassengerState extends State<BoxDecorationPassenger> {
	int adult = 1;
	int infant = 0;
	
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.only(left: 20.0, right: 20.0),
			child: Column(
				children: [
					Row(children: [Text('Penumpang', style: TextStyle(fontSize: 12.0, color: Colors.grey[400]))]),
					SizedBox(height: 2.0),
					Container(
						alignment: Alignment.center,
						constraints: BoxConstraints(minWidth: 400.0, minHeight: 40.0),
						decoration: BoxDecoration(
							border: Border.all(color: Colors.grey[400], width: 1.0),
							borderRadius: BorderRadius.circular(10.0),
						),
						child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [passenger('adult', adult), SizedBox(width: 1.0), passenger('infant', infant)]),
					),
				],
			),
		);
	}
	
	Widget passenger(String type, int count) {
		return InkWell(
			onTap: () {
				Scaffold.of(context).showSnackBar(SnackBar(
					content: popupPassenger(type),
					duration: Duration(seconds: 30),
					action: SnackBarAction(
						label: 'tutup',
						onPressed: () {},
					),
				));
			},
			child: Column(children: [Text('${count}', style: TextStyle(fontSize: 18.0)), Text(type, style: TextStyle(fontSize: 12.0, color: Colors.grey[400]))]),
		);
	}
	
	Widget popupPassenger(String type) {
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: [
				Text('${type}'),
				SizedBox(width: 1.0),
				Row(
					children: [
						Container(
							decoration: BoxDecoration(
								color: Colors.purple,
								borderRadius: BorderRadius.circular(12.0),
							),
							child: IconButton(
								icon: new Icon(Icons.add),
								onPressed: () {
									if (type == 'adult') setState(() { adult < 4 ? adult++ : Container(); });
									if (type == 'infant') setState(() { infant < 4 ? infant++ : Container(); });
								}
							),
						),
						SizedBox(width: 5.0),
						Container(
							decoration: BoxDecoration(
								color: Colors.purple,
								borderRadius: BorderRadius.circular(12.0),
							),
							child: IconButton(
								icon: new Icon(Icons.remove),
								onPressed: () {
									if (type == 'adult') setState(() { adult > 0 ? adult-- : Container(); });
									if (type == 'infant') setState(() { infant > 0 ? infant-- : Container(); });
								}
							),
						),
					],
				),
			],
		);
	}
}

class StationSearchDelegate extends SearchDelegate<Station> {
	StationSearchDelegate({ @required this.stationLookup });
	
	final StationLookup stationLookup;
	
	@override
	Widget buildLeading(BuildContext context) {
		return IconButton(
			tooltip: 'Back',
			icon: AnimatedIcon( icon: AnimatedIcons.menu_arrow, progress: transitionAnimation, ),
			onPressed: () { close(context, null); },
		);
	}
	
	@override
	Widget buildSuggestions(BuildContext context) {
		return buildMatchingSuggestions(context);
	}
	
	@override
	Widget buildResults(BuildContext context) {
		return buildMatchingSuggestions(context);
	}
	
	Widget buildMatchingSuggestions(BuildContext context) {
		if (query.isEmpty) return Container();
		// if (query.length < 3) return Container();
		
		final searched = stationLookup.searchString(query);
		
		if (searched.length == 0) return StationSearchPlaceholder(title: 'No results');
		
		return ListView.builder(
			itemCount: searched.length,
			itemBuilder: (context, index) {
				return StationSearchResultTile( station: searched[index], searchDelegate: this, );
			},
		);
	}
	
	@override
	List<Widget> buildActions(BuildContext context) {
		return query.isEmpty ? [] : <Widget>[
			IconButton(
				tooltip: 'Clear',
				icon: const Icon(Icons.clear),
				onPressed: () { query = ''; showSuggestions(context); },
			)
		];
	}
}

class StationSearchPlaceholder extends StatelessWidget {
	StationSearchPlaceholder({@required this.title});
	final String title;
	
	@override
	Widget build(BuildContext context) {
		final ThemeData theme = Theme.of(context);
		return Center(
			child: Text( title, style: theme.textTheme.headline, textAlign: TextAlign.center, ),
		);
	}
}

class StationSearchResultTile extends StatelessWidget {
	const StationSearchResultTile({ @required this.station, @required this.searchDelegate });
	
	final Station station;
	final SearchDelegate<Station> searchDelegate;
	
	@override
	Widget build(BuildContext context) {
		final title = '${station.station_code}';
		final subtitle = '${station.station_name}';
		final ThemeData theme = Theme.of(context);
		return ListTile(
			dense: true,
			title: Text( title, style: theme.textTheme.body2, textAlign: TextAlign.start, ),
			subtitle: Text( subtitle, style: theme.textTheme.body1, textAlign: TextAlign.start, ),
			onTap: () => searchDelegate.close(context, station),
		);
	}
}
