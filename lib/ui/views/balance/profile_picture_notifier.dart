import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:splitly/providers.dart';

class ProfilePictureNotifier extends StateNotifier<String> {
  ProfilePictureNotifier(super.initialProfilePicture);

  Future<void> changeProfilePicture(File newImage, WidgetRef ref) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    List<String> pathSegments = newImage.path.split('/');
    String imageName = pathSegments.last;
    final File savedImage = await newImage.copy('${dir.path}/$imageName');

    // Save the new profile picture path in shared preferences
    final prefs = ref.read(sharedPrefProvider);
    prefs.setString('myProfilePicture', savedImage.path);

    // Update the state with the new profile picture path
    state = savedImage.path;
  }
}