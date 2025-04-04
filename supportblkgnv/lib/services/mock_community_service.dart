import 'package:supportblkgnv/models/user.dart';
import 'package:supportblkgnv/models/business.dart';
import 'package:supportblkgnv/models/event.dart';
import 'package:supportblkgnv/models/community_impact.dart';
import 'package:supportblkgnv/services/mock_data_service.dart';
import 'package:supportblkgnv/models/impact_report.dart';
import 'package:supportblkgnv/models/community_goal.dart';

class MockCommunityService {
  // Re-use existing users from MockDataService
  static final User jane = MockDataService.jane;
  static final User marcus = MockDataService.marcus;
  static final User maria = MockDataService.maria;
  
  // Create new community-focused users
  static final User drJackson = User(
    id: '6',
    name: 'Dr. Raymond Jackson',
    imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    bio: 'Professor of African American Studies and community historian',
    accountType: 'individual',
  );
  
  static final User chefAisha = User(
    id: '7',
    name: 'Chef Aisha Williams',
    imageUrl: 'https://randomuser.me/api/portraits/women/33.jpg',
    bio: 'Award-winning chef specializing in soul food with a modern twist',
    accountType: 'individual',
  );
  
  static final User councilmemberTaylor = User(
    id: '8',
    name: 'Councilmember James Taylor',
    imageUrl: 'https://randomuser.me/api/portraits/men/41.jpg',
    bio: 'City council representative and advocate for Black business development',
    accountType: 'individual',
  );
  
  // Create sample businesses
  static final Business soulFoodKitchen = Business(
    id: '1',
    owner: chefAisha,
    name: 'Soul Food Kitchen',
    description: 'Authentic soul food restaurant using fresh, local ingredients and family recipes passed down through generations.',
    imageUrl: 'https://images.unsplash.com/photo-1590846406792-0adc7f938f1d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
    category: BusinessCategory.food,
    phone: '(352) 555-1234',
    email: 'info@soulfoodkitchen.com',
    website: 'www.soulfoodkitchen.com',
    isVerified: true,
    acceptsOnlineBooking: true,
    communityRating: 4.9,
    reviewCount: 127,
    foundedDate: DateTime(2015, 5, 12),
    tags: ['Restaurant', 'Soul Food', 'Catering', 'Family-Owned'],
    location: Location(
      latitude: 29.6516,
      longitude: -82.3248,
      address: '123 Main St, Gainesville, FL 32601',
    ),
    hours: BusinessHours(
      monday: '11:00 AM - 9:00 PM',
      tuesday: '11:00 AM - 9:00 PM',
      wednesday: '11:00 AM - 9:00 PM',
      thursday: '11:00 AM - 9:00 PM',
      friday: '11:00 AM - 10:00 PM',
      saturday: '11:00 AM - 10:00 PM',
      sunday: '12:00 PM - 8:00 PM',
    ),
    services: [
      Service(
        id: '1',
        name: 'Private Dining',
        description: 'Private dining experience for groups up to 20 people',
        price: 500.00,
        duration: Duration(hours: 3),
        isBookable: true,
      ),
      Service(
        id: '2',
        name: 'Catering',
        description: 'Full-service catering for events',
        price: 25.00,
        duration: Duration(hours: 4),
        isBookable: true,
      ),
    ],
    products: [
      Product(
        id: '1',
        name: 'Signature Hot Sauce',
        description: 'Our famous house-made hot sauce',
        price: 8.99,
        imageUrl: 'https://images.unsplash.com/photo-1607119805969-d24d9265c9c9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8aG90JTIwc2F1Y2V8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        inStock: true,
      ),
      Product(
        id: '2',
        name: 'Soul Food Cookbook',
        description: 'Chef Aisha\'s cookbook with family recipes',
        price: 24.99,
        imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Y29va2Jvb2t8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        inStock: true,
      ),
    ],
  );

