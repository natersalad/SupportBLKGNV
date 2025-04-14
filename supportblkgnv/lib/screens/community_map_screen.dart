import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supportblkgnv/services/map_service.dart';

class CommunityMapScreen extends StatefulWidget {
  final String initialFilter;
  
  const CommunityMapScreen({
    Key? key, 
    this.initialFilter = 'all',
  }) : super(key: key);

  @override
  State<CommunityMapScreen> createState() => _CommunityMapScreenState();
}

class _CommunityMapScreenState extends State<CommunityMapScreen> {
  final MapService _mapService = MapService();
  final Completer<GoogleMapController> _controller = Completer();
  
  // Filter options
  final List<String> _filterOptions = ['all', 'businesses', 'events'];
  String _currentFilter = 'all';
  
  // Map display options
  String _mapType = 'normal';
  bool _showTraffic = false;
  
  // Marker collections
  Set<Marker> _businessMarkers = {};
  Set<Marker> _eventMarkers = {};
  Set<Marker> _visibleMarkers = {};
  
  @override
  void initState() {
    super.initState();
    _currentFilter = widget.initialFilter;
    _loadMarkers();
  }
  
  Future<void> _loadMarkers() async {
    final businessMarkers = await _mapService.getBusinessMarkers(context);
    final eventMarkers = await _mapService.getEventMarkers(context);
    
    setState(() {
      _businessMarkers = businessMarkers;
      _eventMarkers = eventMarkers;
      _updateVisibleMarkers();
    });
  }
  
  void _updateVisibleMarkers() {
    Set<Marker> visibleMarkers = {};
    
    switch (_currentFilter) {
      case 'businesses':
        visibleMarkers = _businessMarkers;
        break;
      case 'events':
        visibleMarkers = _eventMarkers;
        break;
      case 'all':
      default:
        visibleMarkers = {..._businessMarkers, ..._eventMarkers};
        break;
    }
    
    setState(() {
      _visibleMarkers = visibleMarkers;
    });
  }
  
  void _changeFilter(String filter) {
    setState(() {
      _currentFilter = filter;
      _updateVisibleMarkers();
    });
    
    _fitMapToMarkers();
  }
  
  Future<void> _fitMapToMarkers() async {
    if (_visibleMarkers.isEmpty) return;
    
    final GoogleMapController controller = await _controller.future;
    final CameraPosition position = _mapService.getBoundingBoxCameraPosition(_visibleMarkers);
    
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }
  
  void _toggleMapType() {
    setState(() {
      switch (_mapType) {
        case 'normal':
          _mapType = 'satellite';
          break;
        case 'satellite':
          _mapType = 'hybrid';
          break;
        case 'hybrid':
          _mapType = 'terrain';
          break;
        case 'terrain':
        default:
          _mapType = 'normal';
          break;
      }
    });
  }
  
  void _toggleTraffic() {
    setState(() {
      _showTraffic = !_showTraffic;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: _toggleMapType,
            tooltip: 'Change map type',
          ),
          IconButton(
            icon: Icon(
              Icons.traffic,
              color: _showTraffic ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: _toggleTraffic,
            tooltip: 'Toggle traffic',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: GoogleMap(
              mapType: _mapService.getMapType(_mapType),
              initialCameraPosition: _mapService.getInitialCameraPosition(),
              markers: _visibleMarkers,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              trafficEnabled: _showTraffic,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // Fit map to markers after it's created
                Future.delayed(const Duration(milliseconds: 300), _fitMapToMarkers);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fitMapToMarkers,
        child: const Icon(Icons.center_focus_strong),
        tooltip: 'Center map',
      ),
    );
  }
  
  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: _filterOptions.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(
                filter.substring(0, 1).toUpperCase() + filter.substring(1),
                style: TextStyle(
                  color: _currentFilter == filter
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              selected: _currentFilter == filter,
              onSelected: (selected) {
                if (selected) {
                  _changeFilter(filter);
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }).toList(),
      ),
    );
  }
} 