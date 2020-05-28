import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stateDemo/AuthProvider.dart';
import 'package:stateDemo/CustomerPages/CustomerHomePage.dart';
import 'package:stateDemo/CustomerPages/CustomerOnGoingVisitPage.dart';
import 'package:stateDemo/CustomerPages/CustomerVisitsPage.dart';
import 'package:stateDemo/StorePages/StoreBookingsPage.dart';
import 'package:stateDemo/StorePages/StoreHomePage.dart';
import 'package:stateDemo/classes/Pages/EntryPage.dart';
import 'package:stateDemo/classes/User.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context);
    bool yes = true;

    List<BottomNavigationBarItem> storeitems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        title: Text('Bookings'),
      ),
    ];

    List<BottomNavigationBarItem> cusitems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.business),
        title: Text('Stores'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.collections_bookmark),
        title: Text('Visits'),
      )
    ];

    List<Widget> storeWidgets = <Widget>[
       StoreHomePage(),
      StoreBookingsPage(),
    ];

    List<Widget> cusWidgets = <Widget>[
     CustomerHomePage(),
      CustomerVisitsPage(),
    ];
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser.user.name),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await auth.signOut();
                sharedPreferences = await SharedPreferences.getInstance();
                await sharedPreferences.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => EntryPage()));
              })
        ],
      ),
      body: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              // TODO: Handle this case.
              return Center(
                child: CircularProgressIndicator(),
              );

              break;
            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              // TODO: Handle this case.R
              return Center(
                child: currentUser.user.role == 'store'
                    ? storeWidgets.elementAt(_selectedIndex)
                    : cusWidgets.elementAt(_selectedIndex),
              );
              break;
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo,
        items: currentUser.user.role == 'store' ? storeitems : cusitems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
    ;
  }
}
