import 'package:geolocator/geolocator.dart';

class Geolocation {
  Position? position;

  Future<Position> getUserPosition() async {
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> geolocationServiceEnabled() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Services are disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return serviceEnabled;
  }

  Future<Position?> getPosition(Future<Position>? futurePosition) async {
    return await futurePosition;
  }
}
