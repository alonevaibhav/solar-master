// controllers/schedule_controller.dart
import 'package:get/get.dart';
import 'package:solar_app/API%20Service/Model/Request/shedule_model.dart';
import '../../API Service/api_service.dart';

class ScheduleController extends GetxController {
  // Observable state variables
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _scheduleResponse = Rxn<ScheduleResponse>();
  final _selectedWeek = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  ScheduleResponse? get scheduleResponse => _scheduleResponse.value;
  String get selectedWeek => _selectedWeek.value;

  // Get all schedules
  List<Schedule> get allSchedules => _scheduleResponse.value?.getAllSchedules() ?? [];

  // Get schedules for selected week
  List<Schedule> get schedulesForSelectedWeek =>
      _scheduleResponse.value?.getSchedulesByWeek(_selectedWeek.value) ?? [];

  // Get available weeks
  List<String> get availableWeeks => _scheduleResponse.value?.getWeekNames() ?? [];

  // Fetch inspector schedules
  Future<void> fetchInspectorSchedules() async {
    try {
      _setLoading(true);
      _clearError();

      // Get stored UID
      final storedUid = await ApiService.getUid();
      if (storedUid == null || storedUid.isEmpty) {
        throw Exception('User ID not found. Please login again.');
      }


      // Make API call
      final response = await ApiService.get<ScheduleResponse>(
        endpoint: '/schedules/inspector-schedules/inspector/$storedUid/weekly',
        fromJson: (json) => ScheduleResponse.fromJson(json),
        includeToken: true,
      );

      if (response.success && response.data != null) {
        _scheduleResponse.value = response.data;

        // Set first week as selected if available
        if (availableWeeks.isNotEmpty && _selectedWeek.value.isEmpty) {
          _selectedWeek.value = availableWeeks.first;
        }

      } else {
        throw Exception(response.errorMessage ?? 'Failed to fetch schedules');
      }
    } catch (e) {
      _setError('Error fetching schedules: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh schedules
  Future<void> refreshSchedules() async {
    await fetchInspectorSchedules();
  }

  // Select a specific week
  void selectWeek(String week) {
    if (_selectedWeek.value != week) {
      _selectedWeek.value = week;
    }
  }

  // Get schedules by status
  List<Schedule> getSchedulesByStatus(String status) {
    return allSchedules
        .where((schedule) => schedule.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Get schedules by day
  List<Schedule> getSchedulesByDay(String day) {
    return schedulesForSelectedWeek
        .where((schedule) => schedule.day.toLowerCase() == day.toLowerCase())
        .toList();
  }

  // Count schedules by status
  Map<String, int> getScheduleCountByStatus() {
    Map<String, int> counts = {};
    for (var schedule in allSchedules) {
      String status = schedule.status.isEmpty ? 'pending' : schedule.status.toLowerCase();
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts;
  }

  // Get today's schedules (if applicable)
  List<Schedule> getTodaySchedules() {
    DateTime now = DateTime.now();
    String today = _getDayAbbreviation(now.weekday);
    return schedulesForSelectedWeek
        .where((schedule) => schedule.day.toLowerCase() == today)
        .toList();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String error) {
    _errorMessage.value = error;
  }

  void _clearError() {
    _errorMessage.value = null;
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case 1:
        return 'mo';
      case 2:
        return 'tu';
      case 3:
        return 'we';
      case 4:
        return 'th';
      case 5:
        return 'fr';
      case 6:
        return 'sa';
      case 7:
        return 'su';
      default:
        return 'mo';
    }
  }

  // Clear all data
  void clearData() {
    _scheduleResponse.value = null;
    _selectedWeek.value = '';
    _errorMessage.value = null;
    _isLoading.value = false;
  }
}