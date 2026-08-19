import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const _HomePage(),
    const _FinishingPage(),
    const _RealStatePage(),
    const _MyRequestsPage(),
  ];

  static final List<String> _titles = <String>[
    'Home',
    'Finishing',
    'Real State',
    'My Requests',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex]), centerTitle: true),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor().secondaryColor,
        unselectedItemColor: AppColor().primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'companies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Real State',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Requests',
          ),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Home Page',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FinishingPage extends StatelessWidget {
  const _FinishingPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Finishing Page',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RealStatePage extends StatelessWidget {
  const _RealStatePage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Real State Page',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MyRequestsPage extends StatelessWidget {
  const _MyRequestsPage();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'My Requests Page',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
