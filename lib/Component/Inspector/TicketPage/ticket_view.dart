
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_app/Component/Inspector/TicketPage/ticket_card.dart';
import 'package:solar_app/Route%20Manager/app_routes.dart';
import '../../../Controller/Inspector/ticket_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

  class TicketView extends GetView<TicketController> {
  const TicketView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Obx(() => RefreshIndicator(
          onRefresh: controller.refreshAllTickets,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildSearchBar(),
                _buildFilterAndTabSection(context), // Combined filter and tabs in a single column
                _buildTicketList(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search Area...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD380),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TextButton.icon(
              onPressed: () {
                Get.snackbar(
                  'History',
                  'Viewing ticket history',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              icon: const Icon(Icons.history, color: Colors.black),
              label: Text(
                'History',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndTabSection(context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Filter Dropdown
          Expanded(
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  isExpanded: true,
                  value: controller.selectedFilter.value,
                  hint: Text(
                    'Sort by',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'All',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'All',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Ticket Open',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Ticket Open',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Ticket Closed',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Ticket Closed',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Priority Critical',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Priority Critical',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Priority High',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEA580C),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Priority High',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Priority Medium',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFFCA8A04),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Priority Medium',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Priority Low',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF059669),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Priority Low',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Priority Very Low',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0284C7),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              'Priority Very Low',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.setSelectedFilter(newValue);
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    height: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                    iconSize: 16.sp,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 200.h,
                    width: MediaQuery.of(context).size.width * 0.5, // Set responsive width
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    offset: Offset(0, -6.h),
                    scrollbarTheme: ScrollbarThemeData(
                      radius: Radius.circular(40.r),
                      thickness: WidgetStateProperty.all(6),
                      thumbVisibility: WidgetStateProperty.all(true),
                    ),
                    useSafeArea: true,
                    isOverButton: false, // Prevents dropdown from overlapping button
                    elevation: 8, // Better shadow
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    height: 36.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w), // Space between filter and tabs
          // All Tickets Button
          Expanded(
            child: GestureDetector(
              onTap: () => controller.setTicketTab('all'),
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: controller.selectedTicketTab.value == 'all'
                      ? const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: controller.selectedTicketTab.value == 'all'
                      ? null
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: controller.selectedTicketTab.value == 'all'
                        ? Colors.transparent
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                  boxShadow: controller.selectedTicketTab.value == 'all'
                      ? [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: controller.selectedTicketTab.value == 'all'
                          ? Colors.white
                          : Colors.grey[600],
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'All Tickets',
                      style: TextStyle(
                        color: controller.selectedTicketTab.value == 'all'
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: controller.selectedTicketTab.value == 'all'
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w), // Space between the buttons
          // My Tickets Button
          Expanded(
            child: GestureDetector(
              onTap: () => controller.setTicketTab('my'),
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: controller.selectedTicketTab.value == 'my'
                      ? const LinearGradient(
                    colors: [Color(0xFFE67E22), Color(0xFFD35400)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : null,
                  color: controller.selectedTicketTab.value == 'my'
                      ? null
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: controller.selectedTicketTab.value == 'my'
                        ? Colors.transparent
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                  boxShadow: controller.selectedTicketTab.value == 'my'
                      ? [
                    BoxShadow(
                      color: const Color(0xFFE67E22).withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      color: controller.selectedTicketTab.value == 'my'
                          ? Colors.white
                          : Colors.grey[600],
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'My Tickets',
                      style: TextStyle(
                        color: controller.selectedTicketTab.value == 'my'
                            ? Colors.white
                            : Colors.grey[700],
                        fontWeight: controller.selectedTicketTab.value == 'my'
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.value != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${controller.errorMessage.value}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.refreshTickets,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.filteredTickets.isEmpty) {
      return Column(
        children: [
          SizedBox(height: 100.h),
          const Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No tickets found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          itemCount: controller.filteredTickets.length,
          itemBuilder: (context, index) {
            final ticket = controller.filteredTickets[index];
            return TicketCardWidget(
              ticket: ticket,
              onCallPressed: controller.callContact,
              onNavigatePressed: controller.navigateToLocation,
              onTap: (ticket) {
                Get.toNamed(AppRoutes.inspectorTicketDetailView,
                    arguments: ticket);
              },
            );
          },
        ),
      ],
    );
  }
}
