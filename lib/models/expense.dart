class Expense {
  Expense({
    this.payer = "You",
    this.expenseName = "",
    this.cost = 0.0,
    this.description,
  });

  //TODO: add Date variable so you can know when it was that expense

  String payer;
  String expenseName;
  double cost;
  String? description;
}

List<Expense> expensesTest = [
  Expense(payer: 'You', expenseName: 'Un Pizza Fresco', cost: 24.0),
  Expense(payer: 'You', expenseName: 'Aventura Park', cost: 54.0),
  Expense(payer: 'Both', expenseName: 'Costinesti expedition', cost: 345.0),
  Expense(payer: 'Them', expenseName: 'Munich Trip', cost: -244.0),
  Expense(payer: 'You', expenseName: 'Germany holiday', cost: 5.0),
];