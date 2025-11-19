class Summary {
  final int postId;
  final String type; // 'non_polarized' or 'polarized'
  final List<SummaryItem> summaries;
  final DateTime updatedAt;

  Summary({
    required this.postId,
    required this.type,
    required this.summaries,
    required this.updatedAt,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      postId: json['postId'],
      type: json['type'],
      summaries:
          (json['summaries'] as List<dynamic>)
              .map((item) => SummaryItem.fromJson(item))
              .toList(),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'type': type,
      'summaries': summaries.map((s) => s.toJson()).toList(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class SummaryItem {
  final String? narrative; // optional for non_polarized
  final String? summary; // starts null if comments < 10
  final int commentCount;

  SummaryItem({this.narrative, this.summary, this.commentCount = 0});

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      narrative: json['narrative'],
      summary: json['summary'],
      commentCount: json['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'narrative': narrative,
      'summary': summary,
      'commentCount': commentCount,
    };
  }
}
