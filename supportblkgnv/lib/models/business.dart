import 'package:flutter/material.dart';
import 'package:supportblkgnv/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum BusinessCategory {
  restaurant,
  retail,
  service,
  healthcare,
  education,
  entertainment,
  other,
}

extension BusinessCategoryExtension on BusinessCategory {
  String get displayName {
    switch (this) {
      case BusinessCategory.restaurant:
        return 'Food & Dining';
      case BusinessCategory.retail:
        return 'Retail & Shopping';
      case BusinessCategory.service:
        return 'Professional Services';
      case BusinessCategory.healthcare:
        return 'Health & Wellness';
      case BusinessCategory.education:
        return 'Education & Training';
      case BusinessCategory.entertainment:
        return 'Arts & Entertainment';
      case BusinessCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case BusinessCategory.restaurant:
        return Icons.restaurant;
      case BusinessCategory.retail:
        return Icons.shopping_bag;
      case BusinessCategory.service:
        return Icons.business_center;
      case BusinessCategory.healthcare:
        return Icons.healing;
      case BusinessCategory.education:
        return Icons.school;
      case BusinessCategory.entertainment:
        return Icons.movie;
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
  
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
  
  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
    );
  }
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
  
  Map<String, dynamic> toMap() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
  
  factory BusinessHours.fromMap(Map<String, dynamic> map) {
    return BusinessHours(
      monday: map['monday'] ?? 'Closed',
      tuesday: map['tuesday'] ?? 'Closed',
      wednesday: map['wednesday'] ?? 'Closed',
      thursday: map['thursday'] ?? 'Closed',
      friday: map['friday'] ?? 'Closed',
      saturday: map['saturday'] ?? 'Closed',
      sunday: map['sunday'] ?? 'Closed',
    );
  }
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
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationSeconds': duration.inSeconds,
      'isBookable': isBookable,
    };
  }
  
  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      duration: Duration(seconds: (map['durationSeconds'] as int?) ?? 0),
      isBookable: map['isBookable'] ?? false,
    );
  }
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
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'inStock': inStock,
    };
  }
  
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'],
      inStock: map['inStock'] ?? true,
    );
  }
}

class Business {
  final String id;
  final String ownerId;
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
    required this.ownerId,
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

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category.toString().split('.').last,
      'subcategories': subcategories.map((sc) => sc.toString().split('.').last).toList(),
      'location': location?.toMap(),
      'hours': hours?.toMap(),
      'phone': phone,
      'email': email,
      'website': website,
      'services': services.map((s) => s.toMap()).toList(),
      'products': products.map((p) => p.toMap()).toList(),
      'isVerified': isVerified,
      'acceptsOnlineBooking': acceptsOnlineBooking,
      'acceptsOnlinePayment': acceptsOnlinePayment,
      'communityRating': communityRating,
      'reviewCount': reviewCount,
      'foundedDate': Timestamp.fromDate(foundedDate),
      'tags': tags,
    };
  }
  
  // Create Business from Firestore document
  factory Business.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    
    // Parse location if available
    Location? location;
    if (data['location'] != null) {
      location = Location.fromMap(data['location'] as Map<String, dynamic>);
    }
    
    // Parse hours if available
    BusinessHours? hours;
    if (data['hours'] != null) {
      hours = BusinessHours.fromMap(data['hours'] as Map<String, dynamic>);
    }
    
    // Parse services
    List<Service> services = [];
    if (data['services'] != null) {
      for (var serviceData in data['services']) {
        services.add(Service.fromMap(serviceData as Map<String, dynamic>));
      }
    }
    
    // Parse products
    List<Product> products = [];
    if (data['products'] != null) {
      for (var productData in data['products']) {
        products.add(Product.fromMap(productData as Map<String, dynamic>));
      }
    }
    
    // Parse founded date
    DateTime foundedDate;
    if (data['foundedDate'] is Timestamp) {
      foundedDate = (data['foundedDate'] as Timestamp).toDate();
    } else if (data['foundedDate'] is String) {
      foundedDate = DateTime.parse(data['foundedDate']);
    } else {
      foundedDate = DateTime.now();
    }
    
    // Parse category
    BusinessCategory category = _parseCategoryString(data['category']);
    
    // Parse subcategories
    List<BusinessCategory> subcategories = [];
    if (data['subcategories'] != null) {
      for (var cat in data['subcategories']) {
        subcategories.add(_parseCategoryString(cat));
      }
    }
    
    return Business(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? 'Unknown Business',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: category,
      subcategories: subcategories,
      location: location,
      hours: hours,
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      website: data['website'] ?? '',
      services: services,
      products: products,
      isVerified: data['isVerified'] ?? false,
      acceptsOnlineBooking: data['acceptsOnlineBooking'] ?? false,
      acceptsOnlinePayment: data['acceptsOnlinePayment'] ?? false,
      communityRating: (data['communityRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      foundedDate: foundedDate,
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
    );
  }
  
  // Helper method to parse category from string
  static BusinessCategory _parseCategoryString(String? categoryStr) {
    if (categoryStr == null) return BusinessCategory.other;
    
    switch (categoryStr.toLowerCase()) {
      case 'restaurant':
        return BusinessCategory.restaurant;
      case 'retail':
        return BusinessCategory.retail;
      case 'service':
        return BusinessCategory.service;
      case 'healthcare':
        return BusinessCategory.healthcare;
      case 'education':
        return BusinessCategory.education;
      case 'entertainment':
        return BusinessCategory.entertainment;
      default:
        return BusinessCategory.other;
    }
  }
}
