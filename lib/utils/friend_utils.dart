import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';

class FriendUtils {
  static const String unknownProfilePicture =
      'assets/profile_pics/profile_picture6.jpg';

  static const String defaultProfileImage =
      'assets/profile_pics/profile_picture1.jpg';

  // Function to retrieve selected friend's id
  static String getSelectedFriendId(WidgetRef ref) {
    final selectedFriendId =
        ref.read(sharedPrefProvider).getString('selectedFriendId');

    if (selectedFriendId == null) {
      throw Exception("No selected friend ID found");
    }

    return selectedFriendId;
  }

  static void setSelectedFriendId(WidgetRef ref, String id) {
    ref.read(sharedPrefProvider).setString('selectedFriendId', id);
  }

  static Future<FriendProfile?> getSelectedFriend(WidgetRef ref) {
    String selectedFriendId = getSelectedFriendId(ref);
    final repository = ref.read(repositoryProvider.notifier);
    return repository.findFriendById(selectedFriendId);
  }

  // Function to fetch current friend expenses
  static Future<List<Expense>> getSelectedFriendExpenses(WidgetRef ref) {
    String friendId = getSelectedFriendId(ref);
    final repository = ref.read(repositoryProvider.notifier);

    return repository.findFriendExpenses(friendId);
  }
}
