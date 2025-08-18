

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Controller/Inspector/manual_controller.dart';
import '../../Controller/Inspector/slot_controller.dart';

class InfoPage extends StatelessWidget {
  final ManualController controller = Get.find<ManualController>();
  final SlotController slotController = Get.put(SlotController());

  InfoPage({Key? key}) : super(key: key) {
    // Initialize in constructor
    final Map<String, dynamic>? plantData = Get.arguments;

    print('Received plant data: $plantData');

    final String? uuid = plantData?['uuid']?.toString();
    print('UUID: $uuid');

    // Set UUID after creation
    slotController.setUuid(uuid);
    slotController.printUuidInfo();
  }

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
                          : () => _saveWithCustomLoader(context),
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

                  // Group slots by pairs
                  final groupedSlots = _groupSlotsByPairs();

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: groupedSlots.length,
                    itemBuilder: (context, index) {
                      final slotGroup = groupedSlots[index];

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
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Group Header
                                Text(
                                  'Slot ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Side by side slots
                                Row(
                                  children: slotGroup.map((slot) {
                                    final isLast = slot == slotGroup.last;
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: isLast ? 0 : 12,
                                        ),
                                        child: _buildSlotItem(context, slot),
                                      ),
                                    );
                                  }).toList(),
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

  List<List<Map<String, dynamic>>> _groupSlotsByPairs() {
    final slots = controller.slotTimingsForDisplay;
    List<List<Map<String, dynamic>>> groupedSlots = [];

    for (int i = 0; i < slots.length; i += 2) {
      List<Map<String, dynamic>> group = [];
      group.add(slots[i]);
      if (i + 1 < slots.length) {
        group.add(slots[i + 1]);
      }
      groupedSlots.add(group);
    }

    return groupedSlots;
  }

