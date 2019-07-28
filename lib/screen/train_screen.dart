import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'train/bloc/train_details_bloc.dart';
import '../model/station.dart';
import '../api/station_lookup.dart';

class TrainScreen extends StatefulWidget {
	TrainScreen({ this.stationLookup });
	
	final StationLookup stationLookup;
	
	@override
	_TrainScreenState createState() => _TrainScreenState(stationLookup: stationLookup);
}

class _TrainScreenState extends State<TrainScreen> {
	_TrainScreenState({ this.stationLookup });
	
	final StationLookup stationLookup;
	
	@override
	Widget build(BuildContext context) {
		final trainDetailsBloc = Provider.of<TrainDetailsBloc>(context);
		
		return Scaffold(
			appBar: AppBar( title: Text('Flutter Train'), ),
			body: StreamBuilder<Train>(
				initialData: Train.initialData(),
				builder: (context, snapshot) {
					return ListView(
						padding: EdgeInsets.zero,
						children: [
							Route(stationLookup: stationLookup, trainDetails: snapshot.data.details, trainDetailsBloc: trainDetailsBloc),
							SizedBox(height: 15.0),
							BoxDecorationDate(),
							SizedBox(height: 15.0),
							BoxDecorationPassenger(),
						]
					);
				}
			),
		);
	}
}

class Route extends StatefulWidget {
	Route({ this.stationLookup, this.trainDetails, this.trainDetailsBloc });
	
	final StationLookup stationLookup;
	final TrainDetails trainDetails;
	final TrainDetailsBloc trainDetailsBloc;
	
	@override
	_RouteState createState() => _RouteState(stationLookup: stationLookup, trainDetails: trainDetails, trainDetailsBloc: trainDetailsBloc);
}

class _RouteState extends State<Route> {
	_RouteState({ this.stationLookup, this.trainDetails, this.trainDetailsBloc });
	
	final StationLookup stationLookup;
	final TrainDetails trainDetails;
	final TrainDetailsBloc trainDetailsBloc;
	
	Future<Station> _showSearch(BuildContext context) async {
		return await showSearch<Station>(
			context: context,
			delegate: StationSearchDelegate( stationLookup: stationLookup )
		);
	}
	
	void selectDepart(BuildContext context) async {
		final departure = await _showSearch(context);
		print(departure);
		// trainDetailsBloc.updateWith(departure: departure);
	}
	
	void selectArrival(BuildContext context) async {
		final arrival = await _showSearch(context);
		print(arrival);
		// trainDetailsBloc.updateWith(arrival: arrival);
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
					StationWidget(code: 'GMR', name: 'Gambir Jakarta', onPressed: () => selectDepart(context), station: trainDetails.departure, trainDetailsBloc: trainDetailsBloc),
					Icon(Icons.train, color: Colors.white, size: 35.0),
					StationWidget(code: 'BD', name: 'Bandung', onPressed: () => selectArrival(context), station: trainDetails.arrival, trainDetailsBloc: trainDetailsBloc),
				],
			),
		);
	}
}

class StationWidget extends StatelessWidget {
	StationWidget({ this.code, this.name, this.onPressed, this.station, this.trainDetailsBloc });
	
	final String code;
	final String name; 
	final VoidCallback onPressed;
	final Station station;
	final TrainDetailsBloc trainDetailsBloc;
	
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
		return InkWell(
			onTap: () { print('passenger'); },
			child: Container(
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
			),
		);
	}
	
	Widget passenger(String type, int count) {
		return Column(children: [Text('${count}', style: TextStyle(fontSize: 18.0)), Text(type, style: TextStyle(fontSize: 12.0, color: Colors.grey[400]))]);
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