  static final Business blackCoffeeShop = Business(
    id: '2',
    owner: MockDataService.blackCoffeeShop.isBusiness ? MockDataService.jane : MockDataService.blackCoffeeShop,
    name: 'Black Coffee Shop',
    description: 'Cozy coffee shop serving specialty coffee drinks and pastries made from locally sourced ingredients.',
    imageUrl: 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Y29mZmVlJTIwc2hvcHxlbnwwfHwwfHw%3D&w=1000&q=80',
    category: BusinessCategory.food,
    subcategories: [BusinessCategory.retail],
    phone: '(352) 555-5678',
    email: 'hello@blackcoffeeshop.com',
    website: 'www.blackcoffeeshop.com',
    isVerified: true,
    acceptsOnlinePayment: true,
    communityRating: 4.7,
    reviewCount: 89,
    foundedDate: DateTime(2018, 3, 15),
    tags: ['Coffee', 'Pastries', 'WiFi', 'Study Spot'],
    location: Location(
      latitude: 29.6422,
      longitude: -82.3289,
      address: '456 University Ave, Gainesville, FL 32601',
    ),
    hours: BusinessHours(
      monday: '7:00 AM - 7:00 PM',
      tuesday: '7:00 AM - 7:00 PM',
      wednesday: '7:00 AM - 7:00 PM',
      thursday: '7:00 AM - 7:00 PM',
      friday: '7:00 AM - 9:00 PM',
      saturday: '8:00 AM - 9:00 PM',
      sunday: '8:00 AM - 6:00 PM',
    ),
  );
  
  static final Business techHubBLK = Business(
    id: '3',
    owner: MockDataService.techHubBLK.isBusiness ? MockDataService.marcus : MockDataService.techHubBLK,
    name: 'TechHub BLK',
    description: 'Co-working space and tech incubator focused on supporting Black entrepreneurs in technology.',
    imageUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    category: BusinessCategory.tech,
    subcategories: [BusinessCategory.education, BusinessCategory.services],
    phone: '(352) 555-9012',
    email: 'info@techhubblk.com',
    website: 'www.techhubblk.com',
    isVerified: true,
    communityRating: 4.8,
    reviewCount: 56,
    foundedDate: DateTime(2019, 8, 1),
    tags: ['Co-Working', 'Tech Incubator', 'Mentorship', 'Workshops'],
    location: Location(
      latitude: 29.6520,
      longitude: -82.3250,
      address: '789 Innovation Square, Gainesville, FL 32601',
    ),
    services: [
      Service(
        id: '3',
        name: 'Hot Desk Membership',
        description: 'Monthly hot desk access to our co-working space',
        price: 150.00,
        duration: Duration(days: 30),
        isBookable: true,
      ),
      Service(
        id: '4',
        name: 'Private Office',
        description: 'Private office for teams up to 4 people',
        price: 500.00,
        duration: Duration(days: 30),
        isBookable: true,
      ),
      Service(
        id: '5',
        name: 'Tech Mentorship',
        description: '1-on-1 mentorship with tech industry experts',
        price: 75.00,
        duration: Duration(hours: 1),
        isBookable: true,
      ),
    ],
  );
  
  static final Business heritageBooksAndArt = Business(
    id: '4',
    owner: drJackson,
    name: 'Heritage Books & Art',
    description: 'Independent bookstore and art gallery specializing in African American literature and art.',
    imageUrl: 'https://images.unsplash.com/photo-1521029943866-8d58c68a50fa?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8Ym9va3N0b3JlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    category: BusinessCategory.retail,
    subcategories: [BusinessCategory.arts, BusinessCategory.education],
    phone: '(352) 555-3456',
    email: 'books@heritagebooksart.com',
    website: 'www.heritagebooksart.com',
    isVerified: true,
    acceptsOnlinePayment: true,
    communityRating: 4.9,
    reviewCount: 72,
    foundedDate: DateTime(2010, 2, 15),
    tags: ['Books', 'Art Gallery', 'Events', 'Educational'],
    location: Location(
      latitude: 29.6518,
      longitude: -82.3260,
      address: '234 Culture Street, Gainesville, FL 32601',
    ),
    hours: BusinessHours(
      monday: 'Closed',
      tuesday: '10:00 AM - 6:00 PM',
      wednesday: '10:00 AM - 6:00 PM',
      thursday: '10:00 AM - 6:00 PM',
      friday: '10:00 AM - 7:00 PM',
      saturday: '10:00 AM - 7:00 PM',
      sunday: '12:00 PM - 5:00 PM',
    ),
    services: [
      Service(
        id: '6',
        name: 'Book Club Hosting',
        description: 'Host your book club at our store with refreshments',
        price: 50.00,
        duration: Duration(hours: 2),
        isBookable: true,
      ),
      Service(
        id: '7',
        name: 'Art Exhibition',
        description: 'Two-week exhibition of your artwork in our gallery space',
        price: 300.00,
        duration: Duration(days: 14),
        isBookable: true,
      ),
    ],
  );
  
