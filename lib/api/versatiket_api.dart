import 'dart:async';

import 'package:http/http.dart' as http;

import 'session.dart';

import '../model/schedule.dart';
import '../screen/train/bloc/search_bloc.dart';

class VersatiketApi {
	final String url = 'https://atris.versatiket.co.id';
	final String username = 'maulanasaputra11091082@gmail.com';
	final String password = 'Versa321';
	
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
}
