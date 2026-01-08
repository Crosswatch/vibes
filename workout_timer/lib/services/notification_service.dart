import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open workout',
    );

    const initializationSettings = InitializationSettings(
      linux: initializationSettingsLinux,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    _initialized = true;
  }

  Future<void> showExerciseNotification({
    required String exerciseName,
    required String description,
  }) async {
    if (!_initialized) await initialize();

    const notificationDetails = NotificationDetails(
      linux: LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.critical,
      ),
    );

    await _notifications.show(
      0, // notification id
      'Next Exercise: $exerciseName',
      description,
      notificationDetails,
    );
  }

  Future<void> showTransitionNotification({
    required String nextExerciseName,
    required int secondsRemaining,
  }) async {
    if (!_initialized) await initialize();

    const notificationDetails = NotificationDetails(
      linux: LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.normal,
      ),
    );

    await _notifications.show(
      0, // notification id
      'Get Ready',
      'Next: $nextExerciseName in ${secondsRemaining}s',
      notificationDetails,
    );
  }

  Future<void> showWorkoutCompleteNotification() async {
    if (!_initialized) await initialize();

    const notificationDetails = NotificationDetails(
      linux: LinuxNotificationDetails(
        urgency: LinuxNotificationUrgency.normal,
      ),
    );

    await _notifications.show(
      0, // notification id
      'Workout Complete!',
      'Great job! You finished your workout.',
      notificationDetails,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
