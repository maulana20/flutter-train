import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class SearchBloc {
	final StreamController _searchSubject = StreamController<Search>();
	
	Stream<Search> get searchStream => _searchSubject.stream;
	
	void updateWith({ String from_code }) {
		_searchSubject.add(Search(from_code: from_code));
	}
	
	void dispose() {
		_searchSubject.close();
	}
}

class Search {
	final String from_code;
	
	Search({ this.from_code });
	Search copyWith({ String from_code }) {
		return Search(
			from_code: from_code ?? this.from_code,
		);
	}
}
