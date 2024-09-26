import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
part 'current_friend_data.freezed.dart';

@freezed
class CurrentFriendData with _$CurrentFriendData {
  const CurrentFriendData._();

  const factory CurrentFriendData({
    @Default(<FriendProfile> [...dummyFriendData]) List<FriendProfile> currentFriends,
    @Default(<Expense>[]) List<Expense> currentExpenses,
  }) = _CurrentFriendData;
}
