class FriendProfile {
  FriendProfile(this.name, this.imageUrl, this.balance);

  String name;
  String imageUrl;
  double balance;
}

List<FriendProfile> friends = [
  FriendProfile('You', 'profile_pics/profile_picture1.jpg', 20.0),
  FriendProfile('Alex Gavrila', 'profile_pics/profile_picture2.jpg', -15.0),
  FriendProfile('James Rodriguez', 'assets/profile_pics/profile_picture3.jpg', -34),
  FriendProfile('Layla Ponta', 'assets/profile_pics/profile_picture4.jpg', 400),
  FriendProfile('Crezulo Davinci', 'assets/profile_pics/profile_picture5.jpg', 1000000),
  FriendProfile('John Doe', 'assets/profile_pics/profile_picture6.jpg', 43243),
];