  static final Business naturalHairStudio = Business(
    id: '5',
    owner: maria,
    name: 'Natural Hair Studio',
    description: 'Hair salon specializing in natural hairstyles, locs, and protective styling with organic products.',
    imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8aGFpciUyMHNhbG9ufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
    category: BusinessCategory.beauty,
    phone: '(352) 555-7890',
    email: 'appointments@naturalhairstudio.com',
    website: 'www.naturalhairstudio.com',
    isVerified: true,
    acceptsOnlineBooking: true,
    acceptsOnlinePayment: true,
    communityRating: 4.8,
    reviewCount: 106,
    foundedDate: DateTime(2016, 6, 10),
    tags: ['Hair Salon', 'Natural Hair', 'Organic Products', 'Loc Maintenance'],
    location: Location(
      latitude: 29.6480,
      longitude: -82.3240,
      address: '567 Beauty Blvd, Gainesville, FL 32601',
    ),
    hours: BusinessHours(
      monday: 'Closed',
      tuesday: '9:00 AM - 7:00 PM',
      wednesday: '9:00 AM - 7:00 PM',
      thursday: '9:00 AM - 7:00 PM',
      friday: '9:00 AM - 8:00 PM',
      saturday: '8:00 AM - 8:00 PM',
      sunday: 'Closed',
    ),
    services: [
      Service(
        id: '8',
        name: 'Natural Hair Consultation',
        description: 'Personalized consultation for your natural hair journey',
        price: 45.00,
        duration: Duration(minutes: 45),
        isBookable: true,
      ),
      Service(
        id: '9',
        name: 'Loc Maintenance',
        description: 'Retwisting and maintenance for locs',
        price: 85.00,
        duration: Duration(hours: 2),
        isBookable: true,
      ),
      Service(
        id: '10',
        name: 'Protective Styling',
        description: 'Box braids, twists, or other protective styles',
        price: 120.00,
        duration: Duration(hours: 3),
        isBookable: true,
      ),
    ],
    products: [
      Product(
        id: '3',
        name: 'Organic Hair Oil',
        description: 'House-made organic hair oil blend',
        price: 22.99,
        imageUrl: 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8aGFpciUyMG9pbHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        inStock: true,
      ),
    ],
  );

  List<User> getUsers() {
    return [drJackson, chefAisha, councilmemberTaylor];
  }

