import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/features/auth/presntaoin/pages/profile_view.dart';
import 'package:untitled/features/finishing_companies/presentoin/pages/finishing_companies_page.dart';
import 'package:untitled/features/home/presentation/pages/home_page.dart';
import 'package:untitled/features/real_states/presentoin/pages/real_states_page.dart';
import 'package:untitled/features/requests/presentation/pages/my_requests_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(onOpenTab: _onItemTapped),
      const RealStatesPage(),
      const FinishingCompaniesPage(),
      const MyRequestsPage(),
      const ProfileView(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        height: 72,
        elevation: 10,
        shadowColor: Colors.black26,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.apartment_outlined),
            selectedIcon: Icon(Icons.apartment),
            label: 'العقارات',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'الشركات',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'طلباتي',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
