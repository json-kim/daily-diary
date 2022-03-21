import 'package:daily_diary/core/error/app_exception.dart';
import 'package:daily_diary/core/error/auth_exception.dart';
import 'package:daily_diary/core/error/local_db_exception.dart';
import 'package:daily_diary/core/result/result.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqlite_api.dart';

import 'remote_api_exception.dart';

class ErrorApi {
  /// 로컬 db 처리시 발생하는 에러 핸들러
  static Future<Result<T>> handleLocalDbError<T>(
      Future<Result<T>> Function() requestFunction,
      Logger logger,
      String prefix) async {
    try {
      return await requestFunction();
    } on DatabaseException catch (e) {
      logger.e('$prefix: ${e.runtimeType}: db 사용시 에러 발생 \n', e);
      return Result.error(e);
    } on LocalDbException catch (e) {
      if (e.errorCause != DbErrorCause.EMPTY) {
        logger.e('$prefix: ${e.message} \n ${e.runtimeType} \n', e);
      }
      return Result.error(e);
    } on AuthException catch (e) {
      logger.e('$prefix: ${e.message} \n ${e.runtimeType} \n', e);
      return Result.error(e);
    } on Exception catch (e) {
      logger.e('$prefix: ${e.runtimeType}: db 사용시 에러 발생 \n', e);
      return Result.error(e);
    } catch (e) {
      logger.e('$prefix: ${e.runtimeType}: db 사용시 에러 발생 \n', e);
      return Result.error(AppException('Unknow Exception'));
    }
  }

  /// 파이어베이스 api 사용시 발생하는 에러 핸들러
  static Future<Result<T>> handleRemoteApiError<T>(
      Future<Result<T>> Function() requestFunction,
      Logger logger,
      String prefix) async {
    try {
      return await requestFunction();
    } on FirebaseException catch (e) {
      logger.e('$prefix: ${e.runtimeType}: 파이어베이스 사용시 에러 발생 \n', e);
      return Result.error(e);
    } on RemoteApiException catch (e) {
      logger.e('$prefix: ${e.runtimeType}\n ${e.message}\n ', e);
      return Result.error(e);
    } on AuthException catch (e) {
      logger.e('$prefix: ${e.message} \n ${e.runtimeType} \n', e);
      return Result.error(e);
    } on Exception catch (e) {
      logger.e('$prefix: ${e.runtimeType}: 파이어베이스 사용시 에러 발생 \n', e);
      return Result.error(e);
    } catch (e) {
      logger.e('$prefix: ${e.runtimeType}: 파이어베이스 사용시 에러 발생 \n', e);
      return Result.error(AppException('Unknow Exception'));
    }
  }
}
