import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'train_schedule_page.dart';
import 'bloc/search_bloc.dart';

import '../../model/station.dart';
import '../../model/schedule.dart';
import '../../api/station_lookup.dart';
import '../../api/versatiket_api.dart';

class TrainPage extends StatefulWidget {
	TrainPage({ this.stationLookup });
	
	final StationLookup stationLookup;
	
	@override
	_TrainPageState createState() => _TrainPageState(stationLookup: stationLookup);
}

class _TrainPageState extends State<TrainPage> {
	_TrainPageState({ this.stationLookup });
	
	final StationLookup stationLookup;
	
	VersatiketApi _versaApi;
	List<Schedule> schedules;
	
	bool _isLoading = false;
	
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
	
	Future _process(Search search) async {
		if (search.departure == null) {
			_alert(context, 'tidak ada pilih untuk keberangkatan');
		} else if (search.arrival == null) {
			_alert(context, 'tidak ada pilih untuk tiba');
		} else if (search.date == null) {
			_alert(context, 'tanggal harus di isi');
		} else if (search.adult == null) {
			_alert(context, 'penumpang dewasa tidak boleh kosong');
		} else {
			setState(() { _isLoading = true; } );
			await _versaApi.start();
			
			var res = await _versaApi.search(search);
			
			if (res['status'] == 'timeout') { 
				_alert(context, res['message']);
			} else if (res['status'] == 'failed') {
				_alert(context, res['content']['reason']);
			} else {
				if (res['content']['list'] == null) {
					_alert(context, 'data kosong !');
				} else {
					schedules = res['content']['list'].map<Schedule>((json) => Schedule.fromJson(json)).toList();
					Navigator.push(context, MaterialPageRoute(builder: (context) => TrainSchedulePage(search: search, schedules: schedules)));
				}
			}
			setState(() { _isLoading = false; } );
		}
	}
	
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
							BoxDecorationDate(searchBloc: searchBloc),
							SizedBox(height: 15.0),
							BoxDecorationPassenger(searchBloc: searchBloc),
							SizedBox(height: 30.0),
							BoxDecorationButton(snapshot.data),
						],
					);
				},
			),
		);
	}
	
	Widget BoxDecorationButton(Search search) {
		return InkWell(
			onTap: () { _isLoading ? null : _process(search); },
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
					child: _isLoading ? SizedBox(child: CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.white)), height: 10.0, width: 10.0 ) : Text('SEARCH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white)),
				),
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
		searchBloc.updateWith(departure: station);
	}
	
	void _selectArrival(BuildContext context) async {
		var station = await _showSearch(context);
		setState(() => arrival = station);
		
		print(arrival);
		searchBloc.updateWith(arrival: station);
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
					StationWidget(title: 'KEBERANGKATAN', station: departure, onPressed: () => _selectDepart(context)),
					Icon(Icons.train, color: Colors.white, size: 35.0),
					StationWidget(title: 'TIBA', station: arrival, onPressed: () => _selectArrival(context)),
				],
			),
		);
	}
}

class StationWidget extends StatelessWidget {
	StationWidget({ this.title, this.station, this.onPressed });
	
	final String title;
	final Station station;
	final VoidCallback onPressed;
	
	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: onPressed,
			child: Column(
				children: [
					Text(station != null ? station.station_code : '---', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white)),
					Text(station != null ? station.station_name : title, style: TextStyle(fontSize: 10.0, color: Colors.white))
				]
			),
		);
	}
}


class BoxDecorationDate extends StatefulWidget {
	BoxDecorationDate({ this.searchBloc });
	
	final SearchBloc searchBloc;
	
	@override
	_BoxDecorationDateState createState() => _BoxDecorationDateState(searchBloc: searchBloc);
}

class _BoxDecorationDateState extends State<BoxDecorationDate> {
	_BoxDecorationDateState({ this.searchBloc });
	
	final SearchBloc searchBloc;
	String date = "dd-mm-yyyy";
	// String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
	
	Future _selectDate() async {
		DateTime picked = await showDatePicker(
			context: context,
			initialDate: new DateTime.now(),
			firstDate: new DateTime(2016),
			lastDate: new DateTime(2030)
		);
		if(picked != null) {
			setState(() {
				date = DateFormat('dd-MM-yyyy').format(picked);
				print('Selected date: ' + date);
				searchBloc.updateWith(date: date);
			});
		}
	}
	
	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: () { _selectDate(); },
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
	BoxDecorationPassenger({ this.searchBloc });
	
	final SearchBloc searchBloc;
	
	@override
	_BoxDecorationPassengerState createState() => _BoxDecorationPassengerState(searchBloc: searchBloc);
}

class _BoxDecorationPassengerState extends State<BoxDecorationPassenger> {
	_BoxDecorationPassengerState({ this.searchBloc });
	
	final SearchBloc searchBloc;
	int adult = 0;
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
									if (type == 'adult') setState(() { if (adult < 4) { adult++; searchBloc.updateWith(adult: adult); } else { Container(); } });
									if (type == 'infant') setState(() { if (infant < 4) { infant++; searchBloc.updateWith(infant: infant); } else { Container(); } });
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
									if (type == 'adult') setState(() { if (adult > 0) { adult--; searchBloc.updateWith(adult: adult); } else { Container(); } });
									if (type == 'infant') setState(() { if (infant > 0) { infant--; searchBloc.updateWith(infant: infant); } else { Container(); } });
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
