import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';

class FriendUtils {
  // Function to retrieve the selected friend from the repository
  static FriendProfile? getSelectedFriend(WidgetRef ref) {
    return ref.watch(repositoryProvider).selectedFriend;
  }

  static String getSelectedFriendId(WidgetRef ref) {
    final selectedFriend = ref.watch(repositoryProvider).selectedFriend;

    if (selectedFriend == null) {
      throw Exception("No selected friend ID found");
    }

    return selectedFriend.id;
  }

  // Function to fetch current friend expenses
  static List<Expense> getSelectedFriendExpenses(WidgetRef ref) {
    final repository = ref.read(repositoryProvider.notifier);
    String friendId = getSelectedFriendId(ref);

    return repository.findFriendExpenses(friendId);
  }
}
