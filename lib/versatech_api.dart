import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import 'model/station.dart';

void main() async {
	List<Station> _stations = new List();
	
	Future<Station> station() async {
		final response = await rootBundle.loadString('assets/data/station_data.json');
		
		var station = json.decode(response).map<Station>((json) => Station.fromJson(json)).toList();
		
		_stations.clear();
		_stations.addAll(station);
	}
	
	await station();
	for (final data in _stations) {
		print(data.station_code);
	}
}
