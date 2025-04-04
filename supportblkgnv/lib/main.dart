import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'environment.dart';
import 'theme.dart';
import 'screens/profile.dart';
import 'screens/home.dart';
import 'screens/community_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/create_post_screen.dart';
import 'providers/auth_provider.dart';
import 'services/auth_service.dart';
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
    // Continue without Firebase for development
    // This allows the app to run even if Firebase initialization fails
    // Useful for development without Firebase credentials
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthService()),
        ),
        // Add other providers here as needed
      ],
      child: MaterialApp(
        title: 'SupportBLKGNV',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/community': (context) => const CommunityScreen(),
          '/profile': (context) => const ProfilePage(),
        },
        debugShowCheckedModeBanner: false, // Removes the debug banner
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeScreen(showFloatingActionButton: false),
    const CommunityScreen(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Check current user when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).checkCurrentUser();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 ? 
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePostScreen()),
            ).then((result) {
              if (result == true) {
                // Refresh the home screen by rebuilding it
                setState(() {
                  _screens[0] = const HomeScreen(showFloatingActionButton: false);
                });
              }
            });
          },
          backgroundColor: AppColors.brandTeal,
          child: const Icon(Icons.add),
        ) : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.cardBackground,
        selectedItemColor: AppColors.brandTeal,
        unselectedItemColor: AppColors.textWhite.withOpacity(0.6),
      ),
    );
  }
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Nico work', style: TextStyle(fontSize: 24)),
          Text(
            'temporarily on nav bar for development',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
