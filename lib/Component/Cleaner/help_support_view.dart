import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../Controller/Inspector/manual_controller.dart';
import '../../Controller/Inspector/slot_controller.dart';

// Rest of your InfoPage widget code remains the same...
class InfoPage extends StatelessWidget {
  final ManualController controller = Get.find<ManualController>();
  final SlotController slotController = Get.put(SlotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Slot Timings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
        actions: [
          Obx(() => slotController.isEditMode.value
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: slotController.isSaving.value
                          ? null
                          : slotController.cancelEdit,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: slotController.isSaving.value
                                ? Colors.grey[400]
                                : Colors.grey[600]),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: slotController.isSaving.value
                          ? null
                          : slotController.saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: slotController.isSaving.value
                            ? Colors.grey[400]
                            : Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: slotController.isSaving.value
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text('Save'),
                    ),
                    SizedBox(width: 16),
                  ],
                )
              : IconButton(
                  onPressed: slotController.toggleEditMode,
                  icon: Icon(Icons.edit),
                  tooltip: 'Edit Timings',
                )),
        ],
      ),
      body: Obx(() {
        // Listen to refresh trigger to force rebuilds
        slotController.refreshTrigger.value;

        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading slot timings...',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[300],
                ),
                SizedBox(height: 16),
                Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add retry logic here
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header with edit mode indicator
            if (slotController.isEditMode.value)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.blue[50],
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.blue[700],
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Edit Mode: Tap on time values to modify',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Obx(() => slotController.modifiedSlots.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${slotController.modifiedSlots.length} modified',
                              style: TextStyle(
                                color: Colors.orange[800],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : SizedBox()),
                  ],
                ),
              ),

            Expanded(
              child: GetBuilder<SlotController>(
                builder: (slotCtrl) => Obx(() {
                  // Listen to both controllers
                  slotController.refreshTrigger.value;

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: controller.slotTimingsForDisplay.length,
                    itemBuilder: (context, index) {
                      final slot = controller.slotTimingsForDisplay[index];
                      final slotCode = slot['code'].toString();

                      // CHANGED: Use getCurrentSlotValue instead of slot['value']
                      final currentValue =
                          slotController.getCurrentSlotValue(slotCode);
                      final formattedTime =
                          slotController.formatSeconds(currentValue);

                      final isOnTime = slot['description']
                          .toString()
                          .toLowerCase()
                          .contains('on');

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white,
                                isOnTime ? Colors.green[50]! : Colors.red[50]!,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: [
                                // Slot Code Container
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: isOnTime
                                        ? Colors.green[100]
                                        : Colors.red[100],
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isOnTime
                                          ? Colors.green[200]!
                                          : Colors.red[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${slot['code']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: isOnTime
                                              ? Colors.green[800]
                                              : Colors.red[800],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: isOnTime
                                              ? Colors.green[200]
                                              : Colors.red[200],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          isOnTime ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: isOnTime
                                                ? Colors.green[800]
                                                : Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 16),

                                // Slot Information
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        slot['description'],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                      SizedBox(height: 8),

                                      // Time Display/Edit
                                      Obx(() => InkWell(
                                            onTap: slotController
                                                        .isEditMode.value &&
                                                    !slotController
                                                        .isSaving.value
                                                ? () => _showTimePickerDialog(
                                                    context, slot)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(
                                                color: slotController
                                                        .isEditMode.value
                                                    ? (slotController
                                                            .modifiedSlots
                                                            .contains(slotCode)
                                                        ? Colors.orange[50]
                                                        : Colors.blue[50])
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: slotController
                                                          .isEditMode.value
                                                      ? (slotController
                                                              .modifiedSlots
                                                              .contains(
                                                                  slotCode)
                                                          ? Colors.orange[200]!
                                                          : Colors.blue[200]!)
                                                      : Colors.transparent,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    size: 16,
                                                    color: slotController
                                                            .isEditMode.value
                                                        ? (slotController
                                                                .modifiedSlots
                                                                .contains(
                                                                    slotCode)
                                                            ? Colors.orange[600]
                                                            : Colors.blue[600])
                                                        : Colors.grey[600],
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    formattedTime,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: slotController
                                                              .isEditMode.value
                                                          ? (slotController
                                                                  .modifiedSlots
                                                                  .contains(
                                                                      slotCode)
                                                              ? Colors
                                                                  .orange[700]
                                                              : Colors
                                                                  .blue[700])
                                                          : Colors.grey[700],
                                                      fontFamily: 'monospace',
                                                    ),
                                                  ),
                                                  if (slotController
                                                          .isEditMode.value &&
                                                      !slotController
                                                          .isSaving.value) ...[
                                                    SizedBox(width: 6),
                                                    Icon(
                                                      slotController
                                                              .modifiedSlots
                                                              .contains(
                                                                  slotCode)
                                                          ? Icons.edit_outlined
                                                          : Icons.edit,
                                                      size: 14,
                                                      color: slotController
                                                              .modifiedSlots
                                                              .contains(
                                                                  slotCode)
                                                          ? Colors.orange[600]
                                                          : Colors.blue[600],
                                                    ),
                                                  ],
                                                  if (slotController
                                                      .modifiedSlots
                                                      .contains(slotCode)) ...[
                                                    SizedBox(width: 6),
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration: BoxDecoration(
                                                        color: Colors.orange,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showTimePickerDialog(BuildContext context, Map<String, dynamic> slot) {
    final slotCode = slot['code'].toString();
    // CHANGED: Use getCurrentSlotValue instead of slot['value']
    final currentValue = slotController.getCurrentSlotValue(slotCode);
    final currentTime = slotController.formatSeconds(currentValue);
    final timeParts = currentTime.split(':');

    int selectedHours = int.parse(timeParts[0]);
    int selectedMinutes = int.parse(timeParts[1]);
    int selectedSeconds = int.parse(timeParts[2]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Time',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    slot['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTimeSelector(
                            'Hours',
                            selectedHours,
                            0,
                            23,
                            (value) => setState(() => selectedHours = value),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          _buildTimeSelector(
                            'Minutes',
                            selectedMinutes,
                            0,
                            59,
                            (value) => setState(() => selectedMinutes = value),
                          ),
                          Text(
                            ':',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          _buildTimeSelector(
                            'Seconds',
                            selectedSeconds,
                            0,
                            59,
                            (value) => setState(() => selectedSeconds = value),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'New time: ${selectedHours.toString().padLeft(2, '0')}:${selectedMinutes.toString().padLeft(2, '0')}:${selectedSeconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newSeconds = (selectedHours * 3600) +
                        (selectedMinutes * 60) +
                        selectedSeconds;
                    slotController.updateSlotValue(slot, newSeconds);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTimeSelector(
      String label, int value, int min, int max, ValueChanged<int> onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  if (value < max) onChanged(value + 1);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.keyboard_arrow_up,
                    size: 20,
                    color: value < max ? Colors.blue : Colors.grey[400],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  value.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (value > min) onChanged(value - 1);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: value > min ? Colors.blue : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
