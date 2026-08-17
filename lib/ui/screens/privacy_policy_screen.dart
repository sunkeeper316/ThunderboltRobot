import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF020817),
    appBar: AppBar(
      title: const Text('隱私權政策'),
      backgroundColor: Colors.transparent,
      foregroundColor: const Color(0xFFEAFBFF),
    ),
    body: const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最後更新日期：2026 年 8 月 17 日',
            style: TextStyle(color: Color(0xFF9BB7C5)),
          ),
          SizedBox(height: 24),
          _PolicySection(
            title: '資料收集',
            body: 'Thunderbolt 不會要求建立帳號，也不會收集姓名、電子郵件、位置、聯絡人或其他可識別個人身分的資料。',
          ),
          _PolicySection(
            title: '本機遊戲資料',
            body:
                'App 會在您的裝置上保存關卡解鎖進度，以便下次繼續遊戲。這些資料不會傳送至開發者或第三方伺服器。刪除 App 通常也會移除這些本機資料。',
          ),
          _PolicySection(
            title: '第三方服務',
            body: 'Thunderbolt 目前不使用廣告、行為分析、追蹤技術或第三方登入服務，也不會出售或分享個人資料。',
          ),
          _PolicySection(title: '兒童隱私', body: '本 App 不會刻意收集兒童或其他使用者的個人資料。'),
          _PolicySection(
            title: '政策更新',
            body: '若 App 功能或資料處理方式有所變更，本政策將同步更新，並標示新的更新日期。',
          ),
        ],
      ),
    ),
  );
}

class _PolicySection extends StatelessWidget {
  const _PolicySection({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF55DEFF),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: const TextStyle(
            color: Color(0xFFD5E8EF),
            fontSize: 15,
            height: 1.7,
          ),
        ),
      ],
    ),
  );
}
