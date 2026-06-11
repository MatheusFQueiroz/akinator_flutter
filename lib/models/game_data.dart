class GameResult {
  final List<Map<String, String>> answers;
  final String predicted;
  final String? actual;
  final DateTime timestamp;

  GameResult({
    required this.answers,
    required this.predicted,
    this.actual,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'answers': answers,
    'predicted': predicted,
    'actual': actual,
    'timestamp': timestamp.toIso8601String(),
  };

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      answers: List<Map<String, String>>.from(
        (json['answers'] as List).map((e) => Map<String, String>.from(e)),
      ),
      predicted: json['predicted'] as String,
      actual: json['actual'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class ConfusionPair {
  final String professorA;
  final String professorB;
  int count;

  ConfusionPair({
    required this.professorA,
    required this.professorB,
    this.count = 0,
  });

  String get key => professorA.compareTo(professorB) < 0
      ? '${professorA}_$professorB'
      : '${professorB}_$professorA';

  Map<String, dynamic> toJson() => {
    'professorA': professorA,
    'professorB': professorB,
    'count': count,
  };

  factory ConfusionPair.fromJson(Map<String, dynamic> json) {
    return ConfusionPair(
      professorA: json['professorA'] as String,
      professorB: json['professorB'] as String,
      count: json['count'] as int,
    );
  }
}
