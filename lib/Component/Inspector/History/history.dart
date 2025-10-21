// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:solar_app/Component/Inspector/History/widget/filter.dart';
// import 'cycle_view.dart';
// import 'history_controller.dart';
//
// class HistoryInspector extends StatelessWidget {
//   HistoryInspector({super.key});
//
//   final InspectorHistoryController controller =
//       Get.put(InspectorHistoryController());
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic>? plantData = Get.arguments;
//     print('Received plant data: $plantData');
//     final String? plantID = plantData?['id']?.toString();
//     print('id of plant : $plantID');
//
//     final String? plantUUID = plantData?['uuid']?.toString();
//     print('plant UUID is  : $plantUUID');
//
//     controller.setPlantId(plantID);
//     controller.printUuidInfo(plantUUID);
//     if (plantID != null && plantID.isNotEmpty) {
//       controller.loadMqttHistoryByYearMonth();
//     }
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: Text('Cleaning Cycles'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               if (plantID != null && plantID.isNotEmpty) {
//                 controller.loadMqttHistoryByYearMonth();
//               } else {
//                 Get.snackbar(
//                   'Error',
//                   'No valid UUID provided',
//                   backgroundColor: Colors.red[100],
//                   colorText: Colors.red[800],
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
//                 ),
//                 SizedBox(height: 16),
//                 Text(
//                   'Loading cleaning cycles...',
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.hasError.value) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 MqttHistoryDateFilter(controller: controller),
//                 SizedBox(height: 24),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline,
//                           size: 64, color: Colors.red[400]),
//                       SizedBox(height: 16),
//                       Text(
//                         'Something went wrong',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red[700],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         controller.errorMessage.value,
//                         style: TextStyle(color: Colors.red[600]),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 24),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           if (plantID != null && plantID.isNotEmpty) {
//                             controller.loadMqttHistoryByYearMonth();
//                           }
//                         },
//                         icon: Icon(Icons.refresh),
//                         label: Text('Retry'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[700],
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         if (controller.cycles.isEmpty) {
//           return SingleChildScrollView(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 MqttHistoryDateFilter(controller: controller),
//                 SizedBox(height: 24),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.history, size: 64, color: Colors.grey[400]),
//                       SizedBox(height: 16),
//                       Text(
//                         'No Cleaning Cycles',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'No cleaning cycles found for the selected month',
//                         style: TextStyle(color: Colors.grey[500]),
//                         textAlign: TextAlign.center,
//                       ),
//                       SizedBox(height: 24),
//                       ElevatedButton.icon(
//                         onPressed: () {
//                           if (plantID != null && plantID.isNotEmpty) {
//                             controller.loadMqttHistoryByYearMonth();
//                           }
//                         },
//                         icon: Icon(Icons.refresh),
//                         label: Text('Load Data'),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue[700],
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//
//         // Success state - Show filter and cycles
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               // Date Filter at the top
//               Container(
//                 padding: EdgeInsets.all(16),
//                 child: MqttHistoryDateFilter(controller: controller),
//               ),
//               // Cycles List
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 padding: EdgeInsets.all(16),
//                 itemCount: controller.cycles.length,
//                 itemBuilder: (context, index) {
//                   final cycle = controller.cycles[index];
//                   final isLastCycle = index == controller.cycles.length - 1;
//                   return CycleGroupWidget(
//                     controller: controller,
//                     cycle: cycle,
//                     isLastGroup: isLastCycle,
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solar_app/Component/Inspector/History/widget/filter.dart';
import 'cycle_view.dart';
import 'history_controller.dart';

class HistoryInspector extends StatelessWidget {
  HistoryInspector({super.key});

  final InspectorHistoryController controller = Get.put(InspectorHistoryController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? plantData = Get.arguments;
    print('Received plant data: $plantData');
    final String? plantID = plantData?['id']?.toString();
    print('id of plant : $plantID');

    final String? plantUUID = plantData?['uuid']?.toString();
    print('plant UUID is  : $plantUUID');

    controller.setPlantId(plantID);
    controller.printUuidInfo(plantUUID);
    controller.clearData;

    if (plantID != null && plantID.isNotEmpty) {
      controller.loadMqttHistoryByYearMonth();
    }

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        // Load more when user is 200px from bottom
        controller.loadMoreCycles();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Cleaning Cycles'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (plantID != null && plantID.isNotEmpty) {
                controller.loadMqttHistoryByYearMonth();
              } else {
                Get.snackbar(
                  'Error',
                  'No valid UUID provided',
                  backgroundColor: Colors.red[100],
                  colorText: Colors.red[800],
                );
              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading cleaning cycles...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                MqttHistoryDateFilter(controller: controller),
                SizedBox(height: 24),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                      SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(color: Colors.red[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (plantID != null && plantID.isNotEmpty) {
                            controller.loadMqttHistoryByYearMonth();
                          }
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.cycles.isEmpty) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                MqttHistoryDateFilter(controller: controller),
                SizedBox(height: 24),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No Cleaning Cycles',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'No cleaning cycles found for the selected month',
                        style: TextStyle(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (plantID != null && plantID.isNotEmpty) {
                            controller.loadMqttHistoryByYearMonth();
                          }
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Load Data'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Success state - Show filter and cycles with pagination
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            // Date Filter
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    MqttHistoryDateFilter(controller: controller),
                    SizedBox(height: 8),

                  ],
                ),
              ),
            ),

            // Cycles List
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final cycle = controller.cycles[index];
                    final isLastCycle = index == controller.cycles.length - 1;
                    return CycleGroupWidget(
                      controller: controller,
                      cycle: cycle,
                      isLastGroup: isLastCycle && !controller.hasMoreData.value,
                    );
                  },
                  childCount: controller.cycles.length,
                ),
              ),
            ),

            // Loading more indicator
            if (controller.hasMoreData.value)
              SliverToBoxAdapter(
                child: Obx(() => controller.isLoadingMore.value
                    ? Container(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Loading more cycles...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : SizedBox(height: 16)),
              ),

            // End of list message
            if (!controller.hasMoreData.value && controller.cycles.isNotEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      '✓ All cycles loaded',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}