
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/View/Inspector/plant_inspection_view.dart';
import 'package:solar_app/View/Inspector/user_profile.dart';
import '../../Component/Inspector/TicketPage/ticket_view.dart';
import '../../Controller/Inspector/area_inspection_controller.dart';
import '../../Controller/Inspector/plant_inspection_controller.dart';
import '../../Controller/Inspector/ticket_controller.dart';
import '../../Controller/Inspector/user_profile_controller.dart';
import '../../utils/exit.dart';
import 'SheduleModule/shedule_view.dart';
import 'area_inspection_view.dart';
import 'bottom_nevigation.dart';

class InDashboard extends StatefulWidget {
  const InDashboard({Key? key}) : super(key: key);

  @override
  State<InDashboard> createState() => _InDashboardState();
}

class _InDashboardState extends State<InDashboard> {
  int _currentIndex = 2; // Start at Home (index 2)

  final List<Widget> _pages = [
    const InspectorReportsTab(),
    const InspectorTasksTab(),
    const InspectorHomeTab(),
    const InspectorAlertsTab(),
    const InspectorProfileTab(),
  ];


  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: Scaffold(
        // Remove Stack and Positioned - just use body directly
        body: _pages[_currentIndex],

        // Move bottom navigation to bottomNavigationBar property
        bottomNavigationBar: InspectorBottomNavigation(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

// Example tab widgets
class InspectorReportsTab extends StatelessWidget {
  const InspectorReportsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AreaInspectionController controller =
    Get.put(AreaInspectionController());

    return Scaffold(
      body: AreaInspectionView(),
    );
  }
}

class InspectorTasksTab extends StatelessWidget {
  const InspectorTasksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TicketController controller = Get.put(TicketController());
    // final TicketRaisingController controller = Get.put(TicketRaisingController());

    return Scaffold(
      body: TicketView(),
      // body: TicketRaisingView(),
    );
  }
}

class InspectorHomeTab extends StatelessWidget {
  const InspectorHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlantInspectionController controller = Get.put(PlantInspectionController());
    // final ShimmerController controller = Get.put(ShimmerController());
    return Scaffold(
      body: PlantInspectionView(),
      // body: ShimmerPatternsExample(),
    );
  }
}

class InspectorAlertsTab extends StatelessWidget {
  const InspectorAlertsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final AlertsController controller = Get.put(AlertsController());

    return Scaffold(
        body:

        // AlertsView()
        ScheduleContentView());
  }
}

class InspectorProfileTab extends StatelessWidget {
  const InspectorProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IUserProfile controller = Get.put(IUserProfile());

    return Scaffold(
      body: UserProfile(),
    );
  }
}
