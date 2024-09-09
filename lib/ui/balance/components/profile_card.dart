import 'package:flutter/material.dart';
import 'package:splitly/data/models/friend_profile.dart';

String NO_PROFILE_PICTURE = 'assets/profile_pics/profile_picture6.jpg';

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
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          CircleAvatar(
            backgroundImage: AssetImage(profile.imageUrl ?? NO_PROFILE_PICTURE),
            radius: 40,
          ),
          const SizedBox(height: 10,),
          Text(profile.name
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Change picture',
              style: textTheme.apply(displayColor: Colors.purple).bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
