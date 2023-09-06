import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_pad/firstpage.dart';

class settings extends StatefulWidget {
  const settings({Key? key}) : super(key: key);

  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {

  int _selectedIndex = 2;
  void _onItemTapped(index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.cyan[900],
        title: Text('Settings', style: TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan[900],
              ),
              child: Text('Side bar', style: TextStyle(color: Colors.white),),
            ),
            ListTile(
              title: const Text('Notes'),
              selected: _selectedIndex == 0,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => first_page()));
              },
            ),
            ListTile(
              title: const Text('Backup'),
              selected: _selectedIndex == 1,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Settings'),
              selected: _selectedIndex == 2,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Account'),
              selected: _selectedIndex == 3,
              selectedTileColor: Colors.yellow[100],
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
