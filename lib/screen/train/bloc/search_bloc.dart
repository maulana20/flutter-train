import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../model/station.dart';

class SearchBloc {
	final BehaviorSubject _searchSubject = BehaviorSubject<Search>(seedValue: Search());
	
	Stream<Search> get searchStream => _searchSubject.controller.stream;
	
	void updateWith({ Station departure, Station arrival, String date, int adult, int infant }) {
		Search value = _searchSubject.value.copyWith(departure: departure, arrival: arrival, date: date, adult: adult, infant: infant);
		_searchSubject.add(value);
	}
	
	void dispose() {
		_searchSubject.close();
	}
}

class Search {
	final Station departure;
	final Station arrival;
	final String date;
	final int adult;
	final int infant;
	
	Search({ this.departure, this.arrival, this.date, this.adult, this.infant });
	Search copyWith({ Station departure, Station arrival, String date, int adult, int infant }) {
		return Search(
			departure: departure ?? this.departure,
			arrival: arrival ?? this.arrival,
			date: date ?? this.date,
			adult: adult ?? this.adult,
			infant: infant ?? this.infant,
		);
	}
}
