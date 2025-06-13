import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:solar_app/Controller/Inspector/plant_managment_controller.dart';

import '../../utils/dialog_box.dart';

class AutoCleanSchedule extends StatelessWidget {
  final Map<String, dynamic> plant;
  final PlantManagementController controller;

  const AutoCleanSchedule(
      {super.key, required this.plant, required this.controller});

  @override
  Widget build(BuildContext context) {
    return _buildSchedulesSection(plant);
  }

  Widget _buildSchedulesSection(Map<String, dynamic> plant) {
    final schedules = plant['schedules'] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.symmetric(vertical: (16 * 0.8).h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((12 * 0.8).r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, (1 * 0.8).h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and add button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: (16 * 0.8).w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.schedule,
                        size: (24 * 0.8).sp,
                        color: Colors.black.withOpacity(0.7)),
                    SizedBox(width: (8 * 0.8).w),
                    Text(
                      'Auto Clean Schedules',
                      style: TextStyle(
                        fontSize: (18 * 0.8).sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Plus button styled like in Figma
                InkWell(
                  onTap: () => _showAddScheduleDialog(plant['id']),
                  child: Container(
                    width: (40 * 0.8).w,
                    height: (40 * 0.8).h,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.black87,
                      size: (22 * 0.8).sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: (16 * 0.8).h),

          // Schedule list
          if (schedules.isEmpty)
            Padding(
              padding: EdgeInsets.all((16 * 0.8).w),
              child: Text('No schedules added yet'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index] as Map<String, dynamic>;
                return _buildUpdatedScheduleItem(schedule, plant['id']);
              },
            ),
        ],
      ),
    );
  }

