class Affirmations {
  final String affirmation;

  Affirmations({required this.affirmation});

  factory Affirmations.fromJson(final json) {
    return Affirmations(affirmation: json["affirmation"]);
  }
}
