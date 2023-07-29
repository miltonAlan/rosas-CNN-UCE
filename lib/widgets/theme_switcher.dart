import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeMode>(
      builder: (context, themeMode, _) {
        return IconButton(
          icon: themeMode == ThemeMode.light
              ? Icon(Icons.wb_sunny)
              : Icon(Icons.nightlight_round),
          onPressed: () {
            // Toggle theme between light and dark
            final isDarkMode = themeMode == ThemeMode.light ? true : false;
            final newThemeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
            final brightness = isDarkMode ? Brightness.light : Brightness.dark;
            SchedulerBinding.instance!.addPostFrameCallback((_) {
              Provider.of<ThemeModeNotifier>(context, listen: false)
                  .setThemeMode(newThemeMode, brightness);
            });
          },
        );
      },
    );
  }
}

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Brightness _brightness = Brightness.light;

  ThemeMode get themeMode => _themeMode;
  Brightness get brightness => _brightness;

  void setThemeMode(ThemeMode themeMode, Brightness brightness) {
    _themeMode = themeMode;
    _brightness = brightness;
    notifyListeners();
  }
}
