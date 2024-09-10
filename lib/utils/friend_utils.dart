import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';

class FriendUtils {
  // Function to retrieve the selected friend from the repository
  static FriendProfile getSelectedFriend(WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');

    if (currentFriendId == null) {
      throw Exception("No selected friend found");
    }

    return repository.findFriendById(currentFriendId);
  }

  // Function to fetch the friend ID
  static String getSelectedFriendId(WidgetRef ref) {
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');

    if (currentFriendId == null) {
      throw Exception("No selected friend ID found");
    }

    return currentFriendId;
  }

  // Function to fetch current friend expenses
  static List<Expense> getSelectedFriendExpenses(WidgetRef ref) {
    final repository = ref.watch(repositoryProvider);
    String friendId = getSelectedFriendId(ref);

    return repository.findFriendExpenses(friendId);
  }
}
