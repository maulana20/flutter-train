import 'dart:async';

import 'package:http/http.dart' as http;

import 'session.dart';

import '../model/schedule.dart';
import '../model/itinerary.dart';
import '../screen/train/bloc/search_bloc.dart';

class VersatiketApi {
	final String url = 'url';
	final String username = 'user';
	final String password = 'pass';
	
	Session session = new Session();
	
	Future start() async {
		final isonlogin_data = await isonlogin();
		if (isonlogin_data['status'] == 'failed') {
			final login_data = await login();
			if (login_data['status'] == 'inuse') await ajaxresetlogin();
		}
	}
	
	Future login() async {
		return await session.post(url + '/api/admin', body: {'user': username, 'password': password});
	}
	
	Future ajaxresetlogin() async {
		return await session.post(url + '/api/admin/ajaxresetlogin', body: {'is_agree': 'true'});
	}
	
	Future logout() async {
		return await session.get(url + '/api/admin/logout');
	}
	
	Future isonlogin() async {
		return await session.get(url + '/api/admin/isonlogin');
	}
	
	Future search(Search search) async {
		var params = {'from_code': search.departure.station_code, 'to_code': search.arrival.station_code, 'from_date': search.date, 'to_date': search.date, 'trip_type': 'oneway', 'adult': '${search.adult}', 'child': '0', 'infant': search.infant == null ? '0' : '${search.infant}' };
		print('${params}');
		
		return await session.post(url + '/api/bookkai/kaih2h', body: params);
	}
	
	Future fare(Itinerary itinerary) async {
		var date = '${itinerary.search.date.split('-')[2]}-${itinerary.search.date.split('-')[1]}-${itinerary.search.date.split('-')[0]}';
		var date_time = parseDate('${date}');
		var depart_time = parseDate('${date} ${itinerary.schedule.str_time.split(' ')[0]}');
		var arrive_time = parseDate('${date} ${itinerary.schedule.str_time.split(' ')[1]}');
		var info = ['1', ['Kaih2h', '7000', itinerary.schedule.journey, '${itinerary.search.departure.station_code}-${itinerary.search.arrival.station_code}', '1', depart_time, arrive_time].join('|'), 'C', itinerary.detail.train_name, '0|0|0'].join('~');
		
		var params = { 'id': '7000', 'choice': '${itinerary.detail.train_name}', 'date': '${date_time}', 'from_code': '${itinerary.search.departure.station_code}', 'to_code': '${itinerary.search.arrival.station_code}', 'adult': '${itinerary.search.adult}', 'child': '0', 'infant': itinerary.search.infant == null ? '0' : '${itinerary.search.infant}', 'row': '7001', 'class_code': '${itinerary.detail.train_class}', 'chkbox': '7000', 'seq': '1', 'defcurr': 'IDR', 'info': '${info}', 'code': '${itinerary.schedule.journey}' };
		print('${params}');
		print(url + '/api/bookkai/ajaxkaih2hfare');
		
		return await session.post(url + '/api/bookkai/ajaxkaih2hfare', body: params);
	}
	
	parseDate(String date) {
		final result = DateTime.parse(date).millisecondsSinceEpoch.toString().substring(0, 10);
		return result;
	}
}
