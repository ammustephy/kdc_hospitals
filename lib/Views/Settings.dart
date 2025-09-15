import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Home.dart';
import 'Notifications.dart';
import 'Profile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _idx = 2;
  final _secure = const FlutterSecureStorage();

  bool _darkMode = false;
  String _themeMode = 'Light'; // 'Light'/'Dark'/'System'
  bool _notifications = true;
  TimeOfDay _notificationTime = TimeOfDay(hour: 8, minute: 0);
  bool _appLock = false;
  double _fontScale = 1.0;
  String _language = 'English';
  final _languages = ['English', 'Spanish', 'Hindi'];
  final _themes = ['Light', 'Dark', 'System'];

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final dark = await _secure.read(key: 'darkMode') ?? 'false';
    final theme = await _secure.read(key: 'themeMode') ?? 'Light';
    final notif = await _secure.read(key: 'notifications') ?? 'true';
    final notifH = await _secure.read(key: 'notifHour') ?? '8';
    final notifM = await _secure.read(key: 'notifMin') ?? '0';
    final lock = await _secure.read(key: 'appLock') ?? 'false';
    final font = await _secure.read(key: 'fontScale') ?? '1.0';
    final lang = await _secure.read(key: 'language') ?? 'English';
    setState(() {
      _darkMode = dark == 'true';
      _themeMode = theme;
      _notifications = notif == 'true';
      _notificationTime = TimeOfDay(hour: int.parse(notifH), minute: int.parse(notifM));
      _appLock = lock == 'true';
      _fontScale = double.tryParse(font) ?? 1.0;
      _language = lang;
    });
    _applyThemeMode(_themeMode);
  }

  void _applyThemeMode(String mode) {
    switch (mode) {
      case 'Dark':
        AdaptiveTheme.of(context).setDark();
        break;
      case 'System':
        AdaptiveTheme.of(context).setSystem();
        break;
      default:
        AdaptiveTheme.of(context).setLight();
    }
  }

  void _onNav(int i) {
    if (i == _idx) return;
    final nav = [
      const HomePage(),
      const NotificationsPage(),
      const SettingsPage(),
       ProfilePage(),
    ];
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => nav[i]));
    setState(() => _idx = i);
  }

  Future<void> _pickNotificationTime() async {
    final t = await showTimePicker(context: context, initialTime: _notificationTime);
    if (t != null) {
      setState(() => _notificationTime = t);
      await _secure.write(key: 'notifHour', value: t.hour.toString());
      await _secure.write(key: 'notifMin', value: t.minute.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Settings', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SettingsList(
        // backgroundColor: Colors.white,
        sections: [
          SettingsSection(title: const Text('Account'), tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.person),
              title: const Text('Change Username'),
              onPressed: (_) => _showInputDialog('Update Username'),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onPressed: (_) => _showInputDialog('Update Password', obscure: true),
            ),
          ]),
          SettingsSection(title: const Text('App Settings'), tiles: [
            SettingsTile.switchTile(
              initialValue: _appLock,
              leading: const Icon(Icons.fingerprint),
              title: const Text('App Lock'),
              onToggle: (v) {
                setState(() => _appLock = v);
                _secure.write(key: 'appLock', value: v.toString());
              },
            ),
            SettingsTile.switchTile(
              initialValue: _darkMode,
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark Mode'),
              onToggle: (v) {
                setState(() => _darkMode = v);
                _secure.write(key: 'darkMode', value: v.toString());
                if (v) {
                  AdaptiveTheme.of(context).setDark();
                } else {
                  AdaptiveTheme.of(context).setLight();
                }
              },
            ),
            SettingsTile(
              leading: const Icon(Icons.brush),
              title: const Text('Theme Style'),
              value: Text(_themeMode),
              onPressed: (_) => _showOptionDialog('Theme Style', _themes, _themeMode, (s) {
                setState(() => _themeMode = s);
                _secure.write(key: 'themeMode', value: s);
                _applyThemeMode(s);
              }),
            ),
            SettingsTile.switchTile(
              initialValue: _notifications,
              leading: const Icon(Icons.notifications_active),
              title: const Text('Notifications'),
              onToggle: (v) {
                setState(() => _notifications = v);
                _secure.write(key: 'notifications', value: v.toString());
              },
            ),
            SettingsTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Notification Time'),
              value: Text(_notificationTime.format(context)),
              onPressed: (_) => _pickNotificationTime(),
            ),
            SettingsTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Font Size'),
              value: Text('${(_fontScale * 100).toInt()}%'),
              onPressed: (_) => _showSliderDialog(),
            ),
            SettingsTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              value: Text(_language),
              onPressed: (_) => _showOptionDialog('Select Language', _languages, _language, (s) {
                setState(() => _language = s);
                _secure.write(key: 'language', value: s);
              }),
            ),
          ]),
          SettingsSection(tiles: [
            SettingsTile.navigation(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onPressed: (_) => showAboutDialog(
                context: context,
                applicationName: 'Student Academic App',
                applicationVersion: '1.0.0',
              ),
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.restore),
              title: const Text('Reset Settings'),
              onPressed: (_) async {
                await _secure.deleteAll();
                _loadPrefs();
              },
            ),
          ]),
        ],
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PhysicalShape(
          elevation: 10,
          color: Colors.white,
          shadowColor: Colors.black38,
          clipper: const ShapeBorderClipper(shape: StadiumBorder()),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const ShapeDecoration(shape: StadiumBorder(), color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (i) {
                const icons = [
                  Icons.home_filled,
                  Icons.notifications_active,
                  Icons.settings,
                  Icons.person_outline,
                ];
                final active = _idx == i;
                return IconButton(
                  icon: Icon(icons[i], color: active ? Colors.black : Colors.grey),
                  onPressed: () => _onNav(i),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _showInputDialog(String title, {bool obscure = false}) { /* same as before */ }

  void _showOptionDialog(String title, List<String> options, String selected, ValueChanged<String> onSelect) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((o) => RadioListTile(
            title: Text(o),
            value: o,
            groupValue: selected,
            onChanged: (v) {
              onSelect(v as String);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showSliderDialog() {
    double v = _fontScale;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Font Size'),
        content: StatefulBuilder(
          builder: (c, s) => Slider(
            min: 0.8, max: 1.5, divisions: 7, value: v,
            label: '${(v*100).toInt()}%',
            onChanged: (nv) => s(() => v = nv),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () {
            setState(() => _fontScale = v);
            _secure.write(key: 'fontScale', value: v.toString());
            Navigator.pop(context);
          }, child: const Text('Save')),
        ],
      ),
    );
  }
}
