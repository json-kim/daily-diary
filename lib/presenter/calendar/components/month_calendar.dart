import 'package:daily_diary/core/util/date_config.dart';
import 'package:daily_diary/domain/usecase/diary/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/save_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/update_diary_use_case.dart';
import 'package:daily_diary/presenter/calendar/calendar_event.dart';
import 'package:daily_diary/presenter/calendar/calendar_view_model.dart';
import 'package:daily_diary/presenter/calendar/components/daily_box.dart';
import 'package:daily_diary/presenter/edit/edit_screen.dart';
import 'package:daily_diary/presenter/edit/edit_view_model.dart';
import 'package:daily_diary/ui/colors.dart';
import 'package:daily_diary/ui/emotion_data.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dart_date/dart_date.dart';

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarViewModel>();
    final state = viewModel.state;
    final startPoint = viewModel.startDurationOfMonth;

    return Column(
      children: [
        SizedBox(
          height: 8.h,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              IconButton(
                onPressed: () {
                  viewModel.onEvent(const CalendarEvent.changeMonth(false));
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
                state.currentDate.format('y년 M월'),
                style: TextStyle(fontSize: 16.sp),
              ))),
              IconButton(
                onPressed: () {
                  viewModel.onEvent(const CalendarEvent.changeMonth(true));
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: List.generate(
              7,
              (index) => Expanded(
                child: Center(
                  child: Text(dateEstring[index]),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: RefreshIndicator(
              onRefresh: () async {
                viewModel.onEvent(const CalendarEvent.load());
              },
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: startPoint + state.currentDate.getDaysInMonth,
                itemBuilder: (context, index) => _buildDailyBoxInMonth(
                  startPoint,
                  index,
                  viewModel,
                  context,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyBoxInMonth(
    int startPoint,
    int idx,
    CalendarViewModel viewModel,
    BuildContext context,
  ) {
    final diaries = viewModel.state.diaries;
    Color color = defaultBoxColor;
    DateTime? date;
    Function()? onTap;

    if (idx < startPoint) {
      color = whiteColor;
    } else {
      date = viewModel.state.currentDate.startOfMonth.addDays(idx - startPoint);

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

    return Column(
      children: [
        if (date != null) Text(date.day.toString()),
        Expanded(child: DailyBox(date: date, color: color, onTap: onTap)),
      ],
    );
  }
}
