class Mission {
  final int id;
  final String content; // Maps to title
  final List<SubMission> subMissions;

  Mission({
    required this.id,
    required this.content,
    required this.subMissions,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    var rawSubMissions = json['subMissions'] as List? ?? [];
    List<SubMission> subs =
        rawSubMissions.map((e) => SubMission.fromJson(e)).toList();

    return Mission(
      id: json['id'],
      content: json['content'] ?? '',
      subMissions: subs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'subMissions': subMissions.map((e) => e.toJson()).toList(),
    };
  }
}

class SubMission {
  final int id;
  final String title;
  final String? description;

  SubMission({
    required this.id,
    required this.title,
    this.description,
  });

  factory SubMission.fromJson(Map<String, dynamic> json) {
    return SubMission(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}
