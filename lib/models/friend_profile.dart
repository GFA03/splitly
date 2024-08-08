class FriendProfile {
  FriendProfile(this.name, this.imageUrl);

  String name;
  String imageUrl;
}

List<FriendProfile> friends = [
  FriendProfile('You', 'profile_pics/profile_picture1.jpg'),
  FriendProfile('Alex Gavrila', 'profile_pics/profile_picture2.jpg'),
  FriendProfile('James Rodriguez', 'assets/profile_pics/profile_picture3.jpg'),
  FriendProfile('Layla Ponta', 'assets/profile_pics/profile_picture4.jpg'),
  FriendProfile('Crezulo Davinci', 'assets/profile_pics/profile_picture5.jpg'),
  FriendProfile('John Doe', 'assets/profile_pics/profile_picture6.jpg'),
];