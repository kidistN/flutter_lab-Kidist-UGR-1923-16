class Quote {
  final String id;
  final String text;
  final String author;
  final DateTime savedDate;
  String personalNote;
  bool isFavorite;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.savedDate,
    this.personalNote = '',
    this.isFavorite = false,
  });

  // For local storage (shared_preferences later)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'savedDate': savedDate.toIso8601String(),
      'personalNote': personalNote,
      'isFavorite': isFavorite,
    };
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      text: json['text'],
      author: json['author'],
      savedDate: DateTime.parse(json['savedDate']),
      personalNote: json['personalNote'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Copy with method for updates
  Quote copyWith({
    String? id,
    String? text,
    String? author,
    DateTime? savedDate,
    String? personalNote,
    bool? isFavorite,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      savedDate: savedDate ?? this.savedDate,
      personalNote: personalNote ?? this.personalNote,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
