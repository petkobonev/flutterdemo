class Flight {
  final int id;
  final String name;
  final bool success;
  final String urlImage;

  const Flight({
    required this.id,
    required this.name,
    required this.success,
    required this.urlImage,
  });

  factory Flight.fromJson(Map<String, dynamic> json) => Flight(
        id: json['id'],
        success: json['author'],
        name: json['title'],
        urlImage: json['links']['patch']['small'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'success': success,
        'urlImage': urlImage,
      };
}
