import 'package:daily_diary/presentation/calendar/calendar_event.dart';
import 'package:daily_diary/presentation/calendar/calendar_view_model.dart';
import 'package:daily_diary/presentation/calendar/components/drawer_button.dart';
import 'package:daily_diary/presentation/global_components/check_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RightDrawer extends StatelessWidget {
  const RightDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CalendarViewModel>();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '로그아웃',
                icon: const Icon(Icons.logout),
                onTap: () {},
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '서버에 백업하기',
                icon: const Icon(Icons.north_east),
                onTap: () {},
              ),
              const Divider(color: Colors.black, height: 0),
              DrawerButton(
                title: '백업 불러오기',
                icon: const Icon(Icons.south_west),
                onTap: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
