class PaymentMethod {
  final String Id;
  final String CardNumber;
  final String CardHolderName;
  final String ExpiryDate;
  final String Cvv;
  final String imgUrl;

  final bool isChosen;

  PaymentMethod({
    required this.Id,
    required this.CardNumber,
    required this.CardHolderName,
    required this.ExpiryDate,
    required this.Cvv,
    this.isChosen = false,
    this.imgUrl =
        'https://th.bing.com/th/id/OIP.XLxva8A-P8lZLn8yuU-aYgHaGL?w=218&h=182&c=7&r=0&o=7&dpr=2&pid=1.7&rm=3',
  });

  PaymentMethod copyWith({
    String? Id,
    String? CardNumber,
    String? CardHolderName,
    String? ExpiryDate,
    String? Cvv,
    bool? isChosen,
    String? imgUrl,
  }) {
    return PaymentMethod(
      Id: Id ?? this.Id,
      CardNumber: CardNumber ?? this.CardNumber,
      CardHolderName: CardHolderName ?? this.CardHolderName,
      ExpiryDate: ExpiryDate ?? this.ExpiryDate,
      Cvv: Cvv ?? this.Cvv,
      isChosen: isChosen ?? this.isChosen,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }
}

List<PaymentMethod> paymentMethods = [
  PaymentMethod(
    Id: "1",
    CardNumber: "111111111111111111111111",
    CardHolderName: "Yousef",
    ExpiryDate: "22/3",
    Cvv: "123",
  ),
  PaymentMethod(
    Id: "2",
    CardNumber: "222222222222222222222222",
    CardHolderName: "Ahmed",
    ExpiryDate: "232/4",
    Cvv: "456",
  ),
  PaymentMethod(
    Id: "3",
    CardNumber: "333333333333333333333333",
    CardHolderName: "Gali",
    ExpiryDate: "24/5",
    Cvv: "789",
  ),
];
