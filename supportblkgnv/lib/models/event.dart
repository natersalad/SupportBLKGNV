import 'package:flutter/material.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/models/business.dart';

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
  final User organizer;
  final Business? hostingBusiness;
  final double ticketPrice;
  final bool isFree;
  final int capacity;
  final List<User> attendees;
  final List<User> interestedUsers;
  final bool needsRideShare;
  final bool providesChildcare;
  final bool isVirtual;
  final String? virtualLink;
  final List<String> tags;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.imageUrl,
    required this.category,
    required this.organizer,
    this.hostingBusiness,
    this.ticketPrice = 0.0,
    this.isFree = true,
    this.capacity = 0,
    this.attendees = const [],
    this.interestedUsers = const [],
    this.needsRideShare = false,
    this.providesChildcare = false,
    this.isVirtual = false,
    this.virtualLink,
    this.tags = const [],
  });

  bool get isPast => endTime.isBefore(DateTime.now());
  bool get isOngoing =>
      startTime.isBefore(DateTime.now()) && endTime.isAfter(DateTime.now());
  bool get isUpcoming => startTime.isAfter(DateTime.now());
  bool get isFull => capacity > 0 && attendees.length >= capacity;

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
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location':
          location != null
              ? {
                'latitude': location!.latitude,
                'longitude': location!.longitude,
                'address': location!.address,
              }
              : null,
      'imageUrl': imageUrl,
      'category': category.toString(),
      'organizer': organizer.toMap(),
      'hostingBusiness': hostingBusiness?.toMap(),
      'ticketPrice': ticketPrice,
      'isFree': isFree,
      'capacity': capacity,
      'attendees': attendees.map((user) => user.toMap()).toList(),
      'interestedUsers': interestedUsers.map((user) => user.toMap()).toList(),
      'needsRideShare': needsRideShare,
      'providesChildcare': providesChildcare,
      'isVirtual': isVirtual,
      'virtualLink': virtualLink,
      'tags': tags,
    };
  }
}
