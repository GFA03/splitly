import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
part 'current_friend_data.freezed.dart';

@freezed
class CurrentFriendData with _$CurrentFriendData {
  const CurrentFriendData._();

  const factory CurrentFriendData({
    @Default(<FriendProfile>[]) List<FriendProfile> currentFriends,
    @Default(<Expense>[]) List<Expense> currentExpenses,
    FriendProfile? selectedFriend,
  }) = _CurrentFriendData;

  List<Expense> get selectedFriendExpenses {
    if (selectedFriend == null) {
      return [];
    }
    return currentExpenses
        .where((expense) => expense.friendId == selectedFriend!.id)
        .toList();
  }
}
