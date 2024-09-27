import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../repositories/repository.dart';

class FriendProfile {
  // Factory constructor to create with a specific ID
  const FriendProfile.create({required String id, required String name, String? imageUrl})
      : _id = id,
        _name = name,
        _imageUrl = imageUrl;

  // Constructor to auto-generate an ID if not provided
  FriendProfile({String? id, required String name, String? imageUrl})
      : _id = id ?? const Uuid().v4(),
        _name = name,
        _imageUrl = imageUrl;

  final String _id;
  final String _name;
  final String? _imageUrl;

  String get id => _id;

  String get name => _name;

  String? get imageUrl => _imageUrl;

  // Calculate balance for this profile
  Future<double> calculateBalance(Repository repository) async {
    final expenses = await repository.findFriendExpenses(_id);
    if (expenses.isEmpty) {
      return 0;
    }
    return expenses.fold<double>(
        0, (previousValue, element) => previousValue + element.balance);
  }
}

class SelectedFriendNotifier extends StateNotifier<FriendProfile?> {
  SelectedFriendNotifier(): super(null);

  void setSelectedFriend(FriendProfile friend) {
    state = friend;
  }

  void removeSelectedFriend() {
    state = null;
  }
}


const List<FriendProfile> dummyFriendData = [
  FriendProfile.create(
      id: '24f183b5-006a-47cc-8b5d-b2bacf484765',
      name: 'Alex Gavrila',
      imageUrl: 'assets/profile_pics/profile_picture2.jpg'),
  FriendProfile.create(
      id: '458644d3-2543-41d4-9bfa-ce736f74008f',
      name: 'James Rodriguez',
      imageUrl: 'assets/profile_pics/profile_picture3.jpg'),
  FriendProfile.create(
      id: '9cbc96dc-eb41-430c-b083-0130bbde61a8',
      name: 'Layla Ponta',
      imageUrl: 'assets/profile_pics/profile_picture4.jpg'),
  FriendProfile.create(
      id: 'c3893d45-e4a2-44fe-898d-e84662d9d691',
      name: 'Crezulo Davinci',
      imageUrl: 'assets/profile_pics/profile_picture5.jpg'),
  FriendProfile.create(
      id: '5aa326ca-59b1-4280-a84a-9281e73f9d57',
      name: 'John Doe',
      imageUrl: 'assets/profile_pics/profile_picture6.jpg'),
];
