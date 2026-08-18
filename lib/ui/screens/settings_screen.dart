import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _accent = Color(0xFF55DEFF);
  static final _studioWebsite = Uri.parse(
    'https://sunkeeper316.github.io/sunkeeper_studio_website/',
  );

  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.buildNumber.isEmpty
          ? packageInfo.version
          : '${packageInfo.version} (${packageInfo.buildNumber})';
      if (mounted) setState(() => _appVersion = version);
    } catch (_) {
      if (mounted) setState(() => _appVersion = '-');
    }
  }

  Future<void> _contactUs() async {
    final launched = await launchUrl(
      _studioWebsite,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('目前無法開啟聯絡頁面')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF020817),
    appBar: AppBar(
      title: const Text('設定'),
      backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xFFEAFBFF),
    ),
    body: ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        const _SectionTitle(title: '關於'),
        _SettingsTile(
          icon: Icons.info_outline,
          title: '版本',
          subtitle: _appVersion,
        ),
        _SettingsTile(
          icon: Icons.mail_outline,
          title: '聯絡我們',
          onTap: _contactUs,
        ),
        _SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: '隱私權政策與服務條款',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const PrivacyPolicyScreen(),
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Center(
          child: Text(
            'ThunderForce',
            style: TextStyle(
              color: _accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 3,
            ),
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Text(
      title,
      style: const TextStyle(
        color: Color(0xFF9BDDF4),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  );
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    leading: Icon(icon, color: const Color(0xFF9BDDF4)),
    title: Text(title, style: const TextStyle(color: Color(0xFFEAFBFF))),
    subtitle: subtitle == null
        ? null
        : Text(subtitle!, style: const TextStyle(color: Color(0xFF9BB7C5))),
    trailing: onTap == null
        ? null
        : const Icon(Icons.chevron_right, color: Color(0x889BDDF4)),
  );
}
