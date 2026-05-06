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

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      Id: map["Id"] ?? '',
      CardNumber: map["CardNumber"] ?? '',
      CardHolderName: map["CardHolderName"] ?? '',
      ExpiryDate: map["ExpiryDate"] ?? '',
      Cvv: map["Cvv"] ?? '',
      isChosen: map["isChosen"] ?? false,
      imgUrl:
          map["imgUrl"] ??
          'https://th.bing.com/th/id/OIP.XLxva8A-P8lZLn8yuU-aYgHaGL?w=218&h=182&c=7&r=0&o=7&dpr=2&pid=1.7&rm=3',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "Id": Id,
      "CardNumber": CardNumber,
      "CardHolderName": CardHolderName,
      "ExpiryDate": ExpiryDate,
      "Cvv": Cvv,
      "isChosen": isChosen,
      "imgUrl": imgUrl,
    };
  }

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
