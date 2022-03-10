import 'dart:io';

import 'package:daily_diary/data/data_source/remote/backup_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('파일 변환 테스트합니다.', () async {
    WidgetsFlutterBinding.ensureInitialized();
    final remoteDataSource = BackupRemoteDataSource();

    String inputString = [for (int i = 0; i < 10000; i++) 'hello'].join();

    // final file = await remoteDataSource.convertToFile(inputString);

    // final fileToList = await file.readAsBytes();
    // final length1 = await file.length();

    // final readList = await file.readAsBytes();
    // final unZippedList = gzip.decode(readList);
    // String readString = String.fromCharCodes(unZippedList);

    // print(readString);

    // await file.delete();

    // final file2 = File('temp2.file');

    // await file2.writeAsString(inputString);
    // final length2 = await file2.length();

    // print('$length1 / $length2');
  });
}
