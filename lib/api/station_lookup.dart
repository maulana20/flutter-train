import '../model/station.dart';

class StationLookup {
	StationLookup({this.stations});
	final List<Station> stations;
	
	List<Station> searchString(String string) {
		string = string.toLowerCase();
		
		final matching = stations.where((station) { return station.station_code.toLowerCase() == string || station.station_name.toLowerCase() == string; }).toList();
		
		if (matching.length > 0)  return matching;
		
		return stations.where((station) { return station.station_code.toLowerCase().contains(string) || station.station_name.toLowerCase().contains(string); }).toList();
	}
}
