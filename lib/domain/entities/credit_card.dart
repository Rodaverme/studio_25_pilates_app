class CreditCard {
  final int id;
  final String clientId;
  final String brand;
  final String lastFour;
  final String token;
  final String expMonth;
  final String expYear;
  final String sourceId;

  CreditCard({
    required this.id,
    required this.clientId,
    required this.brand,
    required this.lastFour,
    required this.token,
    required this.expMonth,
    required this.expYear,
    required this.sourceId
  });
}
