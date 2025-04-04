import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supportblkgnv/models/business.dart';
import 'package:supportblkgnv/models/event.dart';
import 'package:supportblkgnv/services/mock_community_service.dart';

class MapService {
  final MockCommunityService _mockService = MockCommunityService();
  
  /// Creates map markers for businesses
  Future<Set<Marker>> getBusinessMarkers(BuildContext context) async {
    final businesses = _mockService.getBusinesses();
    final Set<Marker> markers = {};
    
    for (var business in businesses) {
      // For demo purposes, assign random locations around Gainesville, FL
      final LatLng position = _getRandomGainesvilleLocation();
      
      markers.add(
        Marker(
          markerId: MarkerId('business_${business.id}'),
          position: position,
          infoWindow: InfoWindow(
            title: business.name,
            snippet: business.category.displayName,
            onTap: () {
              // TODO: Show business details dialog or navigate to business page
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    }
    
    return markers;
  }

  /// Creates map markers for events
  Future<Set<Marker>> getEventMarkers(BuildContext context) async {
    final events = _mockService.getEvents();
    final Set<Marker> markers = {};
    
    for (var event in events) {
      // For demo purposes, assign random locations around Gainesville, FL
      final LatLng position = _getRandomGainesvilleLocation();
      
      markers.add(
        Marker(
          markerId: MarkerId('event_${event.id}'),
          position: position,
          infoWindow: InfoWindow(
            title: event.title,
            snippet: '${event.startTime.toString().substring(0, 16)}',
            onTap: () {
              // TODO: Show event details dialog or navigate to event page
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }
    
    return markers;
  }
  
  /// Returns a random location in Gainesville, FL area for demo purposes
  LatLng _getRandomGainesvilleLocation() {
    // Gainesville, FL center coordinates
    const double baseLat = 29.6516;
    const double baseLng = -82.3248;
    
    // Generate random offset (approximately within city limits)
    final double latOffset = (DateTime.now().millisecondsSinceEpoch % 100) / 1000;
    final double lngOffset = (DateTime.now().millisecondsSinceEpoch % 200) / 1000;
    
    return LatLng(
      baseLat + latOffset * (DateTime.now().second % 2 == 0 ? 1 : -1),
      baseLng + lngOffset * (DateTime.now().minute % 2 == 0 ? 1 : -1),
    );
  }
  
  /// Returns the initial camera position for Gainesville, FL
  CameraPosition getInitialCameraPosition() {
    return const CameraPosition(
      target: LatLng(29.6516, -82.3248), // Gainesville, FL coordinates
      zoom: 12.0,
    );
  }
  
  /// Calculates the optimal camera position to fit all markers
  CameraPosition getBoundingBoxCameraPosition(Set<Marker> markers) {
    if (markers.isEmpty) {
      return getInitialCameraPosition();
    }
    
    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;
    
    for (var marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;
      
      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLng = lng < minLng ? lng : minLng;
      maxLng = lng > maxLng ? lng : maxLng;
    }
    
    // Center of the bounding box
    final centerLat = (minLat + maxLat) / 2;
    final centerLng = (minLng + maxLng) / 2;
    
    return CameraPosition(
      target: LatLng(centerLat, centerLng),
      zoom: 12.0, // This would ideally be calculated based on the size of the bounding box
    );
  }
  
  /// Generates sample heat map data for economic impact visualization
  Map<String, double> getHeatMapData() {
    // Mock data for economic impact by neighborhood
    return {
      'Downtown': 350000.0,
      'East Gainesville': 275000.0,
      'University Area': 425000.0,
      'Northwest': 180000.0,
      'Southwest': 210000.0,
    };
  }
  
  /// Returns a MapType value based on string preference
  MapType getMapType(String mapTypeString) {
    switch (mapTypeString.toLowerCase()) {
      case 'satellite':
        return MapType.satellite;
      case 'hybrid':
        return MapType.hybrid;
      case 'terrain':
        return MapType.terrain;
      case 'normal':
      default:
        return MapType.normal;
    }
  }
} 