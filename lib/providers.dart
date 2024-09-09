import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitly/data/repositories/memory_repository.dart';

final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final repositoryProvider = ChangeNotifierProvider<MemoryRepository>((ref) {
  return MemoryRepository();
});
