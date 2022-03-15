import 'dart:async';

import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:daily_diary/domain/usecase/diary/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_all_use_case.dart';
import 'package:daily_diary/presenter/calendar/calendar_event.dart';
import 'package:daily_diary/presenter/calendar/calendar_state.dart';
import 'package:daily_diary/presenter/calendar/components/backup_dialog.dart';
import 'package:daily_diary/presenter/calendar/components/filter/filter_calendar.dart';
import 'package:daily_diary/presenter/calendar/components/filter/filter_view_model.dart';
import 'package:daily_diary/presenter/calendar/components/month_calendar.dart';
import 'package:daily_diary/presenter/calendar/components/year_calendar.dart';
import 'package:daily_diary/presenter/global_components/check_dialog.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:daily_diary/presenter/calendar/components/right_darwer.dart';
import 'package:daily_diary/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

import 'calendar_view_model.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  GlobalKey<InnerDrawerState> _innerDrawerKey = GlobalKey<InnerDrawerState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
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

          _scaffoldMessengerKey.currentState
            ?..hideCurrentMaterialBanner()
            ..showSnackBar(snackBar);
        }, showBackupList: (backupList) {
          final dialog = BackupDialog(
            backupList: backupList,
            onTap: (BackupItem item) {
              viewModel.onEvent(CalendarEvent.restoreBackupData(item));
              Navigator.pop(context);
            },
            onDeleteTap: (BackupItem item) async {
              final result = await showDialog(
                context: context,
                builder: (context) =>
                    const CheckDialog(content: '정말로 삭제하시겠습니까?'),
              );

              if (result ?? false) {
                viewModel.onEvent(CalendarEvent.deleteBackupData(item));
                Navigator.pop(context);
              }
            },
          );

          showDialog(
            context: context,
            builder: (context) => dialog,
          );
        }, toggleDrawer: (isOpen) {
          if (isOpen) {
            _innerDrawerKey.currentState?.open();
          } else {
            _innerDrawerKey.currentState?.close();
          }
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

    return Stack(
      children: [
        InnerDrawer(
          key: _innerDrawerKey,
          rightChild: const RightDrawer(),
          onTapClose: true,
          backgroundDecoration: const BoxDecoration(color: Colors.white),
          scaffold: ScaffoldMessenger(
            key: _scaffoldMessengerKey,
            child: Scaffold(
              backgroundColor: whiteColor,
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                title: Image.asset(
                  'asset/image/title_transparent.png',
                  width: 30.w,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        _innerDrawerKey.currentState?.toggle();
                      },
                      icon: const Icon(Icons.menu))
                ],
              ),
              body: _buildBody(state.calendarMode),
            ),
          ),
        ),
        if (state.isLoading)
          Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: const CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildBody(CalendarMode calendarMode) {
    switch (calendarMode) {
      case CalendarMode.year:
        return const YearCalendar();
      case CalendarMode.month:
        return const MonthCalendar();
      default:
        return ChangeNotifierProvider<FilterViewModel>(
          create: (context) => FilterViewModel(context.read<LoadAllUseCase>()),
          child: const FilterCalendar(),
        );
    }
  }
}
