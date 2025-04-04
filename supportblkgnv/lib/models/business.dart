import 'package:flutter/material.dart';
import 'package:supportblkgnv/models/user.dart';

enum BusinessCategory {
  food,
  retail,
  services,
  health,
  beauty,
  tech,
  arts,
  education,
  finance,
  other
}

extension BusinessCategoryExtension on BusinessCategory {
  String get displayName {
    switch (this) {
      case BusinessCategory.food:
        return 'Food & Dining';
      case BusinessCategory.retail:
        return 'Retail & Shopping';
      case BusinessCategory.services:
        return 'Professional Services';
      case BusinessCategory.health:
        return 'Health & Wellness';
      case BusinessCategory.beauty:
        return 'Beauty & Self-Care';
      case BusinessCategory.tech:
        return 'Technology';
      case BusinessCategory.arts:
        return 'Arts & Culture';
      case BusinessCategory.education:
        return 'Education & Training';
      case BusinessCategory.finance:
        return 'Financial Services';
      case BusinessCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case BusinessCategory.food:
        return Icons.restaurant;
      case BusinessCategory.retail:
        return Icons.shopping_bag;
      case BusinessCategory.services:
        return Icons.business_center;
      case BusinessCategory.health:
        return Icons.healing;
      case BusinessCategory.beauty:
        return Icons.spa;
      case BusinessCategory.tech:
        return Icons.computer;
      case BusinessCategory.arts:
        return Icons.palette;
      case BusinessCategory.education:
        return Icons.school;
      case BusinessCategory.finance:
        return Icons.account_balance;
      case BusinessCategory.other:
        return Icons.category;
    }
  }
}

class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class BusinessHours {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  BusinessHours({
    this.monday = 'Closed',
    this.tuesday = 'Closed',
    this.wednesday = 'Closed',
    this.thursday = 'Closed',
    this.friday = 'Closed',
    this.saturday = 'Closed',
    this.sunday = 'Closed',
  });
}

class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final Duration duration;
  final bool isBookable;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    this.isBookable = false,
  });
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.inStock = true,
  });
}

class Business {
  final String id;
  final User owner;
  final String name;
  final String description;
  final String imageUrl;
  final BusinessCategory category;
  final List<BusinessCategory> subcategories;
  final Location? location;
  final BusinessHours? hours;
  final String phone;
  final String email;
  final String website;
  final List<Service> services;
  final List<Product> products;
  final bool isVerified;
  final bool acceptsOnlineBooking;
  final bool acceptsOnlinePayment;
  final double communityRating;
  final int reviewCount;
  final DateTime foundedDate;
  final List<String> tags;

  Business({
    required this.id,
    required this.owner,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.subcategories = const [],
    this.location,
    this.hours,
    required this.phone,
    required this.email,
    required this.website,
    this.services = const [],
    this.products = const [],
    this.isVerified = false,
    this.acceptsOnlineBooking = false,
    this.acceptsOnlinePayment = false,
    this.communityRating = 0.0,
    this.reviewCount = 0,
    required this.foundedDate,
    this.tags = const [],
  });
} 