  List<Event> getEvents() {
    return [
      Event(
        id: '1',
        title: 'Juneteenth Heritage Festival',
        description: 'Annual Juneteenth celebration featuring live music, food vendors, art exhibits, and educational workshops celebrating Black culture and history.',
        startTime: DateTime.now().add(Duration(days: 15)),
        endTime: DateTime.now().add(Duration(days: 15, hours: 8)),
        location: Location(
          latitude: 29.6516,
          longitude: -82.3248,
          address: 'Depot Park, 200 SE Depot Ave, Gainesville, FL 32601',
        ),
        imageUrl: 'https://images.unsplash.com/photo-1563895904505-076dbf864f9f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NXx8ZmVzdGl2YWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        category: EventCategory.cultural,
        organizer: councilmemberTaylor,
        isFree: true,
        capacity: 500,
        attendees: [jane, marcus, maria, drJackson, chefAisha],
        providesChildcare: true,
        tags: ['Juneteenth', 'Cultural Festival', 'Community Event', 'Family-Friendly'],
      ),
      Event(
        id: '2',
        title: 'Black Business Networking Mixer',
        description: 'Monthly networking event for Black entrepreneurs, business owners, and professionals to connect and build relationships.',
        startTime: DateTime.now().add(Duration(days: 7, hours: 18)),
        endTime: DateTime.now().add(Duration(days: 7, hours: 21)),
        location: Location(
          latitude: 29.6520,
          longitude: -82.3250,
          address: 'TechHub BLK, 789 Innovation Square, Gainesville, FL 32601',
        ),
        imageUrl: 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8bmV0d29ya2luZ3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        category: EventCategory.networking,
        organizer: marcus,
        hostingBusiness: techHubBLK,
        ticketPrice: 10.00,
        isFree: false,
        capacity: 50,
        attendees: [chefAisha, councilmemberTaylor, drJackson],
        interestedUsers: [jane, maria],
        tags: ['Networking', 'Business', 'Professional Development'],
      ),
      Event(
        id: '3',
        title: 'Soul Food Cooking Workshop',
        description: 'Learn to cook authentic soul food dishes with Chef Aisha Williams. Ingredients and recipe booklet included.',
        startTime: DateTime.now().add(Duration(days: 3, hours: 14)),
        endTime: DateTime.now().add(Duration(days: 3, hours: 17)),
        location: Location(
          latitude: 29.6516,
          longitude: -82.3248,
          address: 'Soul Food Kitchen, 123 Main St, Gainesville, FL 32601',
        ),
        imageUrl: 'https://images.unsplash.com/photo-1556910096-5cdaf34fde99?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y29va2luZyUyMGNsYXNzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
        category: EventCategory.workshop,
        organizer: chefAisha,
        hostingBusiness: soulFoodKitchen,
        ticketPrice: 65.00,
        isFree: false,
        capacity: 15,
        attendees: [maria, jane],
        interestedUsers: [marcus],
        tags: ['Cooking', 'Soul Food', 'Workshop', 'Culinary'],
      ),
      Event(
        id: '4',
        title: 'Black History Walking Tour',
        description: 'Educational walking tour of historic Black landmarks and neighborhoods in Gainesville led by Dr. Raymond Jackson.',
        startTime: DateTime.now().add(Duration(days: 10, hours: 10)),
        endTime: DateTime.now().add(Duration(days: 10, hours: 12)),
        location: Location(
          latitude: 29.6518,
          longitude: -82.3260,
          address: 'Heritage Books & Art, 234 Culture Street, Gainesville, FL 32601',
        ),
        imageUrl: 'https://images.unsplash.com/photo-1519331379826-f10be5486c6f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8d2Fsa2luZyUyMHRvdXJ8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
        category: EventCategory.educational,
        organizer: drJackson,
        hostingBusiness: heritageBooksAndArt,
        ticketPrice: 15.00,
        isFree: false,
        capacity: 20,
        attendees: [councilmemberTaylor],
        interestedUsers: [jane, marcus, maria, chefAisha],
        tags: ['History', 'Educational', 'Walking Tour', 'Black Heritage'],
      ),
      Event(
        id: '5',
        title: 'Community Clean-up Day',
        description: 'Volunteer event to clean up and beautify historic Black neighborhoods. Supplies and lunch provided.',
        startTime: DateTime.now().add(Duration(days: 14, hours: 9)),
        endTime: DateTime.now().add(Duration(days: 14, hours: 13)),
        location: Location(
          latitude: 29.6480,
          longitude: -82.3240,
          address: 'Pleasant Street Historic District, Gainesville, FL 32601',
        ),
        imageUrl: 'https://images.unsplash.com/photo-1618477461853-cf5ed140d912?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Y29tbXVuaXR5JTIwY2xlYW51cHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60',
        category: EventCategory.community,
        organizer: maria,
        isFree: true,
        attendees: [jane, marcus, drJackson, councilmemberTaylor],
        needsRideShare: true,
        providesChildcare: true,
        tags: ['Volunteer', 'Community Service', 'Neighborhood', 'Environment'],
      ),
    ];
  }

  List<Business> getBusinesses() {
    return [
      soulFoodKitchen,
      blackCoffeeShop,
      techHubBLK,
      heritageBooksAndArt,
      naturalHairStudio,
    ];
  }

