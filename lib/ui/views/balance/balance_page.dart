import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/ui/components/button/outlined_button.dart';
import 'package:splitly/ui/views/expenseForm/expense_form_page.dart';
import 'package:splitly/utils/friend_utils.dart';

import '../history/history_page.dart';

class BalancePage extends ConsumerStatefulWidget {
  const BalancePage({
    super.key,
    required this.name,
  });

  final String name;

  @override
  ConsumerState<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends ConsumerState<BalancePage> {
  @override
  Widget build(BuildContext context) {
    ref.watch(repositoryProvider);
    final selectedFriend = FriendUtils.getSelectedFriend(ref);
    if (selectedFriend == null) {
      return _buildNoFriendSelected();
    }
    return _buildFriendBalance(context);
  }

  Column _buildFriendBalance(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100.0,
        ),
        _welcomeUser(),
        const SizedBox(
          height: 100.0,
        ),
        _buildBalanceCard(),
        const Spacer(),
        _trackExpenseButton(context),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }

  Text _welcomeUser() {
    return Text(
      'Hello ${widget.name}',
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Card _buildBalanceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<Row>(
              future: _buildProfileRow(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading balance');
                } else {
                  return snapshot.data ?? const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20.0),
            FutureBuilder<Widget>(
              future: _buildExpenseDetails(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading expenses');
                } else {
                  return snapshot.data ?? const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Row> _buildProfileRow() async {
    final selectedFriend = FriendUtils.getSelectedFriend(ref);
    if (selectedFriend == null) {
      throw Exception('No friend selected!');
    }
    final balance = await selectedFriend
        .calculateBalance(ref.read(repositoryProvider.notifier));
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;
    // String profileImage = '/home/gfa/projects/splitly/assets/profile_pics/profile_picture1.jpg';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProfileCard(profile: FriendProfile(name: 'You')),
        // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
        Text(
          'Balance: ${balance.toStringAsFixed(2)}\$',
          style: TextStyle(
            fontSize: 16.0,
            color: balanceColor,
          ),
        ),
        _buildProfileCard(profile: selectedFriend),
      ],
    );
  }

  Future<Widget> _buildExpenseDetails(WidgetRef ref) async {
    final friendExpenses = await FriendUtils.getSelectedFriendExpenses(ref);
    if (friendExpenses.isEmpty) {
      return _buildNoExpensesCard();
    }
    return _buildHistoryCard(ref, friendExpenses);
  }

  Card _buildProfileCard({required FriendProfile profile}) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Card(
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          CircleAvatar(
            backgroundImage: profile.imageUrl == null
                ? const AssetImage(FriendUtils.defaultProfileImage)
                : FileImage(profile.imageUrl!),
            radius: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(profile.name),
          TextButton(
            onPressed: () async {
              showImagePickerOptions(context);
            },
            child: Text(
              'Change picture',
              style: textTheme.apply(displayColor: Colors.purple).bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _changeFriendPictureFromGallery();
                        Navigator.of(context).pop();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _changeFriendPictureFromCamera();
                        Navigator.of(context).pop();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _changeFriendPictureFromGallery() async {
    final File? selectedImage = await _pickImageFromGallery();
    if (selectedImage == null) {
      return;
    }
    _changePicture(selectedImage);
  }

//Gallery
  Future<File?> _pickImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image == null ? null : File(image.path);
  }

  Future _changeFriendPictureFromCamera() async {
    final File? selectedImage = await _pickImageFromCamera();
    if (selectedImage == null) {
      return;
    }
    _changePicture(selectedImage);
  }

//Camera
  Future _pickImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    return image == null ? null : File(image.path);
  }

  Future _changePicture(File selectedImage) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    List<String> pathSegments = selectedImage.path.split('/');
    String imageName = pathSegments.last;
    final File newImage = await selectedImage.copy('${dir.path}/$imageName');
    final profile = ref.watch(selectedFriendProvider);
    ref.read(repositoryProvider.notifier).editFriendPicture(profile!, newImage);
    final updatedFriend = await ref.read(repositoryProvider.notifier).findFriendById(profile.id);
    ref.read(selectedFriendProvider.notifier).setSelectedFriend(updatedFriend!);
  }

  Widget _buildNoExpensesCard() {
    return const Text('There are no expenses yet!');
  }

  Widget _buildHistoryCard(WidgetRef ref, List<Expense> friendExpenses) {
    final lastExpense = friendExpenses.last;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Last expense: ${lastExpense.name} ${lastExpense.totalCost}\$ (paid by ${lastExpense.payer})',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
            child: const Text(
              'See all history',
              style: TextStyle(decoration: TextDecoration.underline),
            )),
      ],
    );
  }

  ButtonOutlined _trackExpenseButton(BuildContext context) {
    return ButtonOutlined(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseFormPage()),
          );

          if (newExpense != null) {
            ref.read(repositoryProvider.notifier).insertExpense(newExpense);
          }
        },
        label: 'Track Expense');
  }

  Center _buildNoFriendSelected() {
    return const Center(
      child: Text('Please select a friend'),
    );
  }
}
