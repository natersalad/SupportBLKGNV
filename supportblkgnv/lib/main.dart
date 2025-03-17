import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'environment.dart';

Future main() async {
  await dotenv.load(fileName: Environment.fileName);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<void> _addTestData() async {
    await FirebaseFirestore.instance.collection('test').doc('demo').set({
      'title': 'Hello World',
      'body': 'This is a demo',
    });
    debugPrint("Data Added!");
  }

  Future<void> _readTestData() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('test').doc('demo').get();

    final data = doc.data();
    if (data != null) {
      debugPrint("Data: $data");
    } else {
      debugPrint("No Data Found!");
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Firebase Enviroment Key: ${Environment.firebaseAppIdAndroid}',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _addTestData,
              child: const Text('Add Data'),
            ),
            ElevatedButton(
              onPressed: _readTestData,
              child: const Text('Read Data'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
