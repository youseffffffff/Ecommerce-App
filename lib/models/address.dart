class Address {
  final String id;
  final String city;
  final String country;
  final String imgUrl;
  final bool isChosen;

  Address({
    required this.id,
    required this.city,
    required this.country,
    this.imgUrl =
        'https://www.iconpacks.net/icons/1/free-pin-icon-48-thumb.png',
    this.isChosen = false,
  });

  Address copyWith({
    String? id,
    String? city,
    String? country,
    String? imgUrl,
    bool? isChosen,
  }) {
    return Address(
      id: id ?? this.id,
      city: city ?? this.city,
      country: country ?? this.country,
      imgUrl: imgUrl ?? this.imgUrl,
      isChosen: isChosen ?? this.isChosen,
    );
  }
}

List<Address> addresses = [
  Address(id: '1', city: 'maddina', country: 'saudi'),
  Address(id: '2', city: 'riyadh', country: 'saudi'),
  Address(id: '3', city: 'jeddah', country: 'saudi'),
];
