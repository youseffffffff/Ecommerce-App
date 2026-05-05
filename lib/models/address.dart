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
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      imgUrl:
          map['imgUrl'] ??
          'https://www.iconpacks.net/icons/1/free-pin-icon-48-thumb.png',
      isChosen: map['isChosen'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'country': country,
      'imgUrl': imgUrl,
      'isChosen': isChosen,
    };
  }

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
