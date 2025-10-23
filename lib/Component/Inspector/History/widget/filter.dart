//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../history_controller.dart';
//
// class MqttHistoryDateFilter extends StatelessWidget {
//   final InspectorHistoryController controller;
//
//   const MqttHistoryDateFilter({
//     super.key,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey[200]!),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 4,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Select Date Range',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//             ),
//           ),
//           SizedBox(height: 16),
//           // Year and Month in Row
//           Row(
//             children: [
//               Expanded(
//                 child: _buildYearDropdown(),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildMonthDropdown(),
//               ),
//             ],
//           ),
//
//           // Date Filter Section
//
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: _buildFetchButton(),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: _buildGetAllDataButton(),
//               ),
//             ],
//           ),
//           SizedBox(height: 16),
//           _buildDateFilterSection(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDateFilterSection() {
//     return Obx(
//           () => Container(
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.blue[50],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.blue[200]!),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Date Filter',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.blue[900],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Start Date',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: TextField(
//                           controller: controller.startDateController,
//                           keyboardType: TextInputType.number,
//                           maxLength: 2,
//                           decoration: InputDecoration(
//                             hintText: 'date-1',
//                             border: InputBorder.none,
//                             counterText: '',
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 10,
//                             ),
//                           ),
//                           onSubmitted: (value) => controller.updateDateFilter(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'End Date (Optional)',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: 6),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(color: Colors.grey[300]!),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: TextField(
//                           controller: controller.endDateController,
//                           keyboardType: TextInputType.number,
//                           maxLength: 2,
//                           decoration: InputDecoration(
//                             hintText: 'date-31',
//                             border: InputBorder.none,
//                             counterText: '',
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 10,
//                             ),
//                             isDense: true,
//                           ),
//                           onSubmitted: (value) => controller.updateDateFilter(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             // Apply Filter Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => controller.updateDateFilter(),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[600],
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 icon: Icon(Icons.filter_alt, size: 18, color: Colors.white),
//                 label: Text(
//                   'Apply Filter',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//             if (controller.isDateFilterActive.value) ...[
//               SizedBox(height: 8),
//               Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.green[50],
//                   borderRadius: BorderRadius.circular(4),
//                   border: Border.all(color: Colors.green[200]!),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.filter_alt, size: 16, color: Colors.green[700]),
//                     SizedBox(width: 6),
//                     Expanded(
//                       child: Text(
//                         controller.getDateFilterDisplay(),
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.green[900],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildYearDropdown() {
//     return Obx(
//           () => Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<int>(
//             value: controller.selectedYear.value,
//             isExpanded: true,
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             items: _getYearList().map((year) {
//               return DropdownMenuItem<int>(
//                 value: year,
//                 child: Text(year.toString()),
//               );
//             }).toList(),
//             onChanged: (year) {
//               if (year != null) {
//                 controller.updateYear(year);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMonthDropdown() {
//     const months = [
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December'
//     ];
//
//     return Obx(
//           () => Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey[300]!),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<int>(
//             value: controller.selectedMonth.value,
//             isExpanded: true,
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             items: List.generate(12, (index) {
//               return DropdownMenuItem<int>(
//                 value: index + 1,
//                 child: Text(months[index]),
//               );
//             }).toList(),
//             onChanged: (month) {
//               if (month != null) {
//                 controller.updateMonth(month);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFetchButton() {
//     return Obx(
//           () => ElevatedButton.icon(
//         onPressed: controller.isLoading.value
//             ? null
//             : () => controller.loadMqttHistoryByYearMonth(),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue[700],
//           disabledBackgroundColor: Colors.grey[300],
//           padding: EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         icon: controller.isLoading.value
//             ? SizedBox(
//           width: 16,
//           height: 16,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         )
//             : Icon(Icons.search, color: Colors.white),
//         label: Text(
//           controller.isLoading.value ? 'Fetching...' : 'Fetch History',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGetAllDataButton() {
//     return Obx(
//           () => ElevatedButton.icon(
//         onPressed: controller.isCollectingData.value
//             ? null
//             : () => controller.triggerDataCollection(),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green[700],
//           disabledBackgroundColor: Colors.grey[300],
//           padding: EdgeInsets.symmetric(vertical: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         icon: controller.isCollectingData.value
//             ? SizedBox(
//           width: 16,
//           height: 16,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         )
//             : Icon(Icons.download, color: Colors.white),
//         label: Text(
//           controller.isCollectingData.value ? 'Collecting...' : 'Get Data',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<int> _getYearList() {
//     int currentYear = DateTime.now().year;
//     return List.generate(5, (index) => currentYear - index);
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../history_controller.dart';

class MqttHistoryDateFilter extends StatelessWidget {
  final InspectorHistoryController controller;

  const MqttHistoryDateFilter({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          // Year and Month in Row
          Row(
            children: [
              Expanded(
                child: _buildYearDropdown(),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMonthDropdown(),
              ),
            ],
          ),

          // Date Filter Section

          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFetchButton(),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildGetAllDataButton(),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDateFilterSection(),
        ],
      ),
    );
  }

  Widget _buildDateFilterSection() {
    return Obx(
          () => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date Filter',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          controller: controller.startDateController,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          decoration: InputDecoration(
                            hintText: 'date-1',
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          onSubmitted: (value) => controller.updateDateFilter(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Date (Optional)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          controller: controller.endDateController,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          decoration: InputDecoration(
                            hintText: 'date-31',
                            border: InputBorder.none,
                            counterText: '',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            isDense: true,
                          ),
                          onSubmitted: (value) => controller.updateDateFilter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Apply Filter Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => controller.updateDateFilter(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                icon: Icon(Icons.filter_alt, size: 18, color: Colors.white),
                label: Text(
                  'Apply Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (controller.isDateFilterActive.value) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_alt, size: 16, color: Colors.green[700]),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        controller.getDateFilterDisplay(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[900],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Obx(
          () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedYear.value,
            isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            items: _getYearList().map((year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text(year.toString()),
              );
            }).toList(),
            onChanged: (year) {
              if (year != null) {
                controller.updateYear(year);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Obx(
          () {
        // Get available months based on selected year
        List<int> availableMonths = _getAvailableMonths();

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: controller.selectedMonth.value,
              isExpanded: true,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              items: availableMonths.map((monthNum) {
                return DropdownMenuItem<int>(
                  value: monthNum,
                  child: Text(months[monthNum - 1]),
                );
              }).toList(),
              onChanged: (month) {
                if (month != null) {
                  controller.updateMonth(month);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFetchButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isLoading.value
            ? null
            : () => controller.loadMqttHistoryByYearMonth(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          disabledBackgroundColor: Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: controller.isLoading.value
            ? SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Icon(Icons.search, color: Colors.white),
        label: Text(
          controller.isLoading.value ? 'Fetching...' : 'Fetch History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildGetAllDataButton() {
    return Obx(
          () => ElevatedButton.icon(
        onPressed: controller.isCollectingData.value
            ? null
            : () => controller.triggerDataCollection(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          disabledBackgroundColor: Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: controller.isCollectingData.value
            ? SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Icon(Icons.download, color: Colors.white),
        label: Text(
          controller.isCollectingData.value ? 'Collecting...' : 'Get Data',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Updated: Year list from 2025 to 2030
  List<int> _getYearList() {
    return List.generate(6, (index) => 2025 + index);
  }

  // New: Get available months based on selected year
  List<int> _getAvailableMonths() {
    int selectedYear = controller.selectedYear.value;

    // For 2025, only show September (9) onwards
    if (selectedYear == 2025) {
      return List.generate(4, (index) => 9 + index); // 9, 10, 11, 12
    }

    // For other years, show all months
    return List.generate(12, (index) => index + 1);
  }
}