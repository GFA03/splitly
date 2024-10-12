import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitly/data/models/current_friend_data.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/data/repositories/memory_repository.dart';
import 'package:splitly/ui/main_screen_state.dart';
import 'package:splitly/ui/views/balance/profile_picture_notifier.dart';
import 'package:splitly/utils/friend_utils.dart';

final sharedPrefProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final bottomNavigationProvider =
    StateNotifierProvider<MainScreenStateProvider, MainScreenState>((ref) {
  return MainScreenStateProvider();
});

final selectedFriendProvider =
    StateNotifierProvider<SelectedFriendNotifier, FriendProfile?>((ref) {
  return SelectedFriendNotifier();
});

final repositoryProvider =
    NotifierProvider<MemoryRepository, CurrentFriendData>(() {
  return MemoryRepository();
});

final profilePictureProvider = StateNotifierProvider<ProfilePictureNotifier, String>(
      (ref) {
    final prefs = ref.read(sharedPrefProvider);
    final initialProfilePicture = prefs.getString('myProfilePicture') ?? FriendUtils.unknownProfilePicture;
    return ProfilePictureNotifier(initialProfilePicture);
  },
);
