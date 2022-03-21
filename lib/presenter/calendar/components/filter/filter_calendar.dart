import 'dart:async';

import 'package:daily_diary/domain/usecase/diary/delete_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/load_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/save_diary_use_case.dart';
import 'package:daily_diary/domain/usecase/diary/update_diary_use_case.dart';
import 'package:daily_diary/presenter/edit/edit_screen.dart';
import 'package:daily_diary/presenter/edit/edit_view_model.dart';
import 'package:dart_date/dart_date.dart';
import 'package:daily_diary/presenter/calendar/components/filter/filter_event.dart';
import 'package:daily_diary/presenter/calendar/components/filter/filter_view_model.dart';
import 'package:daily_diary/ui/emotion_data.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

class FilterCalendar extends StatefulWidget {
  const FilterCalendar({Key? key}) : super(key: key);

  @override
  State<FilterCalendar> createState() => _FilterCalendarState();
}

class _FilterCalendarState extends State<FilterCalendar> {
  final _textEditingController = TextEditingController();
  StreamSubscription? _streamSubscription;
  Timer? _debounce;

  // 디바운싱 처리
  void onQueryChanged(
      {required ValueChanged<String> loadDiaries, required String query}) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce =
        Timer(const Duration(milliseconds: 500), () => loadDiaries(query));
  }

  @override
  void initState() {
    Future.microtask(() {
      final viewModel = context.read<FilterViewModel>();

      _streamSubscription = viewModel.uiEventStream.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(content: Text(message));

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _textEditingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<FilterViewModel>();
    final state = viewModel.state;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: '찾고자 하는 단어를 입력하세요',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        onQueryChanged(
                          loadDiaries: (String query) {
                            viewModel.onEvent(FilterEvent.load(query));
                          },
                          query: value,
                        );
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        final query = _textEditingController.text;
                        viewModel.onEvent(FilterEvent.load(query));
                      },
                      icon: const Icon(Icons.search)),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(
              height: 7.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ...emoDatas.entries
                      .map(
                        (entry) => InkWell(
                          onTap: () {
                            final emoIndex = emoLabels.indexOf(entry.key);
                            viewModel.onEvent(FilterEvent.changeEmo(emoIndex));
                          },
                          borderRadius: BorderRadius.circular(10.h),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: entry.key == emoLabels[state.selectedIndex]
                                ? 7.h
                                : 5.h,
                            width: entry.key == emoLabels[state.selectedIndex]
                                ? 7.h
                                : 5.h,
                            decoration: BoxDecoration(
                                color: entry.value,
                                borderRadius: BorderRadius.circular(7.h)),
                            child: Icon(
                              emoIcons[entry.key],
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Expanded(
                child: RefreshIndicator(
              onRefresh: () async {
                final query = _textEditingController.text;

                viewModel.onEvent(FilterEvent.load(query));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: state.diaries
                      .map(
                        (diary) => SizedBox(
                          height: 8.h,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (context) => EditViewModel(
                                      context.read<SaveDiaryUseCase>(),
                                      context.read<UpdateDiaryUseCase>(),
                                      context.read<LoadDiaryUseCase>(),
                                      context.read<DeleteDiaryUseCase>(),
                                      diary.date,
                                    ),
                                    child: const EditScreen(),
                                  ),
                                ))
                                    .then((_) {
                                  final query = _textEditingController.text;
                                  viewModel.onEvent(FilterEvent.load(query));
                                });
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color:
                                          emoDatas[emoLabels[diary.emoIndex]],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 12,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(diary.date.format('y년 M월 d일')),
                                          Text(
                                            diary.content,
                                            overflow: TextOverflow.visible,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )),
          ],
        ),
        if (state.isLoading)
          Container(
            color: Colors.transparent,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }
}