  // Updated schedule item with consistent design
  Widget _buildUpdatedScheduleItem(
      Map<String, dynamic> schedule, String plantId) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: (16 * 0.8).w, vertical: (8 * 0.8).h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((12 * 0.8).r),
      ),
      child: Row(
        children: [
          // Delete button (always visible in red container)
          GestureDetector(
            onTap: () => _showDeleteConfirmationDialog(plantId, schedule['id']),
            child: Container(
              width: (60 * 0.8).w,
              height: (80 * 0.8).h,
              decoration: BoxDecoration(
                color: const Color(0xFFF98B8B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular((12 * 0.8).r),
                  bottomLeft: Radius.circular((12 * 0.8).r),
                ),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: (28 * 0.8).sp,
              ),
            ),
          ),

          // Schedule details (in green container)
          Expanded(
            child: Container(
              height: (80 * 0.8).h,
              padding: EdgeInsets.symmetric(
                  horizontal: (20 * 0.8).w, vertical: (16 * 0.8).h),
              decoration: BoxDecoration(
                color: const Color(0xFFB4ECC4), // Light green for all items
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular((12 * 0.8).r),
                  bottomRight: Radius.circular((12 * 0.8).r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all((8 * 0.8).w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.access_time, size: (24 * 0.8).sp),
                      ),
                      SizedBox(width: (12 * 0.8).w),
                      Text(
                        '${schedule['day']}, ${schedule['time']}${schedule['amPm'].toLowerCase()}',
                        style: TextStyle(
                          fontSize: (16 * 0.8).sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Edit button (pencil icon)
                  GestureDetector(
                    onTap: () => _showEditScheduleDialog(
                      plantId,
                      schedule['id'],
                      schedule['day'],
                      schedule['time'],
                      schedule['amPm'],
                    ),
                    child: Container(
                      padding: EdgeInsets.all((8 * 0.8).w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular((8 * 0.8).r),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black54,
                        size: (22 * 0.8).sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog(String plantId) {
    // Predefined options for better UX
    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((16 * 0.8).r)),
        child: Container(
          padding: EdgeInsets.all((20 * 0.8).w),
          width: (350 * 0.8).w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Cleaning Schedule',
                    style: TextStyle(
                      fontSize: (18 * 0.8).sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: (24 * 0.8).sp),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),

              SizedBox(height: (20 * 0.8).h),

              // Day selection
              Text(
                'Select Day',
                style: TextStyle(
                  fontSize: (16 * 0.8).sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: (10 * 0.8).h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular((8 * 0.8).r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Obx(() => DropdownButton<String>(
                      value: controller.selectedDay.value,
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down, size: (24 * 0.8).sp),
                      items: days.map((String day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSelectedDay(value);
                        }
                      },
                    )),
              ),

              SizedBox(height: (20 * 0.8).h),

              // Time selection
              Text(
                'Select Time',
                style: TextStyle(
                  fontSize: (16 * 0.8).sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: (10 * 0.8).h),

              Obx(() => Row(
                    children: [
                      // Hour picker
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular((8 * 0.8).r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<int>(
                            value: controller.hour.value,
                            isExpanded: true,
                            underline: Container(),
                            items: List.generate(12, (index) => index + 1)
                                .map((int h) {
                              return DropdownMenuItem<int>(
                                value: h,
                                child: Text(h.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.setHour(value);
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: (10 * 0.8).w),
                      Text(':', style: TextStyle(fontSize: (16 * 0.8).sp)),
                      SizedBox(width: (10 * 0.8).w),

                      // Minute picker
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular((8 * 0.8).r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<int>(
                            value: controller.minute.value,
                            isExpanded: true,
                            underline: Container(),
                            items: [0, 15, 30, 45].map((int m) {
                              return DropdownMenuItem<int>(
                                value: m,
                                child: Text(m.toString().padLeft(2, '0')),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.setMinute(value);
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: (10 * 0.8).w),

                      // AM/PM picker
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular((8 * 0.8).r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButton<String>(
                          value: controller.amPm.value,
                          underline: Container(),
                          items: ['AM', 'PM'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.setAmPm(value);
                            }
                          },
                        ),
                      ),
                    ],
                  )),

              SizedBox(height: (30 * 0.8).h),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: (20 * 0.8).w, vertical: (12 * 0.8).h),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: (16 * 0.8).sp,
                      ),
                    ),
                  ),
                  SizedBox(width: (10 * 0.8).w),
                  ElevatedButton(
                    onPressed: () {
                      // Format time properly
                      final time =
                          '${controller.hour.value.toString()}:${controller.minute.value.toString().padLeft(2, '0')}';

                      // Add schedule
                      controller.addCleaningSchedule(
                          plantId,
                          controller.selectedDay.value,
                          time,
                          controller.amPm.value);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8CD9B0),
                      padding: EdgeInsets.symmetric(
                          horizontal: (20 * 0.8).w, vertical: (12 * 0.8).h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular((8 * 0.8).r),
                      ),
                    ),
                    child: Text(
                      'Add Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: (16 * 0.8).sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditScheduleDialog(
      String plantId, String scheduleId, String day, String time, String amPm) {
    // Parse the original time
    final timeParts = time.split(':');
    int hour = int.tryParse(timeParts[0]) ?? 8;
    int minute = int.tryParse(timeParts[1]) ?? 0;
    String selectedDay = day;
    String selectedAmPm = amPm;

    // Predefined options
    final List<String> days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    if (!days.contains(selectedDay)) {
      selectedDay = days[0];
    }

    // Update controller values
    controller.setSelectedDay(selectedDay);
    controller.setHour(hour);
    controller.setMinute(minute);
    controller.setAmPm(selectedAmPm);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((16 * 0.8).r)),
        child: Container(
          padding: EdgeInsets.all((20 * 0.8).w),
          width: (350 * 0.8).w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Cleaning Schedule',
                    style: TextStyle(
                      fontSize: (18 * 0.8).sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: (24 * 0.8).sp),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),

              SizedBox(height: (20 * 0.8).h),

              // Day selection
              Text(
                'Select Day',
                style: TextStyle(
                  fontSize: (16 * 0.8).sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: (10 * 0.8).h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular((8 * 0.8).r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Obx(() => DropdownButton<String>(
                      value: controller.selectedDay.value,
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down, size: (24 * 0.8).sp),
                      items: days.map((String day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSelectedDay(value);
                        }
                      },
                    )),
              ),

              SizedBox(height: (20 * 0.8).h),

              // Time selection
              Text(
                'Select Time',
                style: TextStyle(
                  fontSize: (16 * 0.8).sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: (10 * 0.8).h),

              Obx(() => Row(
                    children: [
                      // Hour picker
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular((8 * 0.8).r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<int>(
                            value: controller.hour.value,
                            isExpanded: true,
                            underline: Container(),
                            items: List.generate(12, (index) => index + 1)
                                .map((int h) {
                              return DropdownMenuItem<int>(
                                value: h,
                                child: Text(h.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.setHour(value);
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: (10 * 0.8).w),
                      Text(':', style: TextStyle(fontSize: (16 * 0.8).sp)),
                      SizedBox(width: (10 * 0.8).w),

                      // Minute picker
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular((8 * 0.8).r),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButton<int>(
                            value: controller.minute.value,
                            isExpanded: true,
                            underline: Container(),
                            items: [0, 15, 30, 45].map((int m) {
                              return DropdownMenuItem<int>(
                                value: m,
                                child: Text(m.toString().padLeft(2, '0')),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.setMinute(value);
                              }
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: (10 * 0.8).w),

                      // AM/PM picker
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: (12 * 0.8).w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular((8 * 0.8).r),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButton<String>(
                          value: controller.amPm.value,
                          underline: Container(),
                          items: ['AM', 'PM'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.setAmPm(value);
                            }
                          },
                        ),
                      ),
                    ],
                  )),

              SizedBox(height: (30 * 0.8).h),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: (20 * 0.8).w, vertical: (12 * 0.8).h),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: (16 * 0.8).sp,
                      ),
                    ),
                  ),
                  SizedBox(width: (10 * 0.8).w),
                  ElevatedButton(
                    onPressed: () {
                      // Format time properly
                      final updatedTime =
                          '${controller.hour.value.toString()}:${controller.minute.value.toString().padLeft(2, '0')}';

                      // Update schedule
                      controller.editCleaningSchedule(
                          plantId,
                          scheduleId,
                          controller.selectedDay.value,
                          updatedTime,
                          controller.amPm.value);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8CD9B0),
                      padding: EdgeInsets.symmetric(
                          horizontal: (20 * 0.8).w, vertical: (12 * 0.8).h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular((8 * 0.8).r),
                      ),
                    ),
                    child: Text(
                      'Update Schedule',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: (16 * 0.8).sp,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show the delete confirmation dialog
  void _showDeleteConfirmationDialog(String plantId, String scheduleId) {
    Get.dialog(
      ConfirmationDialog(
        title: 'Confirm Deletion',
        content: 'Are you sure you want to delete this schedule?',
        onConfirm: () {
          controller.markScheduleForDeletion(plantId, scheduleId);
        },
      ),
    );
  }
}

