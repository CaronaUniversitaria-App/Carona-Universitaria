class Ride {
  String? userId;
  String? rideId;
  String? userName;
  String? carKey;
  String? departureLocation;
  String? departureTime;
  String? destination;
  String? seats;
  String? stops;
  String? timestamp;
  String? status;

  Ride({
    this.userId,
    this.rideId,
    this.userName,
    this.carKey,
    this.departureLocation,
    this.departureTime,
    this.destination,
    this.seats,
    this.stops,
    this.timestamp,
    this.status,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      userId: json['userId'],
      rideId: json['rideId'],
      userName: json['userName'],
      carKey: json['carKey'],
      departureLocation: json['departureLocation'],
      departureTime: json['departureTime'],
      destination: json['destination'],
      seats: json['seats'],
      stops: json['stops'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rideId': rideId,
      'userName': userName,
      'carKey': carKey,
      'departureLocation': departureLocation,
      'departureTime': departureTime,
      'destination': destination,
      'seats': seats,
      'stops': stops,
      'timestamp': timestamp,
      'status': status,
    };
  }
}
