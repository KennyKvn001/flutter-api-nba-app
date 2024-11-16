import 'package:flutter/material.dart';
import 'package:flutter_api_app/games_page.dart';
import 'package:flutter_api_app/players_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';

void main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            children: [
              Image.asset(
                'lib/images/logonba.png',
                width: 18,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'NBA App',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Color.fromARGB(255, 60, 93, 163),
        ),
        drawer: Drawer(
          backgroundColor: Color.fromARGB(255, 60, 93, 163),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Drawer Header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Image.asset(
                  'lib/images/drawerlogo.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
              // Sidebar Items
              ListTile(
                leading: Icon(
                  Icons.sports_basketball_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Teams',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  // Navigate to profile page
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.sports_basketball_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  'Players',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  // Navigate to profile page
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayersPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.sports_basketball,
                  color: Colors.white,
                ),
                title: Text(
                  'Games',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  // Navigate to profile page
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GamesPage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: HomePage());
  }
}
