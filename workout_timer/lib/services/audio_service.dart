import 'dart:io';
import 'dart:async';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool _soundEnabled = true;

  /// Play a notification beep (for exercise completions)
  Future<void> playNotification() async {
    if (!_soundEnabled) return;
    
    try {
      if (Platform.isLinux) {
        // Use paplay with short system sound
        await Process.run(
          'paplay',
          ['/usr/share/sounds/freedesktop/stereo/complete.oga'],
        ).timeout(
          const Duration(milliseconds: 800),
          onTimeout: () => ProcessResult(0, 1, '', ''),
        );
      }
    } catch (e) {
      // Silently fail - audio is not critical
    }
  }

  /// Play a countdown beep (short click for 3-2-1 countdown)
  Future<void> playCountdown() async {
    if (!_soundEnabled) return;
    
    try {
      if (Platform.isLinux) {
        // Use paplay with message-new-instant sound
        await Process.run(
          'paplay',
          ['/usr/share/sounds/freedesktop/stereo/message-new-instant.oga'],
        ).timeout(
          const Duration(milliseconds: 500),
          onTimeout: () => ProcessResult(0, 1, '', ''),
        );
      }
    } catch (e) {
      // Silently fail
    }
  }

  void enableSound() {
    _soundEnabled = true;
  }

  void disableSound() {
    _soundEnabled = false;
  }
}
