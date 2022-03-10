import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_diary/domain/model/backup/backup_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:daily_diary/domain/model/backup/backup_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class BackupRemoteDataSource {
  Uuid _uuid = Uuid(); // uuid 생성 객체

  /// 현재 인증된 유저의 uid 리턴
  String _getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // User == null 이면 에러
      throw Exception('로그인 필요');
    }

    return currentUser.uid;
  }

  /// 백업 데이터 서버에 저장
  Future<Result<int>> saveBackup(BackupData backupData) async {
    final Map<String, dynamic> backupJson = backupData.toJson(); // Map 형식으로 변환
    final jsonString = jsonEncode(backupJson); // json 문자열로 변환

    final file = await _convertToFile(jsonString); // File로 변환

    final url = await _saveBackupData(file); // File 서버에 저장

    await _saveBackupItem(url); // nosql 서버에 저장

    return const Result.success(1);
  }

  /// 문자열 데이터 압축된 파일로 변환
  Future<File> _convertToFile(String data) async {
    Uint8List _buffer = Uint8List(256); // 초기 버퍼

    int _offset = 0; // 버퍼 입력 위치

    final encoder = Utf8Encoder(); // utf인코더

    final bytes = encoder.convert(data); // String -> uint8List

    final length = bytes.length; // 버퍼 길이

    // 버퍼 남은 공간이 부족할 경우, 크기 확장한 버퍼 변경
    if (_buffer.length - _offset < length) {
      final newSize = _offset + length;
      final newBuffer = Uint8List(newSize);
      newBuffer.setRange(0, _offset, _buffer);
      _buffer = newBuffer;
    }

    _buffer.setRange(_offset, _offset + length, bytes); // 버퍼에 데이터 추가
    _offset += length;

    final resultBuffer =
        Uint8List.view(_buffer.buffer, 0, _offset); // 출력할 버퍼 : 입력된 크기만큼 버퍼 자르기

    final zippedBuffer = gzip.encode(resultBuffer); // 버퍼 압축

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    final tempFile = File('$path/temp.file');
    tempFile.writeAsBytes(zippedBuffer);
    tempFile.create();

    return tempFile;
  }

  /// 백업 데이터 파일 파이어스토리지에 저장
  Future<String> _saveBackupData(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance; // 파이어스토리지

    String fileName = 'backup/${_uuid.v1()}.file'; // 저장될 파일 경로
    Reference ref = storage.ref(_uuid.v1()); // 파일 레퍼런스(파일명)
    await ref.putFile(file); // 파일 업로드

    final String downLoadUrl = await ref.getDownloadURL(); // 파일 url 가져오기

    await file.delete(); // 임시 파일은 삭제

    return downLoadUrl; // url 리턴
  }

  /// 백업파일url을 담은 클래스 파이어스토어에 저장
  Future<void> _saveBackupItem(String url) async {
    // 백업 데이터
    final newBackupItem = BackupItem(
      id: _uuid.v1(),
      url: url,
      uploadDate: DateTime.now(),
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance; // 파이어스토어

    final userCollection = firestore.collection('users'); // users 컬렉션

    String uid = _getUid(); // 유저 id 가져오기

    final backupCollection =
        userCollection.doc(uid).collection('backups'); // users/$uid/backups 컬렉션

    await backupCollection
        .add(newBackupItem.toJson()); // backups 컬렉션에 백업 데이터 추가
  }
}
