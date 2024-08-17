class Expense {
  Expense({
    this.name = "",
    this.paidByUser = 0.0,
    this.paidByFriend = 0.0,
    this.description,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  String name;           // Name of the expense
  double paidByUser;     // Amount paid by you (the user)
  double paidByFriend;   // Amount paid by the friend
  DateTime date;         // Date of the expense
  String? description;   // Optional description of the expense

  // TODO: Set words limit on description (test if you have too many words how does it show in expense history)

  double get totalCost => paidByUser + paidByFriend;

  String get payer => paidByUser != 0 && paidByFriend == 0 ? "You" : (paidByUser != 0 && paidByFriend != 0 ? "Both" : "Them");
}

List<Expense> expensesTest = [
  Expense(name: 'Un Pizza Fresco', paidByUser: 24.0, description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sit amet mauris nec lacus tempus facilisis. Aenean auctor convallis pretium. Nulla a nisl eros. Nullam accumsan venenatis suscipit. Maecenas rhoncus, nisi at semper scelerisque, est arcu mattis dui, eu lobortis quam urna non ipsum. Quisque pharetra venenatis viverra. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam rutrum ligula orci, nec dignissim massa tincidunt eget. Curabitur euismod molestie dolor id feugiat. Aenean sed pellentesque sem.'),
  Expense(name: 'Aventura Park', paidByUser: 54.0, description: 'Duis laoreet quis risus ut auctor. Nullam vel feugiat ante, a tempor elit. Aliquam in quam tincidunt, viverra eros in, consequat sem. Vivamus facilisis enim in diam interdum euismod. Aenean id nunc est. Suspendisse quis iaculis libero. Morbi tristique sapien lorem, vitae tempus turpis vestibulum et. Integer eu nisi dapibus, elementum sem quis, volutpat velit. Sed arcu velit, congue ac volutpat at, hendrerit ac metus. Nullam interdum, dui a sodales pharetra, lectus sem blandit odio, sit amet tempus nunc arcu et mi. Mauris hendrerit enim nec ultrices mattis. Praesent sollicitudin in leo vitae hendrerit. Morbi et dapibus dui. '),
  Expense(name: 'Costinesti expedition', paidByUser: 150.0, paidByFriend: 230.0),
  Expense(name: 'Munich Trip', paidByFriend: 244.0),
  Expense(name: 'Germany holiday', paidByUser: 5.0),
];