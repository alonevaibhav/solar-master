import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Component/Cleaner/profile_view.dart';
import '../../Controller/Cleaner/profile_controller.dart';
import '../../utils/exit.dart';
import 'CleanupManegment/cleanup_view.dart';
import 'CleanupManegment/cleanup_controller.dart';
import 'cleaner_bottom_nevigation.dart';

class CleanerDashboardView extends StatefulWidget {
  const CleanerDashboardView({Key? key}) : super(key: key);

  @override
  State<CleanerDashboardView> createState() => _CleanerDashboardViewState();
}

class _CleanerDashboardViewState extends State<CleanerDashboardView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CleanerHomeTab(),
    const CleanerProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Scaffold(
        body: Stack(
          children: [
            // Main content
            _pages[_currentIndex],
      
            // Floating bottom navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CleanerBottomNavigation(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example tab widgets
class CleanerHomeTab extends StatelessWidget {
  const CleanerHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CleaningManagementController controller = Get.put(CleaningManagementController());

    return Scaffold(
      body: CleaningManagementView(),
    );
  }
}

class CleanerProfileTab extends StatelessWidget {
  const CleanerProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());


    return Scaffold(
      body:ProfileView(),
    );
  }
}