// import 'package:hive_flutter/hive_flutter.dart';

// class HiveService {
//   Box</*모델*/>? _searchBox;
//   Box</*모델*/>? get searchBox => _searchBox;

//   HiveService._();

//   static final HiveService _instance = HiveService._();
//   static HiveService get instance => _instance;

//   Future<void> init() async {
//     await Hive.initFlutter();
//     // await Hive.deleteFromDisk(); // TODO: 삭제 코드 (임시)
//     Hive.registerAdapter(/*모델 어댑터*/());

//     _searchBox = await Hive.openBox</*모델*/>('search_history');
//     // _searchBox?.clear(); // 박스 값들 삭제
//   }
// }
