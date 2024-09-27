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
  static FriendProfile? getSelectedFriend(WidgetRef ref) {
    final selectedFriend =
        ref.watch(selectedFriendProvider);

    return selectedFriend;
  }

  static void setSelectedFriend(WidgetRef ref, FriendProfile friend) {
    ref.read(selectedFriendProvider.notifier).setSelectedFriend(friend);
  }

  // Function to fetch current friend expenses
  static Future<List<Expense>> getSelectedFriendExpenses(WidgetRef ref) {
    final selectedFriend = getSelectedFriend(ref);

    if (selectedFriend == null) {
      throw Exception('No friend selected!');
    }

    final repository = ref.read(repositoryProvider.notifier);

    return repository.findFriendExpenses(selectedFriend.id);
  }
}
