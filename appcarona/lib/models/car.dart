class Car {
  String? key;
  String? plate;
  String? name;
  String? color;

  Car({this.key, this.plate, this.name, this.color});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      key: json['key'],
      plate: json['plate'],
      name: json['name'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'plate': plate,
      'name': name,
      'color': color,
    };
  }
}
