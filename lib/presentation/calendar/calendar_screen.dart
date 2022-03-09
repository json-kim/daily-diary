import 'dart:async';

import 'package:daily_diary/domain/usecase/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/load_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/save_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/update_diary_use_case.dart';
import 'package:daily_diary/presentation/calendar/calendar_event.dart';
import 'package:daily_diary/presentation/calendar/components/daily_box.dart';
import 'package:daily_diary/presentation/calendar/components/right_darwer.dart';
import 'package:daily_diary/presentation/edit/edit_screen.dart';
import 'package:daily_diary/presentation/edit/edit_view_model.dart';
import 'package:daily_diary/ui/colors.dart';
import 'package:daily_diary/ui/emotion_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dart_date/dart_date.dart';

import 'calendar_view_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    Future.microtask(() async {
      final viewModel = context.read<CalendarViewModel>();
      _subscription = viewModel.uiEventStream.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(message),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(snackBar);
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarViewModel>();
    final state = viewModel.state;
    final dates = viewModel.dates;

    return InnerDrawer(
      key: _innerDrawerKey,
      rightChild: const RightDrawer(),
      onTapClose: true,
      backgroundDecoration: const BoxDecoration(color: Colors.white),
      scaffold: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Calendar Diary'),
          actions: [
            IconButton(
                onPressed: () {
                  _innerDrawerKey.currentState?.toggle();
                },
                icon: const Icon(Icons.menu))
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 8.h,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  IconButton(
                    onPressed: () {
                      viewModel.onEvent(const CalendarEvent.changeYear(false));
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: Text(
                    state.currentDate.year.toString(),
                    style: TextStyle(fontSize: 16.sp),
                  ))),
                  IconButton(
                    onPressed: () {
                      viewModel.onEvent(const CalendarEvent.changeYear(true));
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: Colors.black,
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: List.generate(
                    14,
                    (index) => Expanded(
                            child: Center(
                          child: index == 0 || index == 13
                              ? Container()
                              : Text(index.toString()),
                        ))),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
              child: RefreshIndicator(
                  onRefresh: () async {
                    viewModel.onEvent(const CalendarEvent.load());
                  },
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 14,
                            childAspectRatio: 1,
                            crossAxisSpacing: 1,
                            mainAxisSpacing: 1,
                          ),
                          itemCount: 434,
                          itemBuilder: (context, idx) => GestureDetector(
                              child: _buildDailyBox(
                            idx,
                            dates,
                            viewModel,
                          )),
                        )),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildDailyBox(
    int idx,
    List<int> dates,
    CalendarViewModel viewModel,
  ) {
    final diaries = viewModel.state.diaries;
    Color color = defaultBoxColor;
    String? label;
    DateTime? date;
    Function()? onTap;
    int month = idx % 14;
    int day = idx ~/ 14 + 1;

    if (month == 0) {
      // 날짜 박스
      color = whiteColor;
      label = day.toString();
    } else if (month == 13 || day > dates[month - 1]) {
      // 31일 아닌 달 박스 채우기
      color = whiteColor;
    } else {
      date = DateTime(viewModel.state.currentDate.year, month, day);

      if (diaries.any((diary) => diary.date.isSameDay(date!))) {
        final diary =
            diaries.firstWhere((diary) => diary.date.isSameDay(date!));

        color = emoDatas[emoLabels[diary.emoIndex]]!;
      }

      onTap = () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => EditViewModel(
              context.read<SaveDiaryUseCase>(),
              context.read<UpdateDiaryUseCase>(),
              context.read<LoadDiaryUseCase>(),
              context.read<DeleteDiaryUseCase>(),
              date!,
            ),
            child: const EditScreen(),
          ),
        ))
            .then((_) {
          viewModel.onEvent(const CalendarEvent.load());
        });
      };
    }

    return DailyBox(date: date, label: label, color: color, onTap: onTap);
  }
}
