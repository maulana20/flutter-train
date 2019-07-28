import 'package:flutter/foundation.dart';

class Station extends Object {
	String station_code;
	String station_name;
	
	Station({this.station_code, this.station_name});
	
	factory Station.fromJson(Map<String, dynamic> json) {
		return Station(
			station_code: json['station_code'],
			station_name: json['station_name'],
		);
	}
}
