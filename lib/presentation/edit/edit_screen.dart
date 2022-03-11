import 'dart:async';

import 'package:daily_diary/core/util/date_config.dart';
import 'package:daily_diary/presentation/edit/edit_event.dart';
import 'package:daily_diary/presentation/global_components/check_dialog.dart';
import 'package:daily_diary/ui/emotion_data.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dart_date/dart_date.dart';

import 'edit_view_model.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  StreamSubscription? _subscription;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() async {
      final viewModel = context.read<EditViewModel>();

      _subscription = viewModel.uiEventStream.listen((event) {
        event.when(loaded: (content) {
          _textEditingController.text = content;
        }, snackBar: (message) {
          final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating, content: Text(message));

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
    _textEditingController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 18.sp,
            )),
        title: GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: state.selectedDate,
              firstDate: state.selectedDate.startOfYear,
              lastDate: state.selectedDate.endOfYear,
            );

            if (date != null) {
              viewModel.onEvent(EditEvent.changeDate(date));
            }
          },
          child: Text(
            '${state.selectedDate.month}월 ${state.selectedDate.day}일',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        actions: [
          if (!state.isEditMode)
            IconButton(
                onPressed: () async {
                  final result = await showDialog<bool>(
                      context: context,
                      builder: (context) =>
                          const CheckDialog(content: '정말로 삭제하시겠습니까?'));

                  if (result ?? false) {
                    viewModel.onEvent(const EditEvent.delete());
                  }
                },
                icon: const Text('삭제')),
          IconButton(
              onPressed: state.isEditMode
                  ? () {
                      final content = _textEditingController.text;
                      viewModel.onEvent(EditEvent.save(content));
                    }
                  : () {
                      viewModel.onEvent(const EditEvent.modeChange(true));
                    },
              icon: Text(
                state.isEditMode ? '저장' : '수정',
                style: TextStyle(color: Colors.black, fontSize: 16.sp),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.isEditMode
            ? DirectSelectContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DirectSelectList<String>(
                        values: emoLabels,
                        defaultItemIndex: state.emoIndex,
                        onItemSelectedListener: (value, idx, context) {
                          viewModel.onEvent(EditEvent.setEmoData(idx));
                        },
                        itemBuilder: (String value) => DirectSelectItem(
                            itemHeight: 8.h,
                            value: value,
                            itemBuilder: (context, String value) => Row(
                                  children: [
                                    Container(
                                      width: 6.w,
                                      height: 6.w,
                                      color: emoDatas[value],
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(value),
                                    const Spacer(),
                                    const Icon(Icons.unfold_more)
                                  ],
                                ))),
                    Expanded(
                        child: TextFormField(
                      controller: _textEditingController,
                      style: TextStyle(fontSize: 16.sp),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: '새로운 내용을 입력해주세요'),
                      maxLines: null,
                    )),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8.h,
                    child: Row(
                      children: [
                        Container(
                          width: 6.w,
                          height: 6.w,
                          color: emoDatas[emoLabels[state.emoIndex]],
                        ),
                        SizedBox(width: 10.w),
                        Text(emoLabels[state.emoIndex]),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      state.content,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
