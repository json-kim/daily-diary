import 'package:daily_diary/presenter/analytics/analytics_screen.dart';
import 'package:daily_diary/presenter/auth/auth_view_model.dart';
import 'package:daily_diary/presenter/calendar/calendar_event.dart';
import 'package:daily_diary/presenter/calendar/calendar_state.dart';
import 'package:daily_diary/presenter/calendar/calendar_view_model.dart';
import 'package:daily_diary/presenter/calendar/components/drawer_button.dart';
import 'package:daily_diary/presenter/global_components/check_dialog.dart';
import 'package:daily_diary/presenter/info/info_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarViewModel>();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              DrawerButton(
                title: '연간 달력 보기',
                icon: const Icon(Icons.calendar_month),
                onTap: () {
                  viewModel.onEvent(
                      const CalendarEvent.changeMode(CalendarMode.year));
                },
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '월간 달력 보기',
                icon: const Icon(Icons.calendar_month),
                onTap: () {
                  viewModel.onEvent(
                      const CalendarEvent.changeMode(CalendarMode.month));
                },
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '빠른 찾기',
                icon: const Icon(
                  Icons.emoji_emotions_outlined,
                ),
                onTap: () {
                  viewModel.onEvent(
                      const CalendarEvent.changeMode(CalendarMode.filter));
                },
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '서버에 백업하기',
                icon: const Icon(Icons.north_east),
                onTap: () {
                  viewModel.onEvent(const CalendarEvent.backup());
                },
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '백업 불러오기',
                icon: const Icon(Icons.south_west),
                onTap: () {
                  viewModel.onEvent(const CalendarEvent.loadBackupList());
                },
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '리셋하기',
                icon: const Icon(Icons.delete),
                onTap: () async {
                  final result = await showDialog<bool>(
                      context: context,
                      builder: (context) =>
                          const CheckDialog(content: '정말로 리셋하시겠습니까?'));

                  if (result ?? false) {
                    viewModel.onEvent(const CalendarEvent.reset());
                  }
                },
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '로그아웃',
                icon: const Icon(Icons.logout),
                onTap: () {
                  context.read<AuthViewModel>().signOut();
                },
              ),
              const Divider(color: Colors.black, height: 0),
              const Spacer(),
              DrawerButton(
                title: '앱 정보',
                icon: const Icon(Icons.settings),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const InfoScreen(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.black, height: 0),
              const Spacer(),
              Image.asset(
                'asset/image/title_transparent.png',
                width: 30.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
