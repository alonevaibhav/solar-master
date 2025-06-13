import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/View/Inspector/SheduleModule/shedule_card.dart';
import 'package:solar_app/Controller/Inspector/shedule_controller.dart';
import 'package:solar_app/API%20Service/Model/Request/shedule_model.dart';

class ScheduleContentView extends StatefulWidget {
  const ScheduleContentView({Key? key}) : super(key: key);

  @override
  State<ScheduleContentView> createState() => _ScheduleContentViewState();
}

class _ScheduleContentViewState extends State<ScheduleContentView> {
  final ScheduleController scheduleController = Get.put(ScheduleController());
  String selectedWeekFilter = 'All'; // Default filter

  @override
  void initState() {
    super.initState();
    // Fetch schedules when view loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scheduleController.fetchInspectorSchedules();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (scheduleController.isLoading) {
            return _buildLoadingState();
          }

          if (scheduleController.errorMessage != null) {
            return _buildErrorState(scheduleController.errorMessage!);
          }

          if (scheduleController.allSchedules.isEmpty) {
            return _buildEmptyState();
          }

          return _buildWeekFilterContent();
        }),
      ),
    );
  }


  Widget _buildWeekFilterContent() {
    int allInspectionsCount = scheduleController.allSchedules.length;
    int week1InspectionsCount = scheduleController.allSchedules.where((schedule) => schedule.week.toString() == '1').length;
    int week2InspectionsCount = scheduleController.allSchedules.where((schedule) => schedule.week.toString() == '2').length;

    return Column(
      children: [
        // Week filter buttons with inspection counts
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterButton('All', allInspectionsCount),
              _buildFilterButton('Week 1', week1InspectionsCount),
              _buildFilterButton('Week 2', week2InspectionsCount),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Schedule content
        Expanded(
          child: _buildScheduleContent(),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String week, int count) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedWeekFilter = week;
        });
      },
      style: TextButton.styleFrom(
        backgroundColor: selectedWeekFilter == week ? Colors.blue[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            week,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: selectedWeekFilter == week ? Colors.blue[600] : Colors.grey[600],
            ),
          ),
          Text(
            '($count)', // Display the count of inspections
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: selectedWeekFilter == week ? Colors.blue[600] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Container(
        height: 200.h,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
              ),
              SizedBox(height: 16.h),
              Text(
                'Loading schedules...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => scheduleController.refreshSchedules(),
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'No Schedules Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You don\'t have any scheduled inspections at the moment.',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => scheduleController.refreshSchedules(),
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleContent() {
    List<Schedule> filteredSchedules = scheduleController.allSchedules;

    if (selectedWeekFilter == 'Week 1') {
      filteredSchedules = scheduleController.allSchedules.where((schedule) => schedule.week.toString() == '1').toList();
    } else if (selectedWeekFilter == 'Week 2') {
      filteredSchedules = scheduleController.allSchedules.where((schedule) => schedule.week.toString() == '2').toList();
    }

    if (filteredSchedules.isEmpty) {
      return Center(
        child: Text('No schedules found for the selected week.'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: filteredSchedules.length,
      itemBuilder: (context, index) {
        final schedule = filteredSchedules[index];
        return ScheduleCardWidget(
          schedule: schedule,
          onTap: () {
            print('Tapped on schedule: ${schedule.id}');
          },
        );
      },
    );
  }
}
