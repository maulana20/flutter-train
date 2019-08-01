import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'model/isonlogin.dart';
import 'model/station.dart';
import 'model/schedule.dart';

import 'api/session.dart';

void main() async {
	final JsonDecoder _decoder = new JsonDecoder();
	
	IsOnLogin _isonlogin;
	
	List<Station> _stations = new List();
	List<Schedule> _schedules = new List();
	
	Session session = new Session();
	
	Future<Station> station() async {
		final response = await rootBundle.loadString('assets/data/station_data.json');
		
		var station = json.decode(response).map<Station>((json) => Station.fromJson(json)).toList();
		
		_stations.clear();
		_stations.addAll(station);
	}
	
	Future login() async {
		final response = await session.post('https://atris.versatiket.co.id/api/admin', body: {'user': 'maulanasaputra11091082@gmail.com', 'password': 'Versa321'});
		
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
	
	/* await station();
	for (final data in _stations) {
		print(data.station_code);
	} */
	
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
}
