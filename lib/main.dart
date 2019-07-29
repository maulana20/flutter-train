import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'screen/train_screen.dart';

import 'model/station.dart';
import 'api/station_lookup.dart';

void main() async {
	final start = DateTime.now();
	
	List<Station> stations = await StationDataReader.load('assets/data/station_data.json');
	
	final elapsed = DateTime.now().difference(start);
	print('Loaded stations data in $elapsed');
	
	runApp(MyApp(stationLookup: StationLookup(stations: stations)));
}

class StationDataReader {
	static Future<List<Station>> load(String path) async {
		final data = await rootBundle.loadString(path);
		
		return json.decode(data).map<Station>((json) => Station.fromJson(json)).toList();
	}
}

class MyApp extends StatelessWidget {
	MyApp({this.stationLookup});
	
	final StationLookup stationLookup;
	final String title = 'Flutter Train';
	
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: title,
			theme: ThemeData(
				primarySwatch: Colors.blue,
			),
			home: TrainScreen(stationLookup: stationLookup),
		);
	}
}
