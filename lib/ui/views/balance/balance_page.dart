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
  late Stream<List<Expense>> expenseStream;

  @override
  Widget build(BuildContext context) {
    ref.watch(repositoryProvider);
    final repository = ref.read(repositoryProvider.notifier);
    final selectedFriend = ref.watch(selectedFriendProvider);
    if (selectedFriend == null) {
      return _buildNoFriendSelected();
    }
    expenseStream = repository.watchFriendExpenses(selectedFriend.id);
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
        child: StreamBuilder(
            stream: expenseStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(),);
              } else if (snapshot.hasError) {
                return const Text('Error loading balance');
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text('No data available');
              } else {
                final data = snapshot.data!;
                final double balance = data.fold(0, (totalBalance, expense) => totalBalance + expense.balance);
                return Column(
                  children: [
                    _buildProfileRow(balance),
                    const SizedBox(height: 20.0),
                    _buildExpenseDetails(data),
                  ],
                );
              }
            }),
      ),
    );
  }

  Row _buildProfileRow(double balance) {
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;

    final myProfilePicture = ref.watch(profilePictureProvider);
    final selectedFriend = FriendUtils.getSelectedFriend(ref);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProfileCard(
            profile:
                FriendProfile(name: 'You', profilePicture: myProfilePicture),
            changePicture: _changeMyProfilePicture),
        // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
        Text(
          'Balance: ${balance.toStringAsFixed(2)}\$',
          style: TextStyle(
            fontSize: 16.0,
            color: balanceColor,
          ),
        ),
        _buildProfileCard(
            profile: selectedFriend!,
            changePicture: _changeSelectedFriendPicture),
      ],
    );
  }

  Widget _buildExpenseDetails(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return _buildNoExpensesCard();
    }
    return _buildHistoryCard(ref, expenses);
  }

  Card _buildProfileCard(
      {required FriendProfile profile,
      required Future Function(File selectedImage) changePicture}) {
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
            backgroundImage: profile.profilePicture.contains('assets')
                ? AssetImage(profile.profilePicture)
                : FileImage(File(profile.profilePicture)),
            radius: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(profile.name),
          TextButton(
            onPressed: () async {
              showImagePickerOptions(context, changePicture);
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

  void showImagePickerOptions(
      BuildContext context, Future Function(File selectedImage) changePicture) {
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
                  _buildImagePickerOption(context, Icons.image, 'Gallery',
                      () => _pickImage(ImageSource.gallery, changePicture)),
                  _buildImagePickerOption(context, Icons.camera_alt, 'Camera',
                      () => _pickImage(ImageSource.camera, changePicture)),
                ],
              ),
            ),
          );
        });
  }

  Expanded _buildImagePickerOption(
      BuildContext context, IconData icon, String label, Function onTap) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            Icon(icon, size: 70),
            Text(label),
          ],
        ),
      ),
    );
  }

  Future _pickImage(ImageSource source,
      Future Function(File selectedImage) changePicture) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final File selectedImage = File(image.path);
      changePicture(selectedImage);
    }
  }

  Future _changeMyProfilePicture(File selectedImage) async {
    await ref
        .read(profilePictureProvider.notifier)
        .changeProfilePicture(selectedImage, ref);
  }

  Future _changeSelectedFriendPicture(File selectedImage) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    List<String> pathSegments = selectedImage.path.split('/');
    String imageName = pathSegments.last;
    final File newImage = await selectedImage.copy('${dir.path}/$imageName');
    final profile = ref.watch(selectedFriendProvider);
    ref
        .read(repositoryProvider.notifier)
        .editFriendPicture(profile!, newImage.path);
    //todo: maybe look over this spaghetti selected friend provider
    final updatedFriend =
        await ref.read(repositoryProvider.notifier).findFriendById(profile.id);
    ref.read(selectedFriendProvider.notifier).setSelectedFriend(updatedFriend!);
  }

  Widget _buildNoExpensesCard() {
    return const Center(child: Text('There are no expenses yet!'));
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
                  builder: (context) => HistoryPage(expenses: friendExpenses),
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
