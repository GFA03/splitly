import 'package:flutter/material.dart';
import 'package:splitly/data/models/friend_profile.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profile,
  });

  final FriendProfile profile;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(profile.imageUrl),
            radius: 40,
          ),
          Text(profile.name),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Change picture',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
