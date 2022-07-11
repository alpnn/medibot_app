import 'package:flutter/material.dart';
import 'patient_page.dart';
import 'account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const HomePage());
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<BottomNavigationBarItem> _bottomBarList = [
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: 'Medibot',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Me')
  ];
  static const List<Widget> _widgetOptions = [PatientPage(), AccountPage()];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_bottomBarList[_currentIndex].label ?? 'unknown'),
        centerTitle: true,
        actions: const [Icon(Icons.notifications_none)],
        flexibleSpace: Container(),
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: _bottomBarList),
    );
  }
}
