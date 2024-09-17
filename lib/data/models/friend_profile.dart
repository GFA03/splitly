import 'package:uuid/uuid.dart';

import '../repositories/repository.dart';

class FriendProfile {
  const FriendProfile.create({required this.id, required this.name, this.imageUrl});

  FriendProfile({String? id, required this.name, this.imageUrl})
      : id = id ?? const Uuid().v4();

  final String id;
  final String name;
  final String? imageUrl;

  double calculateBalance(Repository repository) {
    final expenses = repository.findFriendExpenses(id);
    if (expenses.isEmpty) {
      return 0;
    }
    return expenses.fold<double>(
        0, (previousValue, element) => previousValue + element.balance);
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
