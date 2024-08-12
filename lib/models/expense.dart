class Expense {
  Expense({
    this.payer = "You",
    this.name = "",
    this.cost = 0.0,
    this.description,
  });

  String payer;
  String name;
  double cost;
  DateTime date = DateTime.now();
  String? description;
}

List<Expense> expensesTest = [
  Expense(payer: 'You', name: 'Un Pizza Fresco', cost: 24.0, description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sit amet mauris nec lacus tempus facilisis. Aenean auctor convallis pretium. Nulla a nisl eros. Nullam accumsan venenatis suscipit. Maecenas rhoncus, nisi at semper scelerisque, est arcu mattis dui, eu lobortis quam urna non ipsum. Quisque pharetra venenatis viverra. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam rutrum ligula orci, nec dignissim massa tincidunt eget. Curabitur euismod molestie dolor id feugiat. Aenean sed pellentesque sem.'),
  Expense(payer: 'You', name: 'Aventura Park', cost: 54.0, description: 'Duis laoreet quis risus ut auctor. Nullam vel feugiat ante, a tempor elit. Aliquam in quam tincidunt, viverra eros in, consequat sem. Vivamus facilisis enim in diam interdum euismod. Aenean id nunc est. Suspendisse quis iaculis libero. Morbi tristique sapien lorem, vitae tempus turpis vestibulum et. Integer eu nisi dapibus, elementum sem quis, volutpat velit. Sed arcu velit, congue ac volutpat at, hendrerit ac metus. Nullam interdum, dui a sodales pharetra, lectus sem blandit odio, sit amet tempus nunc arcu et mi. Mauris hendrerit enim nec ultrices mattis. Praesent sollicitudin in leo vitae hendrerit. Morbi et dapibus dui. '),
  Expense(payer: 'Both', name: 'Costinesti expedition', cost: 345.0),
  Expense(payer: 'Them', name: 'Munich Trip', cost: -244.0),
  Expense(payer: 'You', name: 'Germany holiday', cost: 5.0),
];