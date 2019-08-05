class Passenger extends Object {
	final String type;
	final String title;
	final String name;
	final String identity;
	
	Passenger({ this.type, this.title, this.name, this.identity });
	Passenger fromJson(Map<String, dynamic> json) {
		return Passenger(
			type: json['type'],
			title: json['title'],
			name: json['name'],
			identity: json['identity'],
		);
	}
}
