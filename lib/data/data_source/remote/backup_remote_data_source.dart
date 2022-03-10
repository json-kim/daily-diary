import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:uuid/uuid.dart';

class BackupRemoteDataSource {
  Uuid _uuid = Uuid();

  Future<Result<int>> saveBackup(BackupData backupData) async {
    final Map<String, dynamic> backupJson = backupData.toJson(); // Map 형식으로 변환
    final jsonString = jsonEncode(backupJson); // json 문자열로 변환

    final file = await convertToFile(jsonString); // File로 변환

    final url = await saveBackupData(file);

    await saveBackupItem(url);
  }

  Future<File> convertToFile(String data) async {
    Uint8List _buffer = Uint8List(256);

    int _offset = 0;

    final encoder = Utf8Encoder();

    final bytes = encoder.convert(data);

    final length = bytes.length;

    // 버퍼 남은 공간이 부족할 경우, 크기 확장한 버퍼 변경
    if (_buffer.length - _offset < length) {
      final newSize = _offset + length;
      final newBuffer = Uint8List(newSize);
      newBuffer.setRange(0, _offset, _buffer);
      _buffer = newBuffer;
    }

    // 버퍼에 데이터 추가
    _buffer.setRange(_offset, _offset + length, bytes);
    _offset += length;

    // 출력할 버퍼 : 입력된 크기만큼 버퍼 자르기
    final resultBuffer = Uint8List.view(_buffer.buffer, 0, _offset);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    final tempFile = File(resultBuffer, '$path/temp.file');

    return tempFile;
  }

  Future<void> saveBackupItem(String url) async {}

  Future<String> saveBackupData(File file) async {}
}
