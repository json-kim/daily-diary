import 'package:daily_diary/core/constants/app_config.dart';
import 'package:daily_diary/service/package_info_service.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  final PackageInfoService packageInfoService;

  const InfoScreen({required this.packageInfoService, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로그램 정보'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Image.asset(
              'asset/image/logo_transparent.png',
              width: 60.w,
            ),
            Text('현재 버전 ${packageInfoService.packageInfo.version}'),
            const Spacer(
              flex: 1,
            ),
            const Divider(height: 0),
            InkWell(
              onTap: () {
                showAboutDialog(
                    applicationIcon: Image.asset(
                      'asset/image/logo_transparent.png',
                      width: 12.w,
                    ),
                    applicationName: '달력 일기',
                    applicationVersion: packageInfoService.packageInfo.version,
                    context: context);
              },
              child: Container(
                height: 8.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('오픈소스 라이선스'),
              ),
            ),
            const Divider(height: 0),
            InkWell(
              onTap: () {
                launch(privacyPolicyUrl);
              },
              child: Container(
                height: 8.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('개인정보 처리방침'),
              ),
            ),
            const Divider(height: 0),
            const Spacer(
              flex: 6,
            ),
            const Text('jsonKim.dev Limited.'),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
