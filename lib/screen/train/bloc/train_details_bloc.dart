import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../model/station.dart';

class TrainDetailsBloc {
	BehaviorSubject _trainSubject = BehaviorSubject<Train>(
		seedValue: Train.initialData(),
	);
	
	Stream<Train> get trainStream => _trainSubject.controller.stream;
	
	void updateWith({ Station departure, Station arrival }) {
		Train newValue = _trainSubject.value.copyWith(
			departure: departure,
			arrival: arrival,
		);
		_trainSubject.add(newValue);
	}
	
	dispose() {
		_trainSubject.close();
	}
}

class Train {
	Train({@required this.details});
	final TrainDetails details;
	
	factory Train.initialData() {
		return Train(
			details: TrainDetails()
		);
	}
	
	Train copyWith({ Station departure, Station arrival }) {
		TrainDetails trainDetails = details.copyWith( departure: departure, arrival: arrival );
		return Train(
			details: trainDetails
		);
	}
}

class TrainDetails {
	final Station departure;
	final Station arrival;
	
	TrainDetails({ this.departure, this.arrival });
	TrainDetails copyWith({ Station departure, Station arrival }) {
		return TrainDetails(
			departure: departure ?? this.departure,
			arrival: arrival ?? this.arrival,
		);
	}
}
