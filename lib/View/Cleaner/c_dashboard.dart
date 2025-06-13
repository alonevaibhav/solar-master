import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Cleaner/cleanup_schedule_controller.dart';
import 'package:solar_app/View/Cleaner/todays_task/cleanup_schedule_view.dart';
import '../../Component/Cleaner/profile_view.dart';
import '../../Component/Cleaner/today_inspections_view.dart';
import '../../Controller/Cleaner/profile_controller.dart';
import '../../Controller/Cleaner/today_inspections_controller.dart';
import '../../utils/exit.dart';
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

    // final TodayInspectionsController controller = Get.put(TodayInspectionsController());
    final CleanupScheduleController controller = Get.put(CleanupScheduleController());

    return Scaffold(
      // body: TodayInspectionsView(),
      body: CleanupScheduleView(),
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