import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'model/isonlogin.dart';
import 'model/station.dart';
import 'model/schedule.dart';
import 'model/schedule_detail.dart';
import 'model/passenger.dart';
import 'model/itinerary.dart';

import 'screen/train/bloc/search_bloc.dart';

import 'api/session.dart';

void main() async {
	final JsonDecoder _decoder = new JsonDecoder();
	
	IsOnLogin _isonlogin;
	
	List<Station> _stations = new List();
	List<Schedule> _schedules = new List();
	List<Passenger> _passengers = new List();
	
	Itinerary itinerary;
	
	Session session = new Session();
	
	Future<Station> station() async {
		final response = await rootBundle.loadString('assets/data/station_data.json');
		
		var station = json.decode(response).map<Station>((json) => Station.fromJson(json)).toList();
		
		_stations.clear();
		_stations.addAll(station);
	}
	
	Future login() async {
		final response = await session.post('https://atris.versatiket.co.id/api/admin', body: {'user': 'user', 'password': 'password'});
		
		return response;
	}
	
	Future ajaxresetlogin() async {
		final response = await session.post('https://atris.versatiket.co.id/api/admin/ajaxresetlogin', body: {'is_agree': 'true'});
		
		return response;
	}
	
	Future<IsOnLogin> isonlogin() async {
		final response = await session.get('https://atris.versatiket.co.id/api/admin/isonlogin');
		
		_isonlogin = IsOnLogin.fromJson(response['content']);
	}
	
	Future logout() async {
		final response = await session.get('https://atris.versatiket.co.id/api/admin/logout');
		
		return response;
	}
	
	Future<Schedule> search() async {
		final response = await session.post('https://atris.versatiket.co.id/api/bookkai/kaih2h', body: {'from_code': 'GMR', 'to_code': 'BD', 'trip_type': 'oneway', 'from_date': '29-08-2019', 'to_date': '29-08-2019', 'adult': '1', 'child': '0', 'infant': '0' });
		
		var schedule = response['content']['list'].map<Schedule>((json) => Schedule.fromJson(json)).toList();
		
		_schedules.clear();
		_schedules.addAll(schedule);
	}
	
	Future<Passenger> passengerx(int adult, int infant) {
		_passengers.clear();
		for (var i = 0; i < adult; i++) {
			_passengers.add(Passenger(type: "Adult", title: "Mr"));
		}
		for (var i = 0; i < infant; i++) {
			_passengers.add(Passenger(type: "Infant", title: "Mstr"));
		}
	}
	
	Future _itinerary() {
		Search search = Search(departure: Station(station_code: 'GMR'), arrival: Station(station_code: 'BD'), date: '30-08-2019', adult: 1);
		Schedule schedule = Schedule(journey: '20', ka_name: 'ARGO PARAHYANGAN', route: 'GMR-BD', str_time: '05:25 08:52');
		ScheduleDetail detail = ScheduleDetail(train_name: '20-ARGO PARAHYANGAN-C', train_class: 'ECONOMY-C', type: 'Economy', seat: 'Available', disabled: false);
		
		itinerary = Itinerary(search: search, schedule: schedule, detail: detail);
	}
	
	parseDate(String date) {
		final result = DateTime.parse(date).millisecondsSinceEpoch.toString().substring(0, 10);
		return result;
	}
	
	Future fare(Itinerary itinerary) {
		var date = '${itinerary.search.date.split('-')[2]}-${itinerary.search.date.split('-')[1]}-${itinerary.search.date.split('-')[0]}';
		var info = ['1', ['Kaih2h', '7000', itinerary.schedule.journey, '${itinerary.search.departure.station_code}-${itinerary.search.arrival.station_code}', '1', parseDate('${date} ${itinerary.schedule.str_time.split(' ')[0]}'), parseDate('${date} ${itinerary.schedule.str_time.split(' ')[1]}')].join('|'), 'C', itinerary.detail.train_name, '0|0|0'];
		
		var params = { 'id': '7000', 'choice': itinerary.detail.train_name, 'date': parseDate('${date}'), 'from_code': itinerary.search.departure.station_code, 'to_code': itinerary.search.arrival.station_code, 'adult': '${itinerary.search.adult}', 'child': '0', 'infant': itinerary.search.infant == null ? '0' : '${itinerary.search.infant}', 'row': '7001', 'class_code': itinerary.detail.train_class, 'chkbox': '7000', 'seq': '1', 'defcurr': 'IDR', 'info': info.join('~'), 'code': itinerary.schedule.journey };
		print('${params}');
	}
	
	Future<String> _read() async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/session.txt');
		return await file.readAsString();
	}
	
	Future _write(String text) async {
		final directory = await getApplicationDocumentsDirectory();
		final file = File('${directory.path}/session.txt');
		await file.writeAsString(text);
	}
	
	/* await station();
	for (final data in _stations) {
		print(data.station_code);
	} 
	
	var login_data = await login();
	if (login_data['status'] == 'inuse') await ajaxresetlogin();
	
	await isonlogin();
	print('info:' + _isonlogin.info + ' ' + 'url_login:' + _isonlogin.url_login + ' ' + 'url_logout:' + _isonlogin.url_logout);
	
	await search();
	for (final data in _schedules) {
		for (final detail in data.detail) {
			print('${detail.adult_fare}');
		}
	}
	
	await logout();
	
	print(_passengers.length);
	await passengerx(1, 1);
	for (final data in _passengers) {
		print(data.title);
	}
	print(_passengers.length);
	
	await _itinerary();
	await fare(itinerary);
	
	await _write('hahaha');
	var data = await _read();
	
	print(data);
	
	var date = DateFormat("yyyy-MM-dd").format(DateTime.fromMicrosecondsSinceEpoch(1566264087000 * 1000));
	print(date); */
	
	var depart = DateTime.fromMicrosecondsSinceEpoch(1568172600 * 1000 * 1000);
	var arrive = DateTime.fromMicrosecondsSinceEpoch(1568183940 * 1000 * 1000);
	Duration diff = arrive.difference(depart);
	print(diff);
}
