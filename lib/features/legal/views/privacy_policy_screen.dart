import 'package:flutter/material.dart';
import 'package:jay/constants/sizes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  static const routeURL = '/privacy';
  static const routeName = 'privacyPolicy';
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        title: const Text(
          '개인정보 처리방침',
          style: TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Sizes.size20),
        child: _LegalContent(sections: _sections),
      ),
    );
  }

  static const _sections = [
    _Section(
      title: null,
      body:
          '제이(Jay) 서비스(이하 "서비스")는 이용자의 개인정보를 소중히 여기며, 「개인정보 보호법」 등 관련 법령을 준수합니다.\n\n시행일: 2026년 6월 10일',
    ),
    _Section(
      title: '1. 수집하는 개인정보 항목',
      body: '서비스는 다음과 같은 개인정보를 수집합니다.\n\n'
          '• 소셜 로그인(Google/카카오) 연동 시: 이메일 주소\n'
          '• 서비스 이용 시: 닉네임, 작성한 게시글 및 댓글 내용',
    ),
    _Section(
      title: '2. 개인정보 수집 목적',
      body: '• 회원 식별 및 서비스 제공\n'
          '• 커뮤니티 기능 운영(게시글·댓글 작성자 표시)\n'
          '• 서비스 이용 관련 문의 대응',
    ),
    _Section(
      title: '3. 개인정보 보유 및 이용 기간',
      body: '회원 탈퇴 시 지체 없이 파기합니다.\n\n'
          '단, 관련 법령에 의해 보존이 필요한 경우 해당 기간 동안 보관합니다.\n'
          '• 소비자 불만 및 분쟁처리 기록: 3년 (전자상거래법)',
    ),
    _Section(
      title: '4. 개인정보 제3자 제공',
      body: '서비스는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. '
          '다만, 이용자가 사전에 동의한 경우 또는 법령의 규정에 의한 경우에는 예외로 합니다.',
    ),
    _Section(
      title: '5. 개인정보 처리 위탁',
      body: '서비스는 원활한 운영을 위해 아래와 같이 개인정보 처리를 위탁합니다.\n\n'
          '• Supabase Inc.: 데이터베이스 저장 및 인증 서비스 제공\n'
          '• Google LLC: Google 소셜 로그인\n'
          '• Kakao Corp.: 카카오 소셜 로그인',
    ),
    _Section(
      title: '6. 이용자의 권리',
      body: '이용자는 언제든지 다음 권리를 행사할 수 있습니다.\n\n'
          '• 개인정보 열람 요구\n'
          '• 개인정보 정정·삭제 요구\n'
          '• 개인정보 처리 정지 요구\n\n'
          '권리 행사는 앱 내 "회원탈퇴" 기능을 이용하거나, '
          'contact@jaywithme.com으로 문의하시면 처리해 드립니다.',
    ),
    _Section(
      title: '7. 개인정보의 파기',
      body: '보유 기간이 경과하거나 처리 목적이 달성된 개인정보는 지체 없이 파기합니다. '
          '전자적 파일 형태는 복구할 수 없는 방법으로 영구 삭제합니다.',
    ),
    _Section(
      title: '8. 개인정보 보호책임자',
      body: '개인정보 관련 문의, 불만, 피해 구제 등은 아래로 연락하시기 바랍니다.\n\n'
          '이메일: contact@jaywithme.com',
    ),
  ];
}

class TermsOfServiceScreen extends StatelessWidget {
  static const routeURL = '/terms';
  static const routeName = 'termsOfService';
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F8),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xffF3F4F8),
        title: const Text(
          '서비스 이용약관',
          style: TextStyle(
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(Sizes.size20),
        child: _LegalContent(sections: _sections),
      ),
    );
  }

  static const _sections = [
    _Section(
      title: null,
      body: '본 약관은 제이(Jay) 서비스(이하 "서비스") 이용에 관한 조건 및 절차를 규정합니다.\n\n'
          '시행일: 2026년 6월 10일',
    ),
    _Section(
      title: '제1조 (목적)',
      body: '본 약관은 서비스가 제공하는 의료·복지 혜택 정보 제공 및 커뮤니티 서비스의 '
          '이용 조건과 운영자·이용자 간의 권리·의무를 규정함을 목적으로 합니다.',
    ),
    _Section(
      title: '제2조 (서비스 내용)',
      body: '서비스는 다음을 제공합니다.\n\n'
          '• 의료·복지 지원 정책 정보 제공\n'
          '• 커뮤니티 게시글 및 댓글 작성\n'
          '• 기타 운영자가 정하는 부가 서비스',
    ),
    _Section(
      title: '제3조 (회원 가입 및 탈퇴)',
      body: '① 이용자는 Google 또는 카카오 소셜 로그인을 통해 회원으로 가입할 수 있습니다.\n\n'
          '② 회원은 앱 내 "회원탈퇴" 기능을 통해 언제든지 탈퇴할 수 있습니다.\n\n'
          '③ 탈퇴 시 작성한 게시글·댓글을 포함한 모든 데이터는 즉시 삭제됩니다.',
    ),
    _Section(
      title: '제4조 (이용자의 의무)',
      body: '이용자는 다음 행위를 하여서는 안 됩니다.\n\n'
          '• 타인의 정보 도용 및 허위 정보 등록\n'
          '• 서비스 내 타인에 대한 비방, 욕설, 혐오 표현\n'
          '• 영리 목적의 광고·홍보 게시\n'
          '• 저작권 등 타인의 권리 침해\n'
          '• 기타 법령 위반 또는 공서양속에 반하는 행위',
    ),
    _Section(
      title: '제5조 (서비스 변경 및 중단)',
      body: '① 운영자는 서비스 내용을 변경하거나 중단할 수 있습니다.\n\n'
          '② 서비스 중단 시 사전에 공지하며, 불가피한 경우 사후 통지할 수 있습니다.',
    ),
    _Section(
      title: '제6조 (면책 조항)',
      body: '① 서비스에서 제공하는 의료·복지 정보는 참고용이며, '
          '실제 지원 여부는 해당 기관에 직접 확인하시기 바랍니다.\n\n'
          '② 운영자는 천재지변, 서비스 장애 등 불가항력으로 인한 손해에 대해 '
          '책임을 지지 않습니다.\n\n'
          '③ 이용자가 작성한 게시글·댓글의 내용에 대한 책임은 작성자에게 있습니다.',
    ),
    _Section(
      title: '제7조 (분쟁 해결)',
      body: '본 약관과 관련한 분쟁은 대한민국 법령을 적용하며, '
          '분쟁 발생 시 운영자와 이용자가 성실히 협의하여 해결합니다. '
          '협의가 되지 않을 경우 관할 법원에 소를 제기할 수 있습니다.',
    ),
    _Section(
      title: '문의',
      body: 'contact@jaywithme.com',
    ),
  ];
}

class _Section {
  final String? title;
  final String body;
  const _Section({required this.title, required this.body});
}

class _LegalContent extends StatelessWidget {
  final List<_Section> sections;
  const _LegalContent({required this.sections});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in sections) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.size16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.size12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (s.title != null) ...[
                  Text(
                    s.title!,
                    style: const TextStyle(
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Sizes.size10),
                ],
                Text(
                  s.body,
                  style: const TextStyle(
                    fontSize: Sizes.size14,
                    height: 1.7,
                    color: Color(0xff444444),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.size10),
        ],
        const SizedBox(height: Sizes.size20),
      ],
    );
  }
}
