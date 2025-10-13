// Data Models
class CycleData {
  final int cycleNumber;
  final int plantId;
  final List<CycleEvent> events;
  final CycleSummary summary;

  CycleData({
    required this.cycleNumber,
    required this.plantId,
    required this.events,
    required this.summary,
  });

  factory CycleData.fromJson(Map<String, dynamic> json) {
    return CycleData(
      cycleNumber: json['cycle_number'] ?? 0,
      plantId: json['plant_id'] ?? 0,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => CycleEvent.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      summary: CycleSummary.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CycleEvent {
  final int id;
  final int cycle;
  final String time;
  final String status;
  final int solenoid;
  final int complete;
  final String timestamp;
  final String topic;

  CycleEvent({
    required this.id,
    required this.cycle,
    required this.time,
    required this.status,
    required this.solenoid,
    required this.complete,
    required this.timestamp,
    required this.topic,
  });

  factory CycleEvent.fromJson(Map<String, dynamic> json) {
    return CycleEvent(
      id: json['id'] ?? 0,
      cycle: json['cycle'] ?? 0,
      time: json['time'] ?? 'Unknown',
      status: json['status'] ?? 'Unknown',
      solenoid: json['solenoid'] ?? 0,
      complete: json['complete'] ?? 0,
      timestamp: json['timestamp'] ?? '',
      topic: json['topic'] ?? '',
    );
  }
}

class CycleSummary {
  final int totalEvents;
  final String startedAt;
  final String? completedAt;
  final bool isCompleted;
  final int faultCount;
  final int? durationSeconds;
  final SolenoidRange solenoidRange;
  final String startMethod;
  final String stopMethod;

  CycleSummary({
    required this.totalEvents,
    required this.startedAt,
    this.completedAt,
    required this.isCompleted,
    required this.faultCount,
    this.durationSeconds,
    required this.solenoidRange,
    required this.startMethod,
    required this.stopMethod,
  });

  factory CycleSummary.fromJson(Map<String, dynamic> json) {
    return CycleSummary(
      totalEvents: json['total_events'] ?? 0,
      startedAt: json['started_at'] ?? 'Unknown',
      completedAt: json['completed_at'],
      isCompleted: json['is_completed'] ?? false,
      faultCount: json['fault_count'] ?? 0,
      durationSeconds: json['duration_seconds'],
      solenoidRange: SolenoidRange.fromJson(
          json['solenoid_range'] as Map<String, dynamic>? ?? {}),
      startMethod: json['start_method'] ?? 'Unknown',
      stopMethod: json['stop_method'] ?? 'Unknown',
    );
  }
}

class SolenoidRange {
  final int min;
  final int max;

  SolenoidRange({required this.min, required this.max});

  factory SolenoidRange.fromJson(Map<String, dynamic> json) {
    return SolenoidRange(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
    );
  }
}