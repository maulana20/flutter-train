import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'train/train_page.dart';
import 'train/bloc/search_bloc.dart';

import '../model/station.dart';
import '../api/station_lookup.dart';

class TrainScreen extends StatefulWidget {
	@override
	_TrainScreenState createState() => _TrainScreenState();
}

class _TrainScreenState extends State<TrainScreen> {
	List<Station> stations = new List();
	
	Future getStation() async {
		final start = DateTime.now();
		
		final response = await StationDataReader.load('assets/data/station_data.json');
		
		stations.clear();
		stations.addAll(response);
		
		final elapsed = DateTime.now().difference(start);
		print('Loaded stations data in $elapsed');
	}
	
	void initState() {
		super.initState();
		getStation();
	}
	
	@override
	Widget build(BuildContext context) {
		return StatefulProvider<SearchBloc>(
			valueBuilder: (context) => SearchBloc(),
			onDispose: (context, bloc) => bloc.dispose(),
			child: TrainPage(stationLookup: StationLookup(stations: stations)),
		);
	}
}

class StationDataReader {
	static Future<List<Station>> load(String path) async {
		final data = await rootBundle.loadString(path);
		
		return json.decode(data).map<Station>((json) => Station.fromJson(json)).toList();
	}
}
