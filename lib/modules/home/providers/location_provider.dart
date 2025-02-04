import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pumba/core/providers/permission_provider.dart';

final locationProvider = ChangeNotifierProvider.autoDispose(
  (ref) => LocationNotifier(ref),
);

class LocationNotifier extends ChangeNotifier {
  final Ref _ref;
  final _logger = FimberLog('LocationProvider');
  String _location = '';
  bool _isLoading = false;

  String get location => _location;
  bool get isLoading => _isLoading;

  LocationNotifier(this._ref) {
    _logger.i('LocationNotifier created');
    final ps = _ref.read(permissionProvider).locationPermissionStatus;
    if (ps == PermissionStatus.granted) {
      getAddress();
    }
  }

  Future<void> getAddress() async {
    try {
      _isLoading = true;
      Position? position = await _getCurrentLocation();
      if (position != null) {
        _location = await _getAddressFromCoordinates(position);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _logger.e('Error getting address: $e');
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "${place.street}, ${place.locality}, ${place.country}";
      }
      return "Address not found";
    } catch (e) {
      return "Error getting address: $e";
    }
  }
}
