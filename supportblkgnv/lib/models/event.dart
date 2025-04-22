import 'package:flutter/material.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/models/business.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum EventCategory {
  cultural,
  educational,
  networking,
  entertainment,
  community,
  workshop,
  fundraiser,
  other,
}

extension EventCategoryExtension on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.cultural:
        return 'Cultural';
      case EventCategory.educational:
        return 'Educational';
      case EventCategory.networking:
        return 'Networking';
      case EventCategory.entertainment:
        return 'Entertainment';
      case EventCategory.community:
        return 'Community Service';
      case EventCategory.workshop:
        return 'Workshop';
      case EventCategory.fundraiser:
        return 'Fundraiser';
      case EventCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case EventCategory.cultural:
        return Icons.theater_comedy;
      case EventCategory.educational:
        return Icons.school;
      case EventCategory.networking:
        return Icons.people;
      case EventCategory.entertainment:
        return Icons.celebration;
      case EventCategory.community:
        return Icons.volunteer_activism;
      case EventCategory.workshop:
        return Icons.construction;
      case EventCategory.fundraiser:
        return Icons.attach_money;
      case EventCategory.other:
        return Icons.event;
    }
  }

  Color get color {
    switch (this) {
      case EventCategory.cultural:
        return Colors.purple[700]!;
      case EventCategory.educational:
        return Colors.blue[700]!;
      case EventCategory.networking:
        return Colors.teal[700]!;
      case EventCategory.entertainment:
        return Colors.orange[700]!;
      case EventCategory.community:
        return Colors.green[700]!;
      case EventCategory.workshop:
        return Colors.brown[700]!;
      case EventCategory.fundraiser:
        return Colors.red[700]!;
      case EventCategory.other:
        return Colors.grey[700]!;
    }
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Location? location;
  final String? imageUrl;
  final EventCategory category;
  final String organizerId;
  final String? hostingBusinessId;
  final double ticketPrice;
  final bool isFree;
  final int capacity;
  final List<String> attendeeIds;
  final List<String> interestedUserIds;
  final bool needsRideShare;
  final bool providesChildcare;
  final bool isVirtual;
  final String? virtualLink;
  final List<String> tags;

  // Non-stored computed fields
  User? _organizer;
  Business? _hostingBusiness;
  List<User>? _attendees;
  List<User>? _interestedUsers;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.imageUrl,
    required this.category,
    required this.organizerId,
    User? organizer,
    this.hostingBusinessId,
    Business? hostingBusiness,
    this.ticketPrice = 0.0,
    this.isFree = true,
    this.capacity = 0,
    this.attendeeIds = const [],
    List<User>? attendees,
    this.interestedUserIds = const [],
    List<User>? interestedUsers,
    this.needsRideShare = false,
    this.providesChildcare = false,
    this.isVirtual = false,
    this.virtualLink,
    this.tags = const [],
  }) : 
      _organizer = organizer,
      _hostingBusiness = hostingBusiness,
      _attendees = attendees,
      _interestedUsers = interestedUsers;

  // Getters for related objects
  User? get organizer => _organizer;
  Business? get hostingBusiness => _hostingBusiness;
  List<User> get attendees => _attendees ?? [];
  List<User> get interestedUsers => _interestedUsers ?? [];

  // Setters for related objects
  set organizer(User? user) => _organizer = user;
  set hostingBusiness(Business? business) => _hostingBusiness = business;
  set attendees(List<User>? users) => _attendees = users;
  set interestedUsers(List<User>? users) => _interestedUsers = users;

  bool get isPast => endTime.isBefore(DateTime.now());
  bool get isOngoing =>
      startTime.isBefore(DateTime.now()) && endTime.isAfter(DateTime.now());
  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isFull => capacity > 0 && attendeeIds.length >= capacity;

  String get timeDisplay {
    final startDay = '${startTime.month}/${startTime.day}/${startTime.year}';
    final endDay = '${endTime.month}/${endTime.day}/${endTime.year}';

    final startHour =
        startTime.hour > 12
            ? startTime.hour - 12
            : (startTime.hour == 0 ? 12 : startTime.hour);
    final startAmPm = startTime.hour >= 12 ? 'PM' : 'AM';
    final startMinute =
        startTime.minute < 10 ? '0${startTime.minute}' : '${startTime.minute}';

    final endHour =
        endTime.hour > 12
            ? endTime.hour - 12
            : (endTime.hour == 0 ? 12 : endTime.hour);
    final endAmPm = endTime.hour >= 12 ? 'PM' : 'AM';
    final endMinute =
        endTime.minute < 10 ? '0${endTime.minute}' : '${endTime.minute}';

    if (startDay == endDay) {
      return '$startDay, $startHour:$startMinute $startAmPm - $endHour:$endMinute $endAmPm';
    } else {
      return '$startDay, $startHour:$startMinute $startAmPm - $endDay, $endHour:$endMinute $endAmPm';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'location': location?.toMap(),
      'imageUrl': imageUrl,
      'category': category.toString().split('.').last,
      'organizerId': organizerId,
      'hostingBusinessId': hostingBusinessId,
      'ticketPrice': ticketPrice,
      'isFree': isFree,
      'capacity': capacity,
      'attendeeIds': attendeeIds,
      'interestedUserIds': interestedUserIds,
      'needsRideShare': needsRideShare,
      'providesChildcare': providesChildcare,
      'isVirtual': isVirtual,
      'virtualLink': virtualLink,
      'tags': tags,
    };
  }
  
  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Parse location if available
    Location? location;
    if (data['location'] != null) {
      location = Location.fromMap(data['location'] as Map<String, dynamic>);
    }
    
    // Parse category
    EventCategory category = _parseEventCategory(data['category'] ?? 'other');
    
    // Parse times
    DateTime startTime = data['startTime'] is Timestamp 
        ? (data['startTime'] as Timestamp).toDate() 
        : DateTime.now();
    DateTime endTime = data['endTime'] is Timestamp 
        ? (data['endTime'] as Timestamp).toDate() 
        : DateTime.now().add(const Duration(hours: 2));
    
    return Event(
      id: doc.id,
      title: data['title'] ?? 'Untitled Event',
      description: data['description'] ?? '',
      startTime: startTime,
      endTime: endTime,
      location: location,
      imageUrl: data['imageUrl'],
      category: category,
      organizerId: data['organizerId'] ?? '',
      hostingBusinessId: data['hostingBusinessId'],
      ticketPrice: (data['ticketPrice'] as num?)?.toDouble() ?? 0.0,
      isFree: data['isFree'] ?? true,
      capacity: data['capacity'] ?? 0,
      attendeeIds: data['attendeeIds'] != null ? List<String>.from(data['attendeeIds']) : [],
      interestedUserIds: data['interestedUserIds'] != null ? List<String>.from(data['interestedUserIds']) : [],
      needsRideShare: data['needsRideShare'] ?? false,
      providesChildcare: data['providesChildcare'] ?? false,
      isVirtual: data['isVirtual'] ?? false,
      virtualLink: data['virtualLink'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
    );
  }
  
  // Helper method to parse event category from string
  static EventCategory _parseEventCategory(String categoryStr) {
    switch (categoryStr.toLowerCase()) {
      case 'cultural': return EventCategory.cultural;
      case 'educational': return EventCategory.educational;
      case 'networking': return EventCategory.networking;
      case 'entertainment': return EventCategory.entertainment;
      case 'community': return EventCategory.community;
      case 'workshop': return EventCategory.workshop;
      case 'fundraiser': return EventCategory.fundraiser;
      default: return EventCategory.other;
    }
  }
}