  List<CommunityGoal> getCommunityGoals() {
    return [
      CommunityGoal(
        id: '1',
        title: 'Black Business Incubator Fund',
        description: 'Raising funds to create a business incubator space dedicated to supporting Black entrepreneurs in Gainesville.',
        targetAmount: 100000.0,
        currentAmount: 78500.0,
        startDate: DateTime(2023, 1, 1),
        endDate: DateTime(2023, 12, 31),
        participants: ['Jane Smith', 'Marcus Johnson', 'Dr. Raymond Jackson', 'Chef Aisha Williams', 'Councilmember James Taylor', 'Maria Rodriguez'],
      ),
      CommunityGoal(
        id: '2',
        title: 'Youth Tech Education Program',
        description: 'Funding to provide coding and tech education for Black youth in underserved neighborhoods throughout Gainesville.',
        targetAmount: 50000.0,
        currentAmount: 32750.0,
        startDate: DateTime(2023, 3, 1),
        endDate: DateTime(2023, 8, 31),
        participants: ['TechHub BLK', 'Marcus Johnson', 'Jane Smith', 'Maria Rodriguez'],
      ),
      CommunityGoal(
        id: '3',
        title: 'Community Garden Project',
        description: 'Creating a community garden to provide fresh produce and agricultural education to East Gainesville residents.',
        targetAmount: 25000.0,
        currentAmount: 18900.0,
        startDate: DateTime(2023, 2, 15),
        endDate: DateTime(2023, 7, 15),
        participants: ['Soul Food Kitchen', 'Chef Aisha Williams', 'Jane Smith', 'Maria Rodriguez'],
      ),
      CommunityGoal(
        id: '4',
        title: 'Black History Arts Festival',
        description: 'Organizing a weekend arts festival celebrating Black culture, history, and artistic achievement in Gainesville.',
        targetAmount: 35000.0,
        currentAmount: 12250.0,
        startDate: DateTime(2023, 4, 1),
        endDate: DateTime(2024, 1, 31),
        participants: ['Heritage Books & Art', 'Dr. Raymond Jackson', 'Jane Smith', 'Marcus Johnson'],
      ),
    ];
  }

  List<ImpactReport> getImpactReports() {
    return [
      ImpactReport(
        id: '1',
        title: 'Q2 2023 Community Impact',
        reportDate: DateTime(2023, 6, 30),
        totalSpending: 450000,
        totalTransactions: 3200,
        spendingByCategory: {
          'Food & Dining': 125000,
          'Retail': 95000,
          'Professional Services': 75000,
          'Beauty & Wellness': 65000,
          'Education': 50000,
          'Entertainment': 40000,
        },
        monthlySpending: [35000, 42000, 38000, 45000, 52000, 58000, 63000, 68000, 72000, 75000, 78000, 85000],
        topBusinesses: [
          'Soul Food Kitchen',
          'TechHub BLK',
          'Gainesville Black Heritage Gallery',
          'Natural Beauty Salon',
          'Melanin Fitness Center',
        ],
      ),
    ];
  }
  
  // Helper method to generate monthly trend data
  List<ChartDataPoint> _generateMonthlyTrendData(int months) {
    final now = DateTime.now();
    final List<ChartDataPoint> data = [];
    
    for (int i = months - 1; i >= 0; i--) {
      final month = now.month - i;
      final year = now.year;
      final adjustedYear = month <= 0 ? year - 1 : year;
      final adjustedMonth = month <= 0 ? month + 12 : month;
      
      // Base value with some random variation
      final baseValue = 30000.0 + (months - i) * 2500.0;
      final randomFactor = 0.8 + (DateTime.now().millisecondsSinceEpoch % 5) / 10;
      
      data.add(ChartDataPoint(
        date: DateTime(adjustedYear, adjustedMonth, 1),
        value: baseValue * randomFactor,
      ));
    }
    
    return data;
  }
  
  // Helper method to get month name
  String _getMonthName(int month) {
    final adjustedMonth = month <= 0 ? month + 12 : (month > 12 ? month - 12 : month);
    
    switch (adjustedMonth) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }
} 