import 'package:flutter/material.dart';
void main() => runApp(const ProfileCardApp());
class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build (BuildContext context) {
    return MaterialApp (
      title: 'Profile Card',
      theme: ThemeData (primarySwatch: Colors.blue),
      home: const ProfileScreen(),
    );
  }
}
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (title: const Text('My Profile')),
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: 300,
            padding:const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Alex Johnson',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Flutter Developer',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.email), onPressed: () {}),
                    const SizedBox(width: 12),
                    IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
                    const SizedBox(width: 12),
                    IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
