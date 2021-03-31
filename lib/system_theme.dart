import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Default system accent color.
const kDefaultSystemAccentColor = Color(0xff00b7c3);

const kGetDarkModeMethod = 'SystemTheme.darkMode';
const kGetSystemAccentColorMethod = 'SystemTheme.accentColor';

/// Platform channel handler for invoking native methods.
final MethodChannel _channel = MethodChannel('system_theme');

/// Class to return current system theme state on Windows.
///
/// [SystemTheme.darkMode] returns whether currently dark mode is enabled or not.
///
/// [SystemTheme.accentColor] returns the current accent color as [SystemAccentColor].
///
class SystemTheme {
  /// Get the system accent color.
  ///
  /// This is available for the following platforms:
  ///   - Windows
  /// 
  /// It returns [kDefaultSystemAccentColor] for unsupported platforms
  static final SystemAccentColor accentInstance = SystemAccentColor(kDefaultSystemAccentColor)..load();

  /// Wheter the dark mode is enabled or not. Defaults to `false`
  ///
  /// This is available for the following platforms:
  ///   - Windows
  static Future<bool> get darkMode async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return (await _channel.invokeMethod<bool>(kGetDarkModeMethod)) ?? false;
      default:
        return false;
    }
  }
}

/// Defines accent colors & its variants on Windows.
/// Colors are cached by default, call [SystemAccentColor.load] to the updated colors.
/// 
/// It returns [SystemAccentColor.defaultAccentColor] if `SystemAccentColor.load` fails
class SystemAccentColor {

  final Color defaultAccentColor;

  /// Base accent color.
  late Color accent;

  /// Light shade.
  late Color light;

  /// Lighter shade.
  late Color lighter ;

  /// Lighest shade.
  late Color lightest;

  /// Darkest shade.
  late Color dark ;

  /// Darker shade.
  late Color darker ;

  /// Darkest shade.
  late Color darkest;

  SystemAccentColor(this.defaultAccentColor) {
    accent = defaultAccentColor;
    light = defaultAccentColor;
    lighter = defaultAccentColor;
    lightest = defaultAccentColor;
    dark = defaultAccentColor;
    darker = defaultAccentColor;
    darkest = defaultAccentColor;
  }

  /// Updates the fetched accent colors on Windows.
  Future<void> load() async {
    dynamic colors = await _channel.invokeMethod(kGetSystemAccentColorMethod);
    if (colors == null) return;
    accent = _retrieve(colors['accent']);
    light = _retrieve(colors['light']);
    lighter = _retrieve(colors['lighter']);
    lightest = _retrieve(colors['lightest']);
    dark = _retrieve(colors['dark']);
    darker = _retrieve(colors['darker']);
    darkest = _retrieve(colors['darkest']);
  }

  Color _retrieve(dynamic map) {
    return Color.fromRGBO(
      map['R'],
      map['G'],
      map['B'],
      1.0,
    );
  }
}