  Widget _buildSlotItem(BuildContext context, Map<String, dynamic> slot) {
    final slotCode = slot['code'].toString();
    final currentValue = slotController.getCurrentSlotValue(slotCode);
    final formattedTime = slotController.formatSeconds(currentValue);
    final isOnTime =
        slot['description'].toString().toLowerCase().contains('on');

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: slotController.modifiedSlots.contains(slotCode)
              ? Colors.orange[200]!
              : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // ON/OFF indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isOnTime ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isOnTime ? 'ON' : 'OFF',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isOnTime ? Colors.green[700] : Colors.red[700],
              ),
            ),
          ),

          SizedBox(height: 12),

          // Description
          Text(
            slot['description'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 12),

          // Time Display/Edit
          Obx(() => InkWell(
                onTap: slotController.isEditMode.value &&
                        !slotController.isSaving.value
                    ? () => _showKeyboardTimeDialog(context, slot)
                    : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: slotController.isEditMode.value
                        ? (slotController.modifiedSlots.contains(slotCode)
                            ? Colors.orange[50]
                            : Colors.white)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: slotController.isEditMode.value
                          ? (slotController.modifiedSlots.contains(slotCode)
                              ? Colors.orange[300]!
                              : Colors.grey[300]!)
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: slotController.modifiedSlots.contains(slotCode)
                            ? Colors.orange[600]
                            : Colors.grey[600],
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formattedTime,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: slotController.modifiedSlots
                                      .contains(slotCode)
                                  ? Colors.orange[700]
                                  : Colors.grey[700],
                              fontFamily: 'monospace',
                            ),
                          ),
                          if (slotController.modifiedSlots.contains(slotCode))
                            Container(
                              margin: EdgeInsets.only(left: 4),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

// Enhanced save method with pre-save validation
  void _saveWithCustomLoader(BuildContext context) async {
    // Pre-save validation for all modified slots
    List<String> overlapErrors = [];

    for (String slotCode in slotController.modifiedSlots) {
      final newMinutes = slotController.modifiedValues[slotCode] ?? 0;
      final validationResult = _validateSlotOverlap(slotCode, newMinutes);

      if (!validationResult['isValid']) {
        final slotNumber = _getSlotNumberFromCode(slotCode);
        final isOn = _isOnSlot(slotCode);
        overlapErrors.add(
            'Slot $slotNumber ${isOn ? "ON" : "OFF"}: ${validationResult['message']}');
      }
    }

    if (overlapErrors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('⚠️ Overlap Detected'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cannot save due to overlapping time slots:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              ...overlapErrors
                  .map((error) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• $error',
                          style:
                              TextStyle(color: Colors.red[700], fontSize: 13),
                        ),
                      ))
                  .toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // If validation passes, proceed with save
    await slotController.saveChanges();
    _showCustomSuccessLoader(context);
  }

  void _showCustomSuccessLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto dismiss after 12 seconds
        Future.delayed(Duration(seconds: 12), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Animation
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 50,
                    color: Colors.green[600],
                  ),
                ),

                SizedBox(height: 24),

                Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'Slot timings updated successfully',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24),

                // Loading indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Refreshing data...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Enhanced time input dialog with overlap prevention
  void _showKeyboardTimeDialog(
      BuildContext context, Map<String, dynamic> slot) {
    final slotCode = slot['code'].toString();
    final currentValueInMinutes = slotController.getCurrentSlotValue(slotCode);

    // Convert minutes to hours and minutes for display
    int hours = (currentValueInMinutes / 60).floor();
    int minutes = currentValueInMinutes % 60;

    final hoursController =
        TextEditingController(text: hours.toString().padLeft(2, '0'));
    final minutesController =
        TextEditingController(text: minutes.toString().padLeft(2, '0'));

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                // Show current active slots
                _buildActiveSlotsSummary(),

                SizedBox(height: 16),

                Row(
                  children: [
                    // Hours input
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hours',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: hoursController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                              _NumericRangeFormatter(min: 0, max: 23),
                            ],
                            decoration: InputDecoration(
                              hintText: '00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 16),

                    // Separator
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),

                    SizedBox(width: 16),

                    // Minutes input
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Minutes',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: minutesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                              _NumericRangeFormatter(min: 0, max: 59),
                            ],
                            decoration: InputDecoration(
                              hintText: '00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'No overlapping allowed between different slots',
                              style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Format: HH:MM (24-hour format)',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 11,
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
                final inputHours = int.tryParse(hoursController.text) ?? 0;
                final inputMinutes = int.tryParse(minutesController.text) ?? 0;

                // Validate input ranges
                if (inputHours < 0 || inputHours > 23) {
                  Get.snackbar(
                    'Invalid Input',
                    'Hours must be between 00 and 23',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                if (inputMinutes < 0 || inputMinutes > 59) {
                  Get.snackbar(
                    'Invalid Input',
                    'Minutes must be between 00 and 59',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Convert to total minutes
                final newMinutes = (inputHours * 60) + inputMinutes;

                // Use enhanced validation
                final validationResult =
                    _validateSlotOverlap(slotCode, newMinutes);
                if (!validationResult['isValid']) {
                  Get.snackbar(
                    'Time Overlap Detected',
                    validationResult['message'],
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    duration: Duration(seconds: 5),
                  );
                  return;
                }

                slotController.updateSlotValue(slot, newMinutes);
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
  }

// Widget to show currently active slots
  Widget _buildActiveSlotsSummary() {
    List<String> activeSlots = [];

    for (int i = 1; i <= 4; i++) {
      final onCode = _getSlotCode(i, true);
      final offCode = _getSlotCode(i, false);

      final onTime = slotController.getCurrentSlotValue(onCode);
      final offTime = slotController.getCurrentSlotValue(offCode);

      if (onTime < offTime) {
        activeSlots.add(
            'Slot $i: ${slotController.formatSeconds(onTime)} - ${slotController.formatSeconds(offTime)}');
      }
    }

    if (activeSlots.isEmpty) {
      return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
            SizedBox(width: 8),
            Text(
              'No active time slots \n all slots available',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.orange[600]),
              SizedBox(width: 8),
              Text(
                'Currently Occupied Time Slots:',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...activeSlots
              .map((slot) => Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 4),
                    child: Text(
                      slot,
                      style: TextStyle(
                        color: Colors.orange[600],
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  // Enhanced overlap validation method
  Map<String, dynamic> _validateSlotOverlap(String slotCode, int newMinutes) {
    print('=== OVERLAP VALIDATION ===');
    print('Validating slot: $slotCode, newMinutes: $newMinutes');

    // Get current slot number and type
    final slotNumber = _getSlotNumberFromCode(slotCode);
    final isOnSlot = _isOnSlot(slotCode);

    // Get paired slot code and its current value
    final pairedSlotCode = _getPairedSlotCode(slotCode);
    final pairedSlotMinutes =
        slotController.getCurrentSlotValue(pairedSlotCode);

    // Validate ON/OFF relationship within same slot
    if (isOnSlot && newMinutes >= pairedSlotMinutes) {
      return {
        'isValid': false,
        'message':
            'ON time must be earlier than OFF time (${slotController.formatSeconds(pairedSlotMinutes)})'
      };
    }

    if (!isOnSlot && newMinutes <= pairedSlotMinutes) {
      return {
        'isValid': false,
        'message':
            'OFF time must be later than ON time (${slotController.formatSeconds(pairedSlotMinutes)})'
      };
    }

    // Get the complete time range for current slot
    int currentSlotOnTime, currentSlotOffTime;
    if (isOnSlot) {
      currentSlotOnTime = newMinutes;
      currentSlotOffTime = pairedSlotMinutes;
    } else {
      currentSlotOnTime = pairedSlotMinutes;
      currentSlotOffTime = newMinutes;
    }

    // Skip overlap check if current slot doesn't have valid range
    if (currentSlotOnTime >= currentSlotOffTime) {
      return {'isValid': true, 'message': 'Valid'};
    }

    // Check for overlaps with all other slots
    List<String> overlappingSlots = [];

    for (int i = 1; i <= 4; i++) {
      if (i == slotNumber) continue; // Skip current slot

      final otherOnCode = _getSlotCode(i, true);
      final otherOffCode = _getSlotCode(i, false);

      final otherOnTime = slotController.getCurrentSlotValue(otherOnCode);
      final otherOffTime = slotController.getCurrentSlotValue(otherOffCode);

      // Skip if other slot doesn't have valid range
      if (otherOnTime >= otherOffTime) continue;

      // Check for overlap: Two ranges overlap if start1 < end2 AND start2 < end1
      bool hasOverlap = (currentSlotOnTime < otherOffTime &&
          otherOnTime < currentSlotOffTime);

      if (hasOverlap) {
        overlappingSlots.add(
            'Slot $i (${slotController.formatSeconds(otherOnTime)} - ${slotController.formatSeconds(otherOffTime)})');
      }
    }

    if (overlappingSlots.isNotEmpty) {
      return {
        'isValid': false,
        'message':
            'Time range ${slotController.formatSeconds(currentSlotOnTime)} - ${slotController.formatSeconds(currentSlotOffTime)} overlaps with: ${overlappingSlots.join(", ")}'
      };
    }

    return {'isValid': true, 'message': 'Valid timing'};
  }

  // Helper methods
  int _getSlotNumberFromCode(String slotCode) {
    switch (slotCode) {
      case '550':
      case '554':
        return 1;
      case '551':
      case '555':
        return 2;
      case '552':
      case '556':
        return 3;
      case '553':
      case '557':
        return 4;
      default:
        return 0;
    }
  }

  bool _isOnSlot(String slotCode) {
    return ['550', '551', '552', '553'].contains(slotCode);
  }

  String _getPairedSlotCode(String slotCode) {
    const pairMap = {
      '550': '554', '554': '550', // Slot 1
      '551': '555', '555': '551', // Slot 2
      '552': '556', '556': '552', // Slot 3
      '553': '557', '557': '553', // Slot 4
    };
    return pairMap[slotCode] ?? '';
  }

  String _getSlotCode(int slotNumber, bool isOn) {
    const slotCodes = {
      1: {'on': '550', 'off': '554'},
      2: {'on': '551', 'off': '555'},
      3: {'on': '552', 'off': '556'},
      4: {'on': '553', 'off': '557'},
    };
    return slotCodes[slotNumber]?[isOn ? 'on' : 'off'] ?? '';
  }
}

// Custom input formatter to restrict numeric input to a range
class _NumericRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _NumericRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